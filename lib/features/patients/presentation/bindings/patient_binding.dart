import 'package:get/get.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/network_info.dart';
import '../../data/datasources/patient_remote_datasource.dart';
import '../../data/repositories/patient_repository_impl.dart';
import '../../domain/repositories/patient_repository.dart';
import '../../domain/usecases/get_patient_profile_usecase.dart';
import '../controllers/patient_controller.dart';

class PatientBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PatientRemoteDataSource>(() => PatientRemoteDataSourceImpl(sl<ApiClient>()));
    Get.lazyPut<PatientRepository>(() => PatientRepositoryImpl(
          remote: Get.find(),
          networkInfo: sl<NetworkInfo>(),
        ));
    Get.lazyPut<GetPatientProfileUsecase>(() => GetPatientProfileUsecase(Get.find()));
    Get.lazyPut<PatientController>(() => PatientController(Get.find()));
  }
}


