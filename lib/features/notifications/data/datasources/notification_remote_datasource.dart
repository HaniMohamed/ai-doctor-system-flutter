import '../../../../core/network/api_client.dart';
import '../models/notification_model.dart';

abstract class NotificationRemoteDataSource {
  Future<List<AppNotificationModel>> getNotifications();
  Future<void> markAsRead(String id);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final ApiClient _apiClient;
  NotificationRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<AppNotificationModel>> getNotifications() async {
    final res = await _apiClient.get('/notifications');
    final list = (res.data as List).cast<Map<String, dynamic>>();
    return list.map((j) => AppNotificationModel.fromJson(j)).toList();
  }

  @override
  Future<void> markAsRead(String id) async {
    await _apiClient.post('/notifications/$id/read');
  }
}


