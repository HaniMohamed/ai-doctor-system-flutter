import 'package:get/get.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/storage/local_storage.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../data/datasources/auth_local_datasource.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // Data sources
    Get.lazyPut<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
    );
    Get.lazyPut<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(
        localStorage: sl<LocalStorage>(),
        secureStorage: sl<SecureStorage>(),
      ),
    );

    // Repository
    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(
        remoteDataSource: Get.find(),
        localDataSource: Get.find(),
        networkInfo: sl<NetworkInfo>(),
      ),
    );

    // Use cases
    Get.lazyPut<LoginUsecase>(() => LoginUsecase(Get.find()));
    Get.lazyPut<LogoutUsecase>(() => LogoutUsecase(Get.find()));
    Get.lazyPut<GetCurrentUserUsecase>(() => GetCurrentUserUsecase(Get.find()));

    // Controller
    Get.lazyPut<AuthController>(
      () => AuthController(
        loginUsecase: Get.find(),
        logoutUsecase: Get.find(),
        getCurrentUserUsecase: Get.find(),
      ),
    );
  }
}
