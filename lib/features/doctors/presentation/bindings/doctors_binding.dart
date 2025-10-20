import 'package:get/get.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/network_info.dart';
import '../../data/datasources/doctor_remote_datasource.dart';
import '../../data/repositories/doctor_repository_impl.dart';
import '../../domain/repositories/doctor_repository.dart';
import '../../domain/usecases/get_doctors_usecase.dart';
import '../controllers/doctors_controller.dart';

class DoctorsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DoctorRemoteDataSource>(() => DoctorRemoteDataSourceImpl(sl<ApiClient>()));
    Get.lazyPut<DoctorRepository>(() => DoctorRepositoryImpl(
      remote: Get.find(),
      networkInfo: sl<NetworkInfo>(),
    ));
    Get.lazyPut<GetDoctorsUsecase>(() => GetDoctorsUsecase(Get.find()));
    Get.lazyPut<DoctorsController>(() => DoctorsController(Get.find()));
  }
}


