import '../entities/appointment.dart';

abstract class AppointmentRepository {
  Future<List<Appointment>> getAppointments();
  Future<Appointment> createAppointment(Map<String, dynamic> request);
  Future<Appointment> updateAppointment(String id, Map<String, dynamic> request);
  Future<void> cancelAppointment(String id);
}


