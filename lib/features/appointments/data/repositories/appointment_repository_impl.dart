import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/appointment.dart';
import '../../domain/repositories/appointment_repository.dart';
import '../datasources/appointment_remote_datasource.dart';

class AppointmentRepositoryImpl implements AppointmentRepository {
  final AppointmentRemoteDataSource _remote;
  final NetworkInfo _networkInfo;

  AppointmentRepositoryImpl({
    required AppointmentRemoteDataSource remote,
    required NetworkInfo networkInfo,
  }) : _remote = remote, _networkInfo = networkInfo;

  @override
  Future<List<Appointment>> getAppointments() async {
    if (await _networkInfo.isConnected) {
      return _remote.getAppointments();
    }
    throw const CacheException('Offline and no cache implemented yet');
  }

  @override
  Future<Appointment> createAppointment(Map<String, dynamic> request) async {
    if (await _networkInfo.isConnected) {
      return _remote.createAppointment(request);
    }
    throw const CacheException('Offline create not supported');
  }

  @override
  Future<Appointment> updateAppointment(String id, Map<String, dynamic> request) async {
    if (await _networkInfo.isConnected) {
      return _remote.updateAppointment(id, request);
    }
    throw const CacheException('Offline update not supported');
  }

  @override
  Future<void> cancelAppointment(String id) async {
    if (await _networkInfo.isConnected) {
      await _remote.deleteAppointment(id);
      return;
    }
    throw const CacheException('Offline cancel not supported');
  }
}


