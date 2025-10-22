import '../entities/booking_message.dart';

/// Repository interface for AI booking assistant operations
abstract class BookingAssistantRepository {
  /// Send a message to the AI booking assistant
  Future<BookingResponse> sendMessage({
    required String message,
    String? sessionId,
    Map<String, dynamic>? context,
  });

  /// Get available doctors for booking
  Future<List<dynamic>> getAvailableDoctors({
    String? specialtyId,
    Map<String, dynamic>? preferences,
  });

  /// Get available time slots for a specific doctor
  Future<List<TimeSlot>> getAvailableTimeSlots({
    required String doctorId,
    DateTime? date,
  });

  /// Book an appointment directly
  Future<Map<String, dynamic>> bookAppointment({
    required String doctorId,
    required String timeSlotId,
    String? symptoms,
    int? durationMinutes,
  });

  /// Cancel an appointment
  Future<bool> cancelAppointment(String appointmentId);

  /// Get user's appointments
  Future<List<dynamic>> getUserAppointments();

  /// Get booking session history
  Future<BookingSession> getBookingSession(String sessionId);

  /// Get suggested time slots based on AI analysis
  Future<List<TimeSlot>> getSuggestedTimeSlots({
    required String doctorId,
    String? symptoms,
    Map<String, dynamic>? preferences,
    String? sessionId,
  });
}
