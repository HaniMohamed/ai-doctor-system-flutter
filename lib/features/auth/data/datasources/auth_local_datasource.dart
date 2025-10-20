import '../../../../core/storage/local_storage.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../../core/constants/storage_keys.dart';
import '../models/user_model.dart';
import '../models/auth_tokens_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> cacheTokens(AuthTokensModel tokens);
  Future<AuthTokensModel?> getCachedTokens();
  Future<void> clearCache();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final LocalStorage _localStorage;
  final SecureStorage _secureStorage;

  AuthLocalDataSourceImpl({
    required LocalStorage localStorage,
    required SecureStorage secureStorage,
  }) : _localStorage = localStorage,
       _secureStorage = secureStorage;

  @override
  Future<void> cacheUser(UserModel user) async {
    await _localStorage.setString(StorageKeys.userData, user.toJson());
  }

  @override
  Future<UserModel?> getCachedUser() async {
    final userData = _localStorage.getString(StorageKeys.userData);
    if (userData != null) {
      return UserModel.fromJson(userData);
    }
    return null;
  }

  @override
  Future<void> cacheTokens(AuthTokensModel tokens) async {
    await _secureStorage.write(StorageKeys.accessToken, tokens.accessToken);
    await _secureStorage.write(StorageKeys.refreshToken, tokens.refreshToken);
  }

  @override
  Future<AuthTokensModel?> getCachedTokens() async {
    final accessToken = await _secureStorage.read(StorageKeys.accessToken);
    final refreshToken = await _secureStorage.read(StorageKeys.refreshToken);
    
    if (accessToken != null && refreshToken != null) {
      return AuthTokensModel(
        accessToken: accessToken,
        refreshToken: refreshToken,
        tokenType: 'Bearer',
        expiresIn: 3600,
      );
    }
    return null;
  }

  @override
  Future<void> clearCache() async {
    await _localStorage.remove(StorageKeys.userData);
    await _secureStorage.delete(StorageKeys.accessToken);
    await _secureStorage.delete(StorageKeys.refreshToken);
  }
}
