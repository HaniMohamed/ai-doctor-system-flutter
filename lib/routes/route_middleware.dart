import 'package:get/get.dart';
import '../core/di/service_locator.dart';
import '../features/auth/domain/services/auth_service.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authService = Get.find<AuthService>();
    
    // Check if user is authenticated
    if (!authService.isAuthenticated) {
      return const RouteSettings(name: '/login');
    }
    
    return null;
  }
}

class GuestMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authService = Get.find<AuthService>();
    
    // Redirect authenticated users away from auth pages
    if (authService.isAuthenticated) {
      return const RouteSettings(name: '/dashboard');
    }
    
    return null;
  }
}

class RoleMiddleware extends GetMiddleware {
  final List<String> allowedRoles;
  
  RoleMiddleware({required this.allowedRoles});
  
  @override
  RouteSettings? redirect(String? route) {
    final authService = Get.find<AuthService>();
    final user = authService.currentUser;
    
    if (user == null || !allowedRoles.contains(user.role)) {
      return const RouteSettings(name: '/dashboard');
    }
    
    return null;
  }
}
