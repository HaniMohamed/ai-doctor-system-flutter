import 'dart:async';

import 'package:get/get.dart';

import '../../../../../core/logging/logger.dart';
import '../../../../auth/domain/services/auth_service.dart';
import '../../data/datasources/booking_assistant_remote_datasource.dart';
import '../../data/models/streaming_message_model.dart';
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
  final RxString _chunkBuffer = ''.obs;
  final RxBool _isProcessing = false.obs;
  final RxString _currentIntent = ''.obs;
  final RxDouble _currentConfidence = 0.0.obs;
  final RxList<String> _nextSteps = <String>[].obs;
  final RxString _actionResult = ''.obs;
  final RxBool _actionTaken = false.obs;

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
  bool get isProcessing => _isProcessing.value;
  String get currentIntent => _currentIntent.value;
  double get currentConfidence => _currentConfidence.value;
  List<String> get nextSteps => _nextSteps;
  String get actionResult => _actionResult.value;
  bool get actionTaken => _actionTaken.value;

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
        (streamMessage) {
          Logger.debug(
              'Controller WS ← stream message received: ${streamMessage.type}',
              'BA_WS');
          _handleStreamMessage(streamMessage);
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

  /// Handle streaming message based on type
  void _handleStreamMessage(StreamMessage streamMessage) {
    Logger.debug(
        'Handling stream message type: ${streamMessage.type}', 'BA_WS');

    switch (streamMessage.type) {
      case 'metadata':
        _handleMetadataMessage(streamMessage as MetadataMessage);
        break;
      case 'chunk':
        _handleChunkMessage(streamMessage as ChunkMessage);
        break;
      case 'action':
        _handleActionMessage(streamMessage as ActionMessage);
        break;
      case 'complete':
        _handleCompleteMessage(streamMessage as CompleteMessage);
        break;
      case 'error':
        _handleErrorMessage(streamMessage as ErrorMessage);
        break;
      default:
        Logger.warning(
            'Unknown stream message type: ${streamMessage.type}', 'BA_WS');
    }
  }

  /// Handle metadata message
  void _handleMetadataMessage(MetadataMessage message) {
    Logger.debug('BA: Handling metadata message', 'BA_WS');
    _isProcessing.value = true;
    _currentSessionId.value = message.sessionId ?? _currentSessionId.value;

    // Update session context with processing info
    Logger.info('Processing started: ${message.processingInfo}', 'BA_WS');
  }

  /// Handle chunk message
  void _handleChunkMessage(ChunkMessage message) {
    Logger.debug('BA: Handling chunk message (complete: ${message.isComplete})',
        'BA_WS');

    // Accumulate chunks in buffer
    _chunkBuffer.value += message.chunk;
    _isStreaming.value = true;

    // Don't show internal "thinking" messages to user
    // Only show actual content when streaming
    if (message.chunk.trim().isNotEmpty) {
      _streamingMessage.value = message.chunk;
    }

    if (message.isComplete) {
      // All chunks received, finalize the message
      _finalizeStreamingMessage();
    }
  }

  /// Handle action message
  void _handleActionMessage(ActionMessage message) {
    Logger.debug('BA: Handling action message', 'BA_WS');

    _currentIntent.value = message.intent;
    _currentConfidence.value = message.confidence;
    _actionTaken.value = message.actionTaken;
    _actionResult.value = message.actionResult;

    // Only add system message for action results if they're meaningful to the user
    // Skip internal processing messages
    if (message.actionTaken &&
        message.actionResult.isNotEmpty &&
        !_isInternalProcessingMessage(message.actionResult)) {
      _addSystemMessage(message.actionResult);
    }

    // Update UI based on action metadata
    if (message.metadata != null) {
      _handleActionMetadata(message.metadata!);
    }
  }

  /// Handle complete message
  void _handleCompleteMessage(CompleteMessage message) {
    Logger.debug('BA: Handling complete message', 'BA_WS');

    _isProcessing.value = false;
    _isStreaming.value = false;
    _currentIntent.value = message.intent;
    _currentConfidence.value = message.confidence;
    _nextSteps.value = message.nextSteps;
    _actionTaken.value = message.actionTaken;
    _actionResult.value = message.actionResult;

    // Don't add system messages for next steps - let UI handle this
    // The UI will show next steps in a dedicated section

    // Handle final metadata
    if (message.metadata != null) {
      _handleCompleteMetadata(message.metadata!);
    }
  }

  /// Handle error message
  void _handleErrorMessage(ErrorMessage message) {
    Logger.error(
        'BA: Handling error message: ${message.errorMessage}', 'BA_WS');
    _errorMessage.value = message.errorMessage;
    _isProcessing.value = false;
    _isStreaming.value = false;

    // Don't show technical error details to users
    // Show a user-friendly message instead
    _addSystemMessage(
        'Sorry, I encountered an error while processing your request. Please try again.');
  }

  /// Finalize streaming message and add to conversation
  void _finalizeStreamingMessage() {
    Logger.debug('BA: Finalizing streaming message', 'BA_WS');

    // Only add meaningful content to the conversation
    if (_chunkBuffer.value.isNotEmpty &&
        !_isInternalProcessingMessage(_chunkBuffer.value)) {
      final aiMessage = BookingMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: _chunkBuffer.value.trim(),
        isUser: false,
        timestamp: DateTime.now(),
        type: BookingMessageType.text,
        metadata: {
          'intent': _currentIntent.value,
          'confidence': _currentConfidence.value,
          'next_steps': _nextSteps,
        },
      );
      _messages.add(aiMessage);
    }

    // Reset streaming state
    _chunkBuffer.value = '';
    _isStreaming.value = false;
    _streamingMessage.value = '';
  }

  /// Check if a message is internal processing information that shouldn't be shown to users
  bool _isInternalProcessingMessage(String message) {
    final lowerMessage = message.toLowerCase().trim();

    // Filter out common internal processing messages
    final internalPatterns = [
      'thinking',
      'processing',
      'analyzing',
      'considering',
      'evaluating',
      'ai is',
      'model is',
      'system is',
      'loading',
      'please wait',
      'calculating',
      'determining',
      'generating response',
    ];

    return internalPatterns.any((pattern) => lowerMessage.contains(pattern));
  }

  /// Handle action metadata
  void _handleActionMetadata(Map<String, dynamic> metadata) {
    // Update available doctors if provided
    if (metadata['suggested_doctors'] != null) {
      _availableDoctors.value = metadata['suggested_doctors'] as List<dynamic>;
    }

    // Update suggested time slots if provided
    if (metadata['suggested_slots'] != null) {
      final slots = metadata['suggested_slots'] as List<dynamic>;
      _suggestedTimeSlots.value = slots.map((slot) {
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
  }

  /// Handle complete metadata
  void _handleCompleteMetadata(Map<String, dynamic> metadata) {
    // Handle final response data
    if (metadata['parsed_response'] != null) {
      // Process final response data as needed
      Logger.debug('BA: Received parsed response data', 'BA_WS');
    }

    if (metadata['intent_result'] != null) {
      // Process intent result data as needed
      Logger.debug('BA: Received intent result data', 'BA_WS');
    }
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
    _chunkBuffer.value = '';
    _streamingMessage.value = '';
    _isStreaming.value = false;
    _isProcessing.value = false;
    _currentIntent.value = '';
    _currentConfidence.value = 0.0;
    _nextSteps.clear();
    _actionResult.value = '';
    _actionTaken.value = false;
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
