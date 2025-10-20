import '../../../../core/network/api_client.dart';
import '../models/appointment_model.dart';

abstract class AppointmentRemoteDataSource {
  Future<List<AppointmentModel>> getAppointments();
  Future<AppointmentModel> createAppointment(Map<String, dynamic> request);
  Future<AppointmentModel> updateAppointment(String id, Map<String, dynamic> request);
  Future<void> deleteAppointment(String id);
}

class AppointmentRemoteDataSourceImpl implements AppointmentRemoteDataSource {
  final ApiClient _apiClient;
  AppointmentRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<AppointmentModel>> getAppointments() async {
    final res = await _apiClient.get('/appointments');
    final list = (res.data as List).cast<Map<String, dynamic>>();
    return list.map((j) => AppointmentModel.fromJson(j)).toList();
  }

  @override
  Future<AppointmentModel> createAppointment(Map<String, dynamic> request) async {
    final res = await _apiClient.post('/appointments', data: request);
    return AppointmentModel.fromJson(res.data);
  }

  @override
  Future<AppointmentModel> updateAppointment(String id, Map<String, dynamic> request) async {
    final res = await _apiClient.post('/appointments/$id', data: request);
    return AppointmentModel.fromJson(res.data);
  }

  @override
  Future<void> deleteAppointment(String id) async {
    await _apiClient.post('/appointments/$id/delete');
  }
}


