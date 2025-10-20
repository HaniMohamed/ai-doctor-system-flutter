import '../../domain/entities/user.dart';
import '../../domain/services/auth_service.dart';

class AuthServiceImpl implements AuthService {
  User? _currentUser;
  bool _isAuthenticated = false;

  @override
  bool get isAuthenticated => _isAuthenticated;

  @override
  User? get currentUser => _currentUser;

  @override
  Future<User> login(String email, String password) async {
    // TODO: Implement actual login logic
    await Future.delayed(const Duration(seconds: 1));
    
    _currentUser = User(
      id: 'user-123',
      email: email,
      fullName: 'Test User',
      role: 'patient',
      organizationId: 'org-123',
    );
    _isAuthenticated = true;
    
    return _currentUser!;
  }

  @override
  Future<void> logout() async {
    _currentUser = null;
    _isAuthenticated = false;
  }

  @override
  Future<String?> getAccessToken() async {
    // TODO: Implement token retrieval
    return 'mock-token';
  }

  @override
  Future<void> refreshToken() async {
    // TODO: Implement token refresh
  }
}
