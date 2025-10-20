import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/auth_tokens.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/auth_tokens_model.dart';
import '../models/login_response_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource,
        _networkInfo = networkInfo;

  @override
  Future<User> login(String email, String password) async {
    if (await _networkInfo.isConnected) {
      try {
        final LoginResponseModel loginResponse =
            await _remoteDataSource.login(email, password);
        // Cache user and tokens so interceptor can attach Authorization header
        await _localDataSource.cacheUser(loginResponse.user as dynamic);
        await _localDataSource.cacheTokens(AuthTokensModel(
          accessToken: loginResponse.accessToken,
          refreshToken: '',
          tokenType: loginResponse.tokenType,
          expiresIn: loginResponse.expiresIn,
        ));
        return loginResponse.user;
      } catch (e) {
        throw ServerException(e.toString());
      }
    } else {
      throw const CacheException('No internet connection');
    }
  }

  @override
  Future<void> logout() async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.logout();
      } catch (e) {
        // Continue with local logout even if remote fails
      }
    }
    await _localDataSource.clearCache();
  }

  @override
  Future<User> getCurrentUser() async {
    if (await _networkInfo.isConnected) {
      try {
        final user = await _remoteDataSource.getCurrentUser();
        await _localDataSource.cacheUser(user);
        return user;
      } catch (e) {
        // Fallback to local data
        final cachedUser = await _localDataSource.getCachedUser();
        if (cachedUser != null) {
          return cachedUser;
        }
        throw ServerException(e.toString());
      }
    } else {
      // Offline mode
      final cachedUser = await _localDataSource.getCachedUser();
      if (cachedUser != null) {
        return cachedUser;
      }
      throw const CacheException('No cached user data');
    }
  }

  @override
  Future<AuthTokens> refreshToken(String refreshToken) async {
    if (await _networkInfo.isConnected) {
      try {
        final tokens = await _remoteDataSource.refreshToken(refreshToken);
        await _localDataSource.cacheTokens(tokens);
        return tokens;
      } catch (e) {
        throw ServerException(e.toString());
      }
    } else {
      throw const CacheException('No internet connection');
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    final cachedTokens = await _localDataSource.getCachedTokens();
    return cachedTokens != null;
  }
}
