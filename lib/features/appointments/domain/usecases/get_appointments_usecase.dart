import '../entities/appointment.dart';
import '../repositories/appointment_repository.dart';

class GetAppointmentsUsecase {
  final AppointmentRepository _repository;
  GetAppointmentsUsecase(this._repository);

  Future<List<Appointment>> execute() => _repository.getAppointments();
}


