import '../entities/booking_message.dart';
import '../repositories/booking_assistant_repository.dart';

/// Use case for getting suggested time slots
class GetSuggestedTimeSlotsUseCase {
  final BookingAssistantRepository _repository;

  const GetSuggestedTimeSlotsUseCase(this._repository);

  /// Execute the use case to get AI-suggested time slots
  Future<List<TimeSlot>> call({
    required String doctorId,
    String? symptoms,
    Map<String, dynamic>? preferences,
    String? sessionId,
  }) async {
    return await _repository.getSuggestedTimeSlots(
      doctorId: doctorId,
      symptoms: symptoms,
      preferences: preferences,
      sessionId: sessionId,
    );
  }
}
