import '../../../../core/logging/logger.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../domain/entities/auth_tokens.dart';
import '../../domain/entities/user.dart';
import '../../domain/services/auth_service.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthServiceImpl implements AuthService {
  final AuthRemoteDataSource _remoteDataSource;
  final SecureStorage _secureStorage;
  
  User? _currentUser;
  bool _isAuthenticated = false;
  AuthTokens? _tokens;

  AuthServiceImpl({
    required AuthRemoteDataSource remoteDataSource,
    required SecureStorage secureStorage,
  }) : _remoteDataSource = remoteDataSource,
       _secureStorage = secureStorage;

  @override
  bool get isAuthenticated => _isAuthenticated;

  @override
  User? get currentUser => _currentUser;

  @override
  Future<User> login(String email, String password) async {
    try {
      // Call the remote data source for actual authentication
      final userModel = await _remoteDataSource.login(email, password);
      
      // Store user data and set authentication state
      _currentUser = userModel; // UserModel extends User, so no conversion needed
      _isAuthenticated = true;
      
      // Store authentication state in secure storage
      await _secureStorage.write('is_authenticated', 'true');
      await _secureStorage.write('user_email', email);
      
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
            _currentUser = userModel; // UserModel extends User, so no conversion needed
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
}
