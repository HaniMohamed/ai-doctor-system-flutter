import '../entities/doctor.dart';
import '../repositories/doctor_repository.dart';

class GetDoctorsUsecase {
  final DoctorRepository _repository;
  GetDoctorsUsecase(this._repository);

  Future<List<Doctor>> execute() => _repository.getDoctors();
}


