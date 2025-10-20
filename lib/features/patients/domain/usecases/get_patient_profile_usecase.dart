import '../entities/patient.dart';
import '../repositories/patient_repository.dart';

class GetPatientProfileUsecase {
  final PatientRepository _repository;
  GetPatientProfileUsecase(this._repository);

  Future<Patient> execute(String id) => _repository.getPatientProfile(id);
}


