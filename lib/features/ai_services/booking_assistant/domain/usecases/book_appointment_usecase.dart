import '../repositories/booking_assistant_repository.dart';

/// Use case for booking an appointment
class BookAppointmentUseCase {
  final BookingAssistantRepository _repository;

  const BookAppointmentUseCase(this._repository);

  /// Execute the use case to book an appointment
  Future<Map<String, dynamic>> call({
    required String doctorId,
    required String timeSlotId,
    String? symptoms,
    int? durationMinutes,
  }) async {
    return await _repository.bookAppointment(
      doctorId: doctorId,
      timeSlotId: timeSlotId,
      symptoms: symptoms,
      durationMinutes: durationMinutes,
    );
  }
}
