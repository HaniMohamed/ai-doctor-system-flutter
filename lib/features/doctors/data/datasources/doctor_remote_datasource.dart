import '../../../../core/network/api_client.dart';
import '../models/doctor_model.dart';

abstract class DoctorRemoteDataSource {
  Future<List<DoctorModel>> getDoctors();
  Future<DoctorModel> getDoctorDetails(String id);
}

class DoctorRemoteDataSourceImpl implements DoctorRemoteDataSource {
  final ApiClient _apiClient;
  DoctorRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<DoctorModel>> getDoctors() async {
    final res = await _apiClient.get('/doctors');
    final list = (res.data as List).cast<Map<String, dynamic>>();
    return list.map((j) => DoctorModel.fromJson(j)).toList();
  }

  @override
  Future<DoctorModel> getDoctorDetails(String id) async {
    final res = await _apiClient.get('/doctors/$id');
    return DoctorModel.fromJson(res.data);
  }
}


