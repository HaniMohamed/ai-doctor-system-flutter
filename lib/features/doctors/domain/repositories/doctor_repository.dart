import '../entities/doctor.dart';

abstract class DoctorRepository {
  Future<List<Doctor>> getDoctors();
  Future<Doctor> getDoctorDetails(String id);
}


