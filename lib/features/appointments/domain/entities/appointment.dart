enum AppointmentStatus { scheduled, completed, cancelled }

class Appointment {
  final String id;
  final String doctorId;
  final String patientId;
  final DateTime scheduledAt;
  final AppointmentStatus status;
  final String organizationId;
  final String? notes;

  const Appointment({
    required this.id,
    required this.doctorId,
    required this.patientId,
    required this.scheduledAt,
    required this.status,
    required this.organizationId,
    this.notes,
  });
}


