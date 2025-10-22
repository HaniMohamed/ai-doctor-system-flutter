import '../../domain/entities/booking_message.dart';
import '../../domain/repositories/booking_assistant_repository.dart';
import '../datasources/booking_assistant_remote_datasource.dart';

/// Implementation of the booking assistant repository
class BookingAssistantRepositoryImpl implements BookingAssistantRepository {
  final BookingAssistantRemoteDataSource _remoteDataSource;

  const BookingAssistantRepositoryImpl({
    required BookingAssistantRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<BookingResponse> sendMessage({
    required String message,
    String? sessionId,
    Map<String, dynamic>? context,
  }) async {
    try {
      final response = await _remoteDataSource.sendMessage(
        message: message,
        sessionId: sessionId,
        context: context,
      );
      return response;
    } catch (e) {
      throw Exception('Failed to send booking message: $e');
    }
  }

  @override
  Future<List<dynamic>> getAvailableDoctors({
    String? specialtyId,
    Map<String, dynamic>? preferences,
  }) async {
    try {
      return await _remoteDataSource.getAvailableDoctors(
        specialtyId: specialtyId,
        preferences: preferences,
      );
    } catch (e) {
      throw Exception('Failed to get available doctors: $e');
    }
  }

  @override
  Future<List<TimeSlot>> getAvailableTimeSlots({
    required String doctorId,
    DateTime? date,
  }) async {
    try {
      return await _remoteDataSource.getAvailableTimeSlots(
        doctorId: doctorId,
        date: date,
      );
    } catch (e) {
      throw Exception('Failed to get available time slots: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> bookAppointment({
    required String doctorId,
    required String timeSlotId,
    String? symptoms,
    int? durationMinutes,
  }) async {
    try {
      return await _remoteDataSource.bookAppointment(
        doctorId: doctorId,
        timeSlotId: timeSlotId,
        symptoms: symptoms,
        durationMinutes: durationMinutes,
      );
    } catch (e) {
      throw Exception('Failed to book appointment: $e');
    }
  }

  @override
  Future<bool> cancelAppointment(String appointmentId) async {
    try {
      return await _remoteDataSource.cancelAppointment(appointmentId);
    } catch (e) {
      throw Exception('Failed to cancel appointment: $e');
    }
  }

  @override
  Future<List<dynamic>> getUserAppointments() async {
    try {
      return await _remoteDataSource.getUserAppointments();
    } catch (e) {
      throw Exception('Failed to get user appointments: $e');
    }
  }

  @override
  Future<BookingSession> getBookingSession(String sessionId) async {
    try {
      return await _remoteDataSource.getBookingSession(sessionId);
    } catch (e) {
      throw Exception('Failed to get booking session: $e');
    }
  }

  @override
  Future<List<TimeSlot>> getSuggestedTimeSlots({
    required String doctorId,
    String? symptoms,
    Map<String, dynamic>? preferences,
    String? sessionId,
  }) async {
    try {
      return await _remoteDataSource.getSuggestedTimeSlots(
        doctorId: doctorId,
        symptoms: symptoms,
        preferences: preferences,
        sessionId: sessionId,
      );
    } catch (e) {
      throw Exception('Failed to get suggested time slots: $e');
    }
  }
}
