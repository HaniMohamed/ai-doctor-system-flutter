import '../entities/analysis_result.dart';
import '../entities/symptom.dart';
import '../repositories/symptom_checker_repository.dart';

class AnalyzeSymptomsUsecase {
  final SymptomCheckerRepository _repository;
  AnalyzeSymptomsUsecase(this._repository);

  Future<AnalysisResult> execute(List<Symptom> symptoms, {int? age, String? gender}) {
    return _repository.analyzeSymptoms(symptoms, age: age, gender: gender);
  }
}


