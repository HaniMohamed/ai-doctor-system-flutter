import '../../../../core/network/network_info.dart';
import '../../domain/entities/doctor.dart';
import '../../domain/repositories/doctor_repository.dart';
import '../datasources/doctor_remote_datasource.dart';

class DoctorRepositoryImpl implements DoctorRepository {
  final DoctorRemoteDataSource _remote;
  final NetworkInfo _networkInfo;

  DoctorRepositoryImpl({required DoctorRemoteDataSource remote, required NetworkInfo networkInfo})
      : _remote = remote,
        _networkInfo = networkInfo;

  @override
  Future<List<Doctor>> getDoctors() async {
    if (await _networkInfo.isConnected) {
      return _remote.getDoctors();
    }
    return [];
  }

  @override
  Future<Doctor> getDoctorDetails(String id) async {
    return _remote.getDoctorDetails(id);
  }
}


