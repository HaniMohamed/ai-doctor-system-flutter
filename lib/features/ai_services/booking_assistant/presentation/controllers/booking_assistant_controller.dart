import 'dart:async';

import 'package:get/get.dart';

import '../../../../../core/logging/logger.dart';
import '../../../../auth/domain/services/auth_service.dart';
import '../../data/datasources/booking_assistant_remote_datasource.dart';
import '../../domain/entities/booking_message.dart';
import '../../domain/usecases/book_appointment_usecase.dart';
import '../../domain/usecases/get_available_doctors_usecase.dart';
import '../../domain/usecases/get_available_time_slots_usecase.dart';
import '../../domain/usecases/get_suggested_time_slots_usecase.dart';
import '../../domain/usecases/send_booking_message_usecase.dart';

/// Controller for AI booking assistant functionality
class BookingAssistantController extends GetxController {
  final SendBookingMessageUseCase _sendMessageUseCase;
  final GetAvailableDoctorsUseCase _getAvailableDoctorsUseCase;
  final GetAvailableTimeSlotsUseCase _getAvailableTimeSlotsUseCase;
  final BookAppointmentUseCase _bookAppointmentUseCase;
  final GetSuggestedTimeSlotsUseCase _getSuggestedTimeSlotsUseCase;
  final BookingAssistantRemoteDataSource _remoteDataSource;
  final AuthService _authService;

  BookingAssistantController({
    required SendBookingMessageUseCase sendMessageUseCase,
    required GetAvailableDoctorsUseCase getAvailableDoctorsUseCase,
    required GetAvailableTimeSlotsUseCase getAvailableTimeSlotsUseCase,
    required BookAppointmentUseCase bookAppointmentUseCase,
    required GetSuggestedTimeSlotsUseCase getSuggestedTimeSlotsUseCase,
    required BookingAssistantRemoteDataSource remoteDataSource,
    required AuthService authService,
  })  : _sendMessageUseCase = sendMessageUseCase,
        _getAvailableDoctorsUseCase = getAvailableDoctorsUseCase,
        _getAvailableTimeSlotsUseCase = getAvailableTimeSlotsUseCase,
        _bookAppointmentUseCase = bookAppointmentUseCase,
        _getSuggestedTimeSlotsUseCase = getSuggestedTimeSlotsUseCase,
        _remoteDataSource = remoteDataSource,
        _authService = authService;

  // WebSocket stream subscription
  StreamSubscription? _webSocketSubscription;

  // Observable state
  final RxList<BookingMessage> _messages = <BookingMessage>[].obs;
  final RxBool _isLoading = false.obs;
  final RxBool _isConnected = false.obs;
  final RxString _currentSessionId = ''.obs;
  final RxList<dynamic> _availableDoctors = <dynamic>[].obs;
  final RxList<TimeSlot> _availableTimeSlots = <TimeSlot>[].obs;
  final RxList<TimeSlot> _suggestedTimeSlots = <TimeSlot>[].obs;
  final RxString _errorMessage = ''.obs;
  final RxBool _isStreaming = false.obs;
  final RxString _streamingMessage = ''.obs;

  // Getters
  List<BookingMessage> get messages => _messages;
  bool get isLoading => _isLoading.value;
  bool get isConnected => _isConnected.value;
  String get currentSessionId => _currentSessionId.value;
  List<dynamic> get availableDoctors => _availableDoctors;
  List<TimeSlot> get availableTimeSlots => _availableTimeSlots;
  List<TimeSlot> get suggestedTimeSlots => _suggestedTimeSlots;
  String get errorMessage => _errorMessage.value;
  bool get isStreaming => _isStreaming.value;
  String get streamingMessage => _streamingMessage.value;

  @override
  void onInit() {
    super.onInit();
    Logger.info('BookingAssistantController initializing', 'BA');
    _initializeSession();
    _connectWebSocket();
  }

  @override
  void onClose() {
    Logger.info('BookingAssistantController closing', 'BA');
    _disconnectWebSocket();
    super.onClose();
  }

  /// Initialize a new booking session
  void _initializeSession() {
    _currentSessionId.value = DateTime.now().millisecondsSinceEpoch.toString();
    _addSystemMessage(
        'Hello! I\'m your AI booking assistant. How can I help you today?');
  }

