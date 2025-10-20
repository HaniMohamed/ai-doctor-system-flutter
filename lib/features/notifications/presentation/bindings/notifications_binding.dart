import 'package:get/get.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/network_info.dart';
import '../../data/datasources/notification_remote_datasource.dart';
import '../../data/repositories/notification_repository_impl.dart';
import '../../domain/repositories/notification_repository.dart';
import '../../domain/usecases/get_notifications_usecase.dart';
import '../controllers/notifications_controller.dart';

class NotificationsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationRemoteDataSource>(() => NotificationRemoteDataSourceImpl(sl<ApiClient>()));
    Get.lazyPut<NotificationRepository>(() => NotificationRepositoryImpl(
          remote: Get.find(),
          networkInfo: sl<NetworkInfo>(),
        ));
    Get.lazyPut<GetNotificationsUsecase>(() => GetNotificationsUsecase(Get.find()));
    Get.lazyPut<NotificationsController>(() => NotificationsController(Get.find()));
  }
}


