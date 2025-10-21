import '../entities/analysis_result.dart';
import '../entities/symptom.dart';

abstract class SymptomCheckerRepository {
  Future<AnalysisResult> analyzeSymptoms(List<Symptom> symptoms,
      {required int age, required String gender});
}
