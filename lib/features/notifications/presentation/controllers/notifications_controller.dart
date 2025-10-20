import 'package:get/get.dart';
import '../../domain/entities/notification.dart';
import '../../domain/usecases/get_notifications_usecase.dart';

class NotificationsController extends GetxController {
  final GetNotificationsUsecase _getNotificationsUsecase;
  NotificationsController(this._getNotificationsUsecase);

  final RxList<AppNotification> notifications = <AppNotification>[] .obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final list = await _getNotificationsUsecase.execute();
      notifications.assignAll(list);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}


