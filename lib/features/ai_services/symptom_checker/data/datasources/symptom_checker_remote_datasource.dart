import '../../../../../core/network/api_client.dart';
import '../../data/models/analysis_result_model.dart';
import '../../domain/entities/analysis_result.dart';
import '../../domain/entities/symptom.dart';

abstract class SymptomCheckerRemoteDataSource {
  Future<AnalysisResult> analyzeSymptoms(List<Symptom> symptoms,
      {int? age, String? gender});
}

class SymptomCheckerRemoteDataSourceImpl
    implements SymptomCheckerRemoteDataSource {
  final ApiClient _apiClient;
  SymptomCheckerRemoteDataSourceImpl(this._apiClient);

  @override
  Future<AnalysisResult> analyzeSymptoms(List<Symptom> symptoms,
      {int? age, String? gender}) async {
    final payload = {
      'symptoms': symptoms.map((s) => s.name).join(', '),
      if (age != null) 'age': age,
      if (gender != null) 'gender': gender,
    };
    final res = await _apiClient.post('/ai/symptom-checker', data: payload);

    // Extract data from the API response structure
    final responseData = res.data['data'] as Map<String, dynamic>;
    return AnalysisResultModel.fromJson(responseData);
  }
}
