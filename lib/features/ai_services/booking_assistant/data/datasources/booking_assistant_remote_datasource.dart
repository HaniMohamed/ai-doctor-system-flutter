import '../../../../../core/logging/logger.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/websocket/websocket_client.dart';
import '../models/booking_message_model.dart';
import '../models/streaming_message_model.dart';

/// Remote data source for AI booking assistant operations
abstract class BookingAssistantRemoteDataSource {
  /// Send a message to the AI booking assistant via REST API
  Future<BookingResponseModel> sendMessage({
    required String message,
    String? sessionId,
    Map<String, dynamic>? context,
  });

  /// Get available doctors for booking
  Future<List<Map<String, dynamic>>> getAvailableDoctors({
    String? specialtyId,
    Map<String, dynamic>? preferences,
  });

  /// Get available time slots for a specific doctor
  Future<List<TimeSlotModel>> getAvailableTimeSlots({
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
  Future<List<Map<String, dynamic>>> getUserAppointments();

  /// Get booking session history
  Future<BookingSessionModel> getBookingSession(String sessionId);

  /// Get suggested time slots based on AI analysis
  Future<List<TimeSlotModel>> getSuggestedTimeSlots({
    required String doctorId,
    String? symptoms,
    Map<String, dynamic>? preferences,
    String? sessionId,
  });

  /// Connect to WebSocket for real-time booking assistance
  Stream<StreamMessage> connectWebSocket({
    required String token,
    String? sessionId,
  });

  /// Send message via WebSocket
  Future<void> sendWebSocketMessage({
    required String message,
    String? sessionId,
    Map<String, dynamic>? context,
  });

  /// Disconnect WebSocket
  Future<void> disconnectWebSocket();
}

/// Implementation of the remote data source
class BookingAssistantRemoteDataSourceImpl
    implements BookingAssistantRemoteDataSource {
  final ApiClient _apiClient;
  final WebSocketClient _webSocketClient;

  BookingAssistantRemoteDataSourceImpl({
    required ApiClient apiClient,
    required WebSocketClient webSocketClient,
  })  : _apiClient = apiClient,
        _webSocketClient = webSocketClient;

  @override
  Future<BookingResponseModel> sendMessage({
    required String message,
    String? sessionId,
    Map<String, dynamic>? context,
  }) async {
    try {
      final response = await _apiClient.post(
        '/ai/booking-assistant',
        data: {
          'message': message,
          'session_id': sessionId,
          'context': context ?? {},
        },
      );

      return BookingResponseModel.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('Failed to send booking message: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getAvailableDoctors({
    String? specialtyId,
    Map<String, dynamic>? preferences,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (specialtyId != null) queryParams['specialty_id'] = specialtyId;

      final response = await _apiClient.get(
        '/ai/booking-assistant/available-doctors',
        queryParameters: queryParams,
      );

      return List<Map<String, dynamic>>.from(response.data['data']);
    } catch (e) {
      throw Exception('Failed to get available doctors: $e');
    }
  }

  @override
  Future<List<TimeSlotModel>> getAvailableTimeSlots({
    required String doctorId,
    DateTime? date,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'doctor_id': doctorId,
      };
      if (date != null) {
        queryParams['date'] = date.toIso8601String();
      }

      final response = await _apiClient.get(
        '/ai/booking-assistant/available-slots',
        queryParameters: queryParams,
      );

      return (response.data['data'] as List<dynamic>)
          .map((slot) => TimeSlotModel.fromJson(slot as Map<String, dynamic>))
          .toList();
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
      final response = await _apiClient.post(
        '/ai/booking-assistant/book',
        data: {
          'doctor_id': doctorId,
          'time_slot_id': timeSlotId,
          'symptoms': symptoms,
          'duration_minutes': durationMinutes,
        },
      );

      return response.data['data'] as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to book appointment: $e');
    }
  }

  @override
  Future<bool> cancelAppointment(String appointmentId) async {
    try {
      await _apiClient.post('/ai/booking-assistant/cancel/$appointmentId');
      return true;
    } catch (e) {
      throw Exception('Failed to cancel appointment: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getUserAppointments() async {
    try {
      final response =
          await _apiClient.get('/ai/booking-assistant/appointments');
      return List<Map<String, dynamic>>.from(response.data['data']);
    } catch (e) {
      throw Exception('Failed to get user appointments: $e');
    }
  }

  @override
  Future<BookingSessionModel> getBookingSession(String sessionId) async {
    try {
      final response =
          await _apiClient.get('/ai/booking-assistant/sessions/$sessionId');
      return BookingSessionModel.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('Failed to get booking session: $e');
    }
  }

  @override
  Future<List<TimeSlotModel>> getSuggestedTimeSlots({
    required String doctorId,
    String? symptoms,
    Map<String, dynamic>? preferences,
    String? sessionId,
  }) async {
    try {
      final response = await _apiClient.post(
        '/ai/time-slots',
        data: {
          'doctor_id': doctorId,
          'symptoms': symptoms,
          'preferences': preferences ?? {},
          'session_id': sessionId,
        },
      );

      return (response.data['data']['suggested_slots'] as List<dynamic>)
          .map((slot) => TimeSlotModel.fromJson(slot as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get suggested time slots: $e');
    }
  }

  @override
  Stream<StreamMessage> connectWebSocket({
    required String token,
    String? sessionId,
  }) async* {
    Logger.info('BA: Connecting WS (sessionId: ${sessionId ?? '-'} )', 'BA_WS');
    await _webSocketClient.connect('/ai/booking-assistant/ws');
    Logger.info('BA: WS connected, subscribing to stream', 'BA_WS');

    yield* _webSocketClient.messages.map((data) {
      Logger.debug('BA WS ← message: ${Logger.preview(data)}', 'BA_WS');

      try {
        // Parse the streaming message using the factory
        final streamMessage = StreamMessageFactory.fromJson(data);

        if (streamMessage == null) {
          Logger.warning(
              'Unknown message type received: ${data['type']}', 'BA_WS');
          // Create a generic error message for unknown types
          return ErrorMessage(
            sessionId: data['session_id']?.toString(),
            timestamp: DateTime.now(),
            errorMessage: 'Unknown message type: ${data['type']}',
          );
        }

        return streamMessage;
      } catch (e, stackTrace) {
        Logger.error(
            'Error parsing WebSocket message: $e', 'BA_WS', e, stackTrace);
        // Return an error message for parsing failures
        return ErrorMessage(
          sessionId: data['session_id']?.toString(),
          timestamp: DateTime.now(),
          errorMessage: 'Failed to parse message: ${e.toString()}',
        );
      }
    });
  }

  @override
  Future<void> sendWebSocketMessage({
    required String message,
    String? sessionId,
    Map<String, dynamic>? context,
  }) async {
    final payload = {
      'type': 'message',
      'message': message,
      'session_id': sessionId,
      'context': context ?? {},
    };
    Logger.debug('BA WS → send: ${Logger.preview(payload)}', 'BA_WS');
    _webSocketClient.send(payload);
  }

  @override
  Future<void> disconnectWebSocket() async {
    Logger.info('BA: Disconnecting WS', 'BA_WS');
    await _webSocketClient.disconnect();
  }
}
