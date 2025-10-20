import '../entities/notification.dart';
import '../repositories/notification_repository.dart';

class GetNotificationsUsecase {
  final NotificationRepository _repository;
  GetNotificationsUsecase(this._repository);

  Future<List<AppNotification>> execute() => _repository.getNotifications();
}


