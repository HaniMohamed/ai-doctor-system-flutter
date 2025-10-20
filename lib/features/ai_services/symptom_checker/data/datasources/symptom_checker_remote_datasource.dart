import '../../domain/entities/analysis_result.dart';
import '../../domain/entities/symptom.dart';
import '../../domain/repositories/symptom_checker_repository.dart';
import '../../data/models/analysis_result_model.dart';
import '../../../../../core/network/api_client.dart';

abstract class SymptomCheckerRemoteDataSource {
  Future<AnalysisResult> analyzeSymptoms(List<Symptom> symptoms, {int? age, String? gender});
}

class SymptomCheckerRemoteDataSourceImpl implements SymptomCheckerRemoteDataSource {
  final ApiClient _apiClient;
  SymptomCheckerRemoteDataSourceImpl(this._apiClient);

  @override
  Future<AnalysisResult> analyzeSymptoms(List<Symptom> symptoms, {int? age, String? gender}) async {
    final payload = {
      'symptoms': symptoms.map((s) => {'name': s.name, 'severity': s.severity}).toList(),
      if (age != null) 'age': age,
      if (gender != null) 'gender': gender,
    };
    final res = await _apiClient.post('/ai/symptom-checker/analyze', data: payload);
    return AnalysisResultModel.fromJson(res.data);
  }
}


