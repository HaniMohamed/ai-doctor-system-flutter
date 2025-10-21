import '../entities/analysis_result.dart';
import '../entities/symptom.dart';
import '../repositories/symptom_checker_repository.dart';

class AnalyzeSymptomsUsecase {
  final SymptomCheckerRepository _repository;
  AnalyzeSymptomsUsecase(this._repository);

  Future<AnalysisResult> execute(List<Symptom> symptoms,
      {required int age, required String gender, required String sessionId}) {
    return _repository.analyzeSymptoms(symptoms,
        age: age, gender: gender, sessionId: sessionId);
  }
}
