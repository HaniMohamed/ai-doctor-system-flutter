import '../entities/user.dart';
import '../entities/auth_tokens.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<void> logout();
  Future<User> getCurrentUser();
  Future<AuthTokens> refreshToken(String refreshToken);
  Future<bool> isAuthenticated();
}
