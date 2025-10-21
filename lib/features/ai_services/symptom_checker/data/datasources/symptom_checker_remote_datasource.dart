import 'package:dio/dio.dart';
import '../../../../../core/network/api_client.dart';
import '../../data/models/analysis_result_model.dart';
import '../../domain/entities/analysis_result.dart';
import '../../domain/entities/symptom.dart';

abstract class SymptomCheckerRemoteDataSource {
  Future<AnalysisResult> analyzeSymptoms(List<Symptom> symptoms,
      {required int age, required String gender});
}

class SymptomCheckerRemoteDataSourceImpl
    implements SymptomCheckerRemoteDataSource {
  final ApiClient _apiClient;
  SymptomCheckerRemoteDataSourceImpl(this._apiClient);

  @override
  Future<AnalysisResult> analyzeSymptoms(List<Symptom> symptoms,
      {required int age, required String gender}) async {
    final payload = {
      'symptoms': symptoms.map((s) => s.name).join(', '),
      'session_id': '', // Empty session_id as shown in example
      'age': age,
      'gender': gender,
    };

    final res = await _apiClient.post(
      '/ai/symptom-checker',
      data: payload,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    // Extract data from the API response structure
    final responseData = res.data['data'] as Map<String, dynamic>;
    return AnalysisResultModel.fromJson(responseData);
  }
}
