import '../../domain/entities/appointment.dart';

class AppointmentModel extends Appointment {
  const AppointmentModel({
    required super.id,
    required super.doctorId,
    required super.patientId,
    required super.scheduledAt,
    required super.status,
    required super.organizationId,
    super.notes,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'] as String,
      doctorId: json['doctor_id'] as String,
      patientId: json['patient_id'] as String,
      scheduledAt: DateTime.parse(json['scheduled_at'] as String),
      status: _mapStatus(json['status'] as String),
      organizationId: json['organization_id'] as String,
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctor_id': doctorId,
      'patient_id': patientId,
      'scheduled_at': scheduledAt.toIso8601String(),
      'status': status.name,
      'organization_id': organizationId,
      'notes': notes,
    };
  }

  static AppointmentStatus _mapStatus(String s) {
    switch (s) {
      case 'scheduled':
        return AppointmentStatus.scheduled;
      case 'completed':
        return AppointmentStatus.completed;
      case 'cancelled':
        return AppointmentStatus.cancelled;
      default:
        return AppointmentStatus.scheduled;
    }
  }
}