  /// Add a system message to the conversation
  void _addSystemMessage(String content) {
    final message = BookingMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      isUser: false,
      timestamp: DateTime.now(),
      type: BookingMessageType.text,
    );
    _messages.add(message);
  }

  /// Connect to WebSocket for real-time communication
  Future<void> _connectWebSocket() async {
    try {
      // Get the actual user token from the auth service
      final token = await _authService.getAccessToken();
      if (token == null) {
        Logger.warning('No auth token available for WS connection', 'BA_WS');
        _errorMessage.value =
            'No authentication token available. Please log in.';
        _isConnected.value = false;
        return;
      }

      Logger.info(
          'Connecting WS from controller (sessionId: ${_currentSessionId.value})',
          'BA_WS');
      _webSocketSubscription = _remoteDataSource
          .connectWebSocket(
        token: token,
        sessionId: _currentSessionId.value,
      )
          .listen(
        (response) {
          Logger.debug('Controller WS ← response received', 'BA_WS');
          _handleWebSocketResponse(response);
        },
        onError: (error, st) {
          Logger.error(
              'Controller WS stream error: $error', 'BA_WS', error, st);
          _errorMessage.value = 'WebSocket error: $error';
          _isConnected.value = false;
        },
        onDone: () {
          Logger.info('Controller WS stream done', 'BA_WS');
          _isConnected.value = false;
        },
      );
      _isConnected.value = true;
      Logger.info('Controller WS connected', 'BA_WS');
    } catch (e, st) {
      Logger.error('Failed to connect to WS: $e', 'BA_WS', e, st);
      _errorMessage.value = 'Failed to connect to WebSocket: $e';
      _isConnected.value = false;
    }
  }

  /// Disconnect from WebSocket
  Future<void> _disconnectWebSocket() async {
    try {
      Logger.info('Controller disconnecting WS', 'BA_WS');
      await _webSocketSubscription?.cancel();
      await _remoteDataSource.disconnectWebSocket();
      _isConnected.value = false;
    } catch (e, st) {
      Logger.error('Failed to disconnect WS: $e', 'BA_WS', e, st);
      _errorMessage.value = 'Failed to disconnect from WebSocket: $e';
    }
  }

  /// Handle WebSocket response
  void _handleWebSocketResponse(dynamic response) {
    Logger.debug('Handling WS response', 'BA_WS');
    if (response is Map<String, dynamic>) {
      // Handle different types of WebSocket messages
      final type = response['type'] as String?;

      switch (type) {
        case 'message':
          _handleStreamingMessage(response);
          break;
        case 'doctors':
          _handleDoctorsUpdate(response);
          break;
        case 'time_slots':
          _handleTimeSlotsUpdate(response);
          break;
        case 'booking_confirmation':
          _handleBookingConfirmation(response);
          break;
        case 'error':
          _handleWebSocketError(response);
          break;
        default:
          _handleGenericResponse(response);
      }
    }
  }

  /// Handle streaming message response
  void _handleStreamingMessage(Map<String, dynamic> response) {
    final content = response['content'] as String? ?? '';
    final isComplete = response['is_complete'] as bool? ?? false;

    if (isComplete) {
      // Final message received
      final aiMessage = BookingMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: _streamingMessage.value + content,
        isUser: false,
        timestamp: DateTime.now(),
        type: BookingMessageType.text,
        metadata: response['metadata'],
      );
      _messages.add(aiMessage);
      _isStreaming.value = false;
      _streamingMessage.value = '';
    } else {
      // Streaming message - update current streaming message
      _streamingMessage.value += content;
      _isStreaming.value = true;
    }
  }

  /// Handle doctors update
  void _handleDoctorsUpdate(Map<String, dynamic> response) {
    final doctors = response['doctors'] as List<dynamic>? ?? [];
    _availableDoctors.value = doctors;
  }

  /// Handle time slots update
  void _handleTimeSlotsUpdate(Map<String, dynamic> response) {
    final slots = response['time_slots'] as List<dynamic>? ?? [];
    _availableTimeSlots.value = slots.map((slot) {
      final slotData = slot as Map<String, dynamic>;
      return TimeSlot(
        id: slotData['id'] as String,
        startTime: DateTime.parse(slotData['start_time'] as String),
        endTime: DateTime.parse(slotData['end_time'] as String),
        durationMinutes: slotData['duration_minutes'] as int,
        isAvailable: slotData['is_available'] as bool,
        doctorId: slotData['doctor_id'] as String?,
        reasoning: slotData['reasoning'] as String?,
      );
    }).toList();
  }

  /// Handle booking confirmation
  void _handleBookingConfirmation(Map<String, dynamic> response) {
    final confirmation =
        response['confirmation'] as Map<String, dynamic>? ?? {};
    _addSystemMessage(
        'Appointment confirmed! ${confirmation['appointment_id']}');
  }

  /// Handle WebSocket error
  void _handleWebSocketError(Map<String, dynamic> response) {
    final error = response['error'] as String? ?? 'Unknown error';
    _errorMessage.value = 'WebSocket error: $error';
  }

  /// Handle generic response
  void _handleGenericResponse(Map<String, dynamic> response) {
    // Handle any other response types
    Logger.debug(
        'Received generic WebSocket response: ${Logger.preview(response)}',
        'BA_WS');
  }

  /// Send a message to the AI booking assistant via WebSocket
  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    // Add user message
    final userMessage = BookingMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: message,
      isUser: true,
      timestamp: DateTime.now(),
      type: BookingMessageType.text,
    );
    _messages.add(userMessage);

    _isLoading.value = true;
    _errorMessage.value = '';

    try {
      if (_isConnected.value) {
        // Send via WebSocket for real-time streaming
        Logger.debug('Controller WS → send message', 'BA_WS');
        await _remoteDataSource.sendWebSocketMessage(
          message: message,
          sessionId: _currentSessionId.value,
          context: _getCurrentContext(),
        );
      } else {
        Logger.info('WS not connected, falling back to REST', 'BA');
        // Fallback to REST API if WebSocket is not connected
        final response = await _sendMessageUseCase(
          message: message,
          sessionId: _currentSessionId.value,
          context: _getCurrentContext(),
        );

        // Add AI response message
        final aiMessage = BookingMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content: response.responseMessage,
          isUser: false,
          timestamp: DateTime.now(),
          type: BookingMessageType.text,
          metadata: {
            'intent': response.intent,
            'confidence': response.confidence,
            'next_steps': response.nextSteps,
          },
        );
        _messages.add(aiMessage);

        // Update available doctors if provided
        if (response.suggestedDoctors != null) {
          _availableDoctors.value = response.suggestedDoctors!;
        }

        // Update suggested time slots if provided
        if (response.suggestedSlots != null) {
          _suggestedTimeSlots.value = response.suggestedSlots!;
        }
      }
    } catch (e, st) {
      Logger.error('Failed to send message: $e', 'BA', e, st);
      _errorMessage.value = 'Failed to send message: $e';
      _addSystemMessage('Sorry, I encountered an error. Please try again.');
    } finally {
      _isLoading.value = false;
    }
  }

  /// Get available doctors
  Future<void> getAvailableDoctors({
    String? specialtyId,
    Map<String, dynamic>? preferences,
  }) async {
    _isLoading.value = true;
    _errorMessage.value = '';

    try {
      final doctors = await _getAvailableDoctorsUseCase(
        specialtyId: specialtyId,
        preferences: preferences,
      );
      _availableDoctors.value = doctors;
    } catch (e) {
      _errorMessage.value = 'Failed to get available doctors: $e';
    } finally {
      _isLoading.value = false;
    }
  }

  /// Get available time slots for a doctor
  Future<void> getAvailableTimeSlots({
    required String doctorId,
    DateTime? date,
  }) async {
    _isLoading.value = true;
    _errorMessage.value = '';

    try {
      final slots = await _getAvailableTimeSlotsUseCase(
        doctorId: doctorId,
        date: date,
      );
      _availableTimeSlots.value = slots;
    } catch (e) {
      _errorMessage.value = 'Failed to get available time slots: $e';
    } finally {
      _isLoading.value = false;
    }
  }

  /// Get AI-suggested time slots
  Future<void> getSuggestedTimeSlots({
    required String doctorId,
    String? symptoms,
    Map<String, dynamic>? preferences,
  }) async {
    _isLoading.value = true;
    _errorMessage.value = '';

    try {
      final slots = await _getSuggestedTimeSlotsUseCase(
        doctorId: doctorId,
        symptoms: symptoms,
        preferences: preferences,
        sessionId: _currentSessionId.value,
      );
      _suggestedTimeSlots.value = slots;
    } catch (e) {
      _errorMessage.value = 'Failed to get suggested time slots: $e';
    } finally {
      _isLoading.value = false;
    }
  }

  /// Book an appointment
  Future<bool> bookAppointment({
    required String doctorId,
    required String timeSlotId,
    String? symptoms,
    int? durationMinutes,
  }) async {
    _isLoading.value = true;
    _errorMessage.value = '';

    try {
      await _bookAppointmentUseCase(
        doctorId: doctorId,
        timeSlotId: timeSlotId,
        symptoms: symptoms,
        durationMinutes: durationMinutes,
      );

      _addSystemMessage('Appointment booked successfully!');
      return true;
    } catch (e) {
      _errorMessage.value = 'Failed to book appointment: $e';
      _addSystemMessage(
          'Sorry, I couldn\'t book the appointment. Please try again.');
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  /// Get current conversation context
  Map<String, dynamic> _getCurrentContext() {
    return {
      'session_id': _currentSessionId.value,
      'message_count': _messages.length,
      'available_doctors': _availableDoctors.length,
      'available_slots': _availableTimeSlots.length,
      'suggested_slots': _suggestedTimeSlots.length,
    };
  }

  /// Clear error message
  void clearError() {
    _errorMessage.value = '';
  }

  /// Clear conversation
  void clearConversation() {
    _messages.clear();
    _availableDoctors.clear();
    _availableTimeSlots.clear();
    _suggestedTimeSlots.clear();
    _errorMessage.value = '';
    _initializeSession();
  }

  /// Select a time slot
  void selectTimeSlot(TimeSlot slot) {
    _addSystemMessage('Selected time slot: ${slot.startTime.toString()}');
  }

  /// Select a doctor
  void selectDoctor(dynamic doctor) {
    _addSystemMessage('Selected doctor: ${doctor['name'] ?? 'Unknown'}');
  }
}
