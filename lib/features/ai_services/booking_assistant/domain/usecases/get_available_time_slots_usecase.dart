import '../entities/booking_message.dart';
import '../repositories/booking_assistant_repository.dart';

/// Use case for getting available time slots
class GetAvailableTimeSlotsUseCase {
  final BookingAssistantRepository _repository;

  const GetAvailableTimeSlotsUseCase(this._repository);

  /// Execute the use case to get available time slots
  Future<List<TimeSlot>> call({
    required String doctorId,
    DateTime? date,
  }) async {
    return await _repository.getAvailableTimeSlots(
      doctorId: doctorId,
      date: date,
    );
  }
}
