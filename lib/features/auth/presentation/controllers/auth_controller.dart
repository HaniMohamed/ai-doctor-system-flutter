import 'package:get/get.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/services/auth_service.dart';

class AuthController extends GetxController {
  final AuthService _authService;

  AuthController({
    required AuthService authService,
  }) : _authService = authService;

  final Rx<User?> currentUser = Rx<User?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    isLoading.value = true;
    try {
      if (_authService.isAuthenticated) {
        currentUser.value = _authService.currentUser;
      }
    } catch (e) {
      _handleError(ServerFailure(e.toString()));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final user = await _authService.login(email, password);
      currentUser.value = user;
      Get.offNamed('/dashboard');
    } catch (e) {
      _handleError(ServerFailure(e.toString()));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    isLoading.value = true;
    try {
      await _authService.logout();
      currentUser.value = null;
      Get.offNamed('/login');
    } catch (e) {
      _handleError(ServerFailure(e.toString()));
    } finally {
      isLoading.value = false;
    }
  }

  void _handleError(Failure failure) {
    errorMessage.value = failure.message;
    Get.snackbar('Error', failure.message);
  }
}
