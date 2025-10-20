import '../entities/patient.dart';

abstract class PatientRepository {
  Future<Patient> getPatientProfile(String id);
}


