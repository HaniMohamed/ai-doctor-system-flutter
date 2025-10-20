import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import '../config/security_config.dart';

class SecureHttpClient {
  late Dio dio;

  SecureHttpClient() {
    dio = Dio();
    _setupCertificatePinning();
  }

  void _setupCertificatePinning() {
    final adapter = dio.httpClientAdapter;
    if (adapter is IOHttpClientAdapter) {
      // ignore: deprecated_member_use
      adapter.onHttpClientCreate = (client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) {
        return _validateCertificate(cert, host);
      };
      return client;
      };
    }
  }

  bool _validateCertificate(X509Certificate cert, String host) {
    final allowed = SecurityConfig.allowedSha256Fingerprints[host];
    if (allowed == null || allowed.isEmpty) {
      // Allow when no pin configured (e.g., localhost/dev)
      return host == 'localhost' || host.startsWith('127.');
    }

    // Compute SHA-256 of DER-encoded certificate
    final derBytes = cert.der;
    // X509Certificate in Dart doesn't expose DER directly on all platforms; some SDKs expose rawDER.
    // If not available, fallback to subject/issuer checks or platform-specific APIs.
    // Here we assume `der` is available; otherwise this needs platform channel support.
    // ignore: unnecessary_null_comparison
    if (derBytes == null) return false;

    // Manual SHA-256 since crypto not imported here; rely on String fingerprint from platform if available.
    // In production, replace with a robust DER -> SHA-256 calculation using package:crypto.
    // For now, reject unless configured fingerprints are empty (dev) or a match is provided by platform.
    return false;
  }
}


