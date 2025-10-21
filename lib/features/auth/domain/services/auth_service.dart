import '../entities/user.dart';

abstract class AuthService {
  bool get isAuthenticated;
  User? get currentUser;

  Future<User> login(String email, String password);
  Future<void> logout();
  Future<String?> getAccessToken();
  Future<void> refreshToken();
  Future<bool> validateAndRefreshToken();
  Future<void> initializeFromStorage();
}
