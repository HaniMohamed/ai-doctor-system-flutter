import 'package:get/get.dart';
import '../../data/datasources/profile_remote_datasource.dart';
import '../../data/datasources/profile_local_datasource.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/usecases/get_user_profile_usecase.dart';
import '../../domain/usecases/update_user_profile_usecase.dart';
import '../controllers/profile_controller.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/storage/local_storage.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileRemoteDataSource>(
      () => ProfileRemoteDataSourceImpl(sl<ApiClient>()),
    );
    Get.lazyPut<ProfileLocalDataSource>(
      () => ProfileLocalDataSourceImpl(sl<LocalStorage>()),
    );
    Get.lazyPut<ProfileRepository>(
      () => ProfileRepositoryImpl(
        remote: Get.find(),
        local: Get.find(),
        networkInfo: sl<NetworkInfo>(),
      ),
    );
    Get.lazyPut<GetUserProfileUsecase>(() => GetUserProfileUsecase(Get.find()));
    Get.lazyPut<UpdateUserProfileUsecase>(() => UpdateUserProfileUsecase(Get.find()));
    Get.lazyPut<ProfileController>(() => ProfileController(
      getUserProfileUsecase: Get.find(),
      updateUserProfileUsecase: Get.find(),
    ));
  }
}


