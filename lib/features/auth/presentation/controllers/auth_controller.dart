import 'package:get/get.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';

class AuthController extends GetxController {
  final LoginUsecase _loginUsecase;
  final LogoutUsecase _logoutUsecase;
  final GetCurrentUserUsecase _getCurrentUserUsecase;

  AuthController({
    required LoginUsecase loginUsecase,
    required LogoutUsecase logoutUsecase,
    required GetCurrentUserUsecase getCurrentUserUsecase,
  }) : _loginUsecase = loginUsecase,
       _logoutUsecase = logoutUsecase,
       _getCurrentUserUsecase = getCurrentUserUsecase;

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
      final result = await _getCurrentUserUsecase.execute();
      result.fold(
        (failure) => _handleError(failure),
        (user) => currentUser.value = user,
      );
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
      final result = await _loginUsecase.execute(email, password);
      result.fold(
        (failure) => _handleError(failure),
        (user) {
          currentUser.value = user;
          Get.offNamed('/dashboard');
        },
      );
    } catch (e) {
      _handleError(ServerFailure(e.toString()));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    isLoading.value = true;
    try {
      final result = await _logoutUsecase.execute();
      result.fold(
        (failure) => _handleError(failure),
        (_) {
          currentUser.value = null;
          Get.offNamed('/login');
        },
      );
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
