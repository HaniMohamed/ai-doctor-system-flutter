import 'package:get/get.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/network_info.dart';
import '../../data/datasources/appointment_remote_datasource.dart';
import '../../data/repositories/appointment_repository_impl.dart';
import '../../domain/repositories/appointment_repository.dart';
import '../../domain/usecases/get_appointments_usecase.dart';
import '../controllers/appointments_controller.dart';

class AppointmentsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AppointmentRemoteDataSource>(() => AppointmentRemoteDataSourceImpl(sl<ApiClient>()));
    Get.lazyPut<AppointmentRepository>(() => AppointmentRepositoryImpl(
          remote: Get.find(),
          networkInfo: sl<NetworkInfo>(),
        ));
    Get.lazyPut<GetAppointmentsUsecase>(() => GetAppointmentsUsecase(Get.find()));
    Get.lazyPut<AppointmentsController>(() => AppointmentsController(Get.find()));
  }
}


