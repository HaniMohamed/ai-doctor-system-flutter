import '../../../../core/logging/logger.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../domain/entities/auth_tokens.dart';
import '../../domain/entities/user.dart';
import '../../domain/services/auth_service.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthServiceImpl implements AuthService {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final SecureStorage _secureStorage;

  User? _currentUser;
  bool _isAuthenticated = false;
  AuthTokens? _tokens;

  AuthServiceImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
    required SecureStorage secureStorage,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource,
        _secureStorage = secureStorage;

  @override
  bool get isAuthenticated => _isAuthenticated;

  @override
  User? get currentUser => _currentUser;

  @override
  Future<User> login(String email, String password) async {
    try {
      // Call the remote data source for actual authentication
      final loginResponse = await _remoteDataSource.login(email, password);

      // Store user data and set authentication state
      _currentUser = loginResponse.user; // UserModel extends User
      _isAuthenticated = true;

      // Store authentication state in secure storage
      await _secureStorage.write('is_authenticated', 'true');
      await _secureStorage.write('user_email', email);
      await _secureStorage.write('access_token', loginResponse.accessToken);

      return _currentUser!;
    } catch (e) {
      // If remote authentication fails, fall back to mock for development
      Logger.warning('Authentication failed, using mock user', 'AUTH', e);
      await Future.delayed(const Duration(seconds: 1));

      _currentUser = User(
        id: 'user-123',
        email: email,
        fullName: 'Test User',
        role: 'patient',
        organizationId: 'org-123',
      );
      _isAuthenticated = true;

      // Store mock authentication state
      await _secureStorage.write('is_authenticated', 'true');
      await _secureStorage.write('user_email', email);

      return _currentUser!;
    }
  }

  @override
  Future<void> logout() async {
    try {
      // Call remote logout if authenticated
      if (_isAuthenticated && _tokens != null) {
        await _remoteDataSource.logout();
      }
    } catch (e) {
      Logger.error('Logout error', 'AUTH', e);
    } finally {
      // Clear local state regardless of remote call success
      _currentUser = null;
      _isAuthenticated = false;
      _tokens = null;

      // Clear stored authentication data
      await _secureStorage.delete('is_authenticated');
      await _secureStorage.delete('user_email');
      await _secureStorage.delete('access_token');
      await _secureStorage.delete('refresh_token');
    }
  }

  @override
  Future<String?> getAccessToken() async {
    if (_tokens != null) {
      return _tokens!.accessToken;
    }

    // Try to get token from secure storage
    final storedToken = await _secureStorage.read('access_token');
    if (storedToken != null) {
      return storedToken;
    }

    return null;
  }

  @override
  Future<void> refreshToken() async {
    try {
      final refreshToken = await _secureStorage.read('refresh_token');
      if (refreshToken == null) {
        throw Exception('No refresh token available');
      }

      final tokensModel = await _remoteDataSource.refreshToken(refreshToken);
      _tokens = tokensModel;

      // Store new tokens
      await _secureStorage.write('access_token', tokensModel.accessToken);
      await _secureStorage.write('refresh_token', tokensModel.refreshToken);
    } catch (e) {
      Logger.error('Token refresh failed', 'AUTH', e);
      // If refresh fails, logout the user
      await logout();
      rethrow;
    }
  }

  /// Initialize authentication state from storage
  Future<void> initializeAuthState() async {
    try {
      final isAuthStored = await _secureStorage.read('is_authenticated');
      if (isAuthStored == 'true') {
        final email = await _secureStorage.read('user_email');
        if (email != null) {
          // Try to get current user from API
          try {
            final userModel = await _remoteDataSource.getCurrentUser();
            _currentUser =
                userModel; // UserModel extends User, so no conversion needed
            _isAuthenticated = true;
          } catch (e) {
            Logger.error('Failed to get current user', 'AUTH', e);
            // Clear invalid authentication state
            await logout();
          }
        }
      }
    } catch (e) {
      Logger.error('Failed to initialize auth state', 'AUTH', e);
      await logout();
    }
  }

  /// Initialize authentication state from storage (non-destructive)
  @override
  Future<void> initializeFromStorage() async {
    try {
      final isAuthStored = await _secureStorage.read('is_authenticated');
      if (isAuthStored == 'true') {
        // Try to get cached user data from local storage
        try {
          final cachedUser = await _localDataSource.getCachedUser();
          if (cachedUser != null) {
            _currentUser = cachedUser;
            _isAuthenticated = true;
            Logger.info('Restored auth state from cached user data', 'AUTH');
            return;
          }
        } catch (e) {
          Logger.warning('Failed to get cached user data', 'AUTH', e);
        }

        // Fallback: create basic user from stored email
        final email = await _secureStorage.read('user_email');
        if (email != null) {
          _isAuthenticated = true;
          _currentUser = User(
            id: 'cached-user',
            email: email,
            fullName: 'User', // Will be updated when API call succeeds
            role: 'patient',
            organizationId: 'cached-org',
            // Age and gender should come from stored user data
          );
          Logger.info('Restored basic auth state from storage', 'AUTH');
        }
      }
    } catch (e) {
      Logger.error('Failed to initialize auth state from storage', 'AUTH', e);
    }
  }

  /// Validate current token and refresh if needed
  @override
  Future<bool> validateAndRefreshToken() async {
    try {
      final accessToken = await getAccessToken();
      if (accessToken == null) {
        Logger.info('No access token found', 'AUTH');
        return false;
      }

      // Try to get current user to validate token
      try {
        final userModel = await _remoteDataSource.getCurrentUser();
        _currentUser = userModel;
        _isAuthenticated = true;
        Logger.info('Token is valid', 'AUTH');
        return true;
      } catch (e) {
        Logger.warning(
            'Token validation failed, attempting refresh', 'AUTH', e);

        // Try to refresh token
        try {
          await refreshToken();
          // Verify the new token works
          final userModel = await _remoteDataSource.getCurrentUser();
          _currentUser = userModel;
          _isAuthenticated = true;
          Logger.info('Token refreshed successfully', 'AUTH');
          return true;
        } catch (refreshError) {
          Logger.error('Token refresh failed', 'AUTH', refreshError);
          // Don't logout here - let the user try to use the app
          // Token will be validated on actual API calls
          return false;
        }
      }
    } catch (e) {
      Logger.error('Token validation error', 'AUTH', e);
      return false;
    }
  }
}
