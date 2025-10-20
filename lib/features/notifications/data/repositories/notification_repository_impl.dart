import '../../../../core/network/network_info.dart';
import '../datasources/notification_remote_datasource.dart';
import '../../domain/entities/notification.dart';
import '../../domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource _remote;
  final NetworkInfo _networkInfo;

  NotificationRepositoryImpl({required NotificationRemoteDataSource remote, required NetworkInfo networkInfo})
      : _remote = remote,
        _networkInfo = networkInfo;

  @override
  Future<List<AppNotification>> getNotifications() async {
    if (await _networkInfo.isConnected) {
      return _remote.getNotifications();
    }
    return [];
  }

  @override
  Future<void> markAsRead(String id) async {
    if (await _networkInfo.isConnected) {
      await _remote.markAsRead(id);
    }
  }
}


