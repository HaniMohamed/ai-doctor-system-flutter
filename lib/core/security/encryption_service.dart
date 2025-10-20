import 'dart:convert';
import 'dart:math';
import 'package:cryptography/cryptography.dart';
import '../storage/secure_storage.dart';

class EncryptionService {
  static const String _keyStorageKey = 'encryption_key_v1';
  final SecretBoxAlgorithm _algorithm = AesGcm.with256bits();
  final SecureStorage _secureStorage;

  EncryptionService(this._secureStorage);

  Future<SecretKey> _getOrCreateKey() async {
    final existing = await _secureStorage.read(_keyStorageKey);
    if (existing != null) {
      final raw = base64Decode(existing);
      return SecretKey(raw);
    }
    final random = Random.secure();
    final keyBytes = List<int>.generate(32, (_) => random.nextInt(256));
    final b64 = base64Encode(keyBytes);
    await _secureStorage.write(_keyStorageKey, b64);
    return SecretKey(keyBytes);
  }

  Future<String> encrypt(String plaintext) async {
    final key = await _getOrCreateKey();
    final nonce = _algorithm.newNonce();
    final secretBox = await _algorithm.encrypt(
      utf8.encode(plaintext),
      secretKey: key,
      nonce: await nonce,
    );
    final payload = jsonEncode({
      'n': base64Encode(secretBox.nonce),
      'c': base64Encode(secretBox.cipherText),
      't': base64Encode(secretBox.mac.bytes),
    });
    return payload;
  }

  Future<String> decrypt(String encryptedData) async {
    final key = await _getOrCreateKey();
    final map = jsonDecode(encryptedData) as Map<String, dynamic>;
    final nonce = base64Decode(map['n'] as String);
    final cipherText = base64Decode(map['c'] as String);
    final tag = base64Decode(map['t'] as String);

    final box = SecretBox(cipherText, nonce: nonce, mac: Mac(tag));
    final clear = await _algorithm.decrypt(box, secretKey: key);
    return utf8.decode(clear);
  }
}


