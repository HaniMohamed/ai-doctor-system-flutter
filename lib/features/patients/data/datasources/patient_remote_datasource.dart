import '../../../../core/network/api_client.dart';
import '../models/patient_model.dart';

abstract class PatientRemoteDataSource {
  Future<PatientModel> getPatientProfile(String id);
}

class PatientRemoteDataSourceImpl implements PatientRemoteDataSource {
  final ApiClient _apiClient;
  PatientRemoteDataSourceImpl(this._apiClient);

  @override
  Future<PatientModel> getPatientProfile(String id) async {
    final res = await _apiClient.get('/patients/$id');
    return PatientModel.fromJson(res.data);
  }
}


