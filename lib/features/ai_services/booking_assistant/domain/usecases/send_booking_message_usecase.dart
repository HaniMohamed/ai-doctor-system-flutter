import '../entities/booking_message.dart';
import '../repositories/booking_assistant_repository.dart';

/// Use case for sending a message to the AI booking assistant
class SendBookingMessageUseCase {
  final BookingAssistantRepository _repository;

  const SendBookingMessageUseCase(this._repository);

  /// Execute the use case to send a message to the booking assistant
  Future<BookingResponse> call({
    required String message,
    String? sessionId,
    Map<String, dynamic>? context,
  }) async {
    return await _repository.sendMessage(
      message: message,
      sessionId: sessionId,
      context: context,
    );
  }
}
