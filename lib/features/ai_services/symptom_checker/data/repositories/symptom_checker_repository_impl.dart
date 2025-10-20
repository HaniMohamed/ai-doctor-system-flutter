import '../../domain/entities/analysis_result.dart';
import '../../domain/entities/symptom.dart';
import '../../domain/repositories/symptom_checker_repository.dart';
import '../datasources/symptom_checker_remote_datasource.dart';

class SymptomCheckerRepositoryImpl implements SymptomCheckerRepository {
  final SymptomCheckerRemoteDataSource _remote;
  SymptomCheckerRepositoryImpl(this._remote);

  @override
  Future<AnalysisResult> analyzeSymptoms(List<Symptom> symptoms, {int? age, String? gender}) {
    return _remote.analyzeSymptoms(symptoms, age: age, gender: gender);
  }
}


