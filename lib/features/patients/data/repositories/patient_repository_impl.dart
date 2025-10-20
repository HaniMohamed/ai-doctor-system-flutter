import '../../../../core/network/network_info.dart';
import '../datasources/patient_remote_datasource.dart';
import '../../domain/entities/patient.dart';
import '../../domain/repositories/patient_repository.dart';

class PatientRepositoryImpl implements PatientRepository {
  final PatientRemoteDataSource _remote;
  final NetworkInfo _networkInfo;

  PatientRepositoryImpl({required PatientRemoteDataSource remote, required NetworkInfo networkInfo})
      : _remote = remote,
        _networkInfo = networkInfo;

  @override
  Future<Patient> getPatientProfile(String id) async {
    if (await _networkInfo.isConnected) {
      return _remote.getPatientProfile(id);
    }
    throw Exception('Offline');
  }
}


