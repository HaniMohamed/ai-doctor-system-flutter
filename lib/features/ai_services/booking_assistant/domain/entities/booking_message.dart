/// Represents a message in the AI booking assistant conversation
class BookingMessage {
  final String id;
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final BookingMessageType type;
  final Map<String, dynamic>? metadata;

  const BookingMessage({
    required this.id,
    required this.content,
    required this.isUser,
    required this.timestamp,
    required this.type,
    this.metadata,
  });

  BookingMessage copyWith({
    String? id,
    String? content,
    bool? isUser,
    DateTime? timestamp,
    BookingMessageType? type,
    Map<String, dynamic>? metadata,
  }) {
    return BookingMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      metadata: metadata ?? this.metadata,
    );
  }
}

/// Types of booking messages
enum BookingMessageType {
  text,
  suggestion,
  appointment,
  doctor,
  timeSlot,
  confirmation,
  error,
}

/// Represents a booking session with the AI assistant
class BookingSession {
  final String id;
  final String userId;
  final DateTime createdAt;
  final DateTime? lastActivityAt;
  final List<BookingMessage> messages;
  final BookingIntent? intent;
  final Map<String, dynamic> context;

  const BookingSession({
    required this.id,
    required this.userId,
    required this.createdAt,
    this.lastActivityAt,
    required this.messages,
    this.intent,
    required this.context,
  });

  BookingSession copyWith({
    String? id,
    String? userId,
    DateTime? createdAt,
    DateTime? lastActivityAt,
    List<BookingMessage>? messages,
    BookingIntent? intent,
    Map<String, dynamic>? context,
  }) {
    return BookingSession(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      lastActivityAt: lastActivityAt ?? this.lastActivityAt,
      messages: messages ?? this.messages,
      intent: intent ?? this.intent,
      context: context ?? this.context,
    );
  }
}

/// Represents the intent of the user's booking request
class BookingIntent {
  final String type;
  final double confidence;
  final Map<String, dynamic> parameters;
  final List<String> nextSteps;

  const BookingIntent({
    required this.type,
    required this.confidence,
    required this.parameters,
    required this.nextSteps,
  });

  BookingIntent copyWith({
    String? type,
    double? confidence,
    Map<String, dynamic>? parameters,
    List<String>? nextSteps,
  }) {
    return BookingIntent(
      type: type ?? this.type,
      confidence: confidence ?? this.confidence,
      parameters: parameters ?? this.parameters,
      nextSteps: nextSteps ?? this.nextSteps,
    );
  }
}

/// Represents an available time slot for booking
class TimeSlot {
  final String id;
  final DateTime startTime;
  final DateTime endTime;
  final int durationMinutes;
  final bool isAvailable;
  final String? doctorId;
  final String? reasoning;

  const TimeSlot({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.durationMinutes,
    required this.isAvailable,
    this.doctorId,
    this.reasoning,
  });

  TimeSlot copyWith({
    String? id,
    DateTime? startTime,
    DateTime? endTime,
    int? durationMinutes,
    bool? isAvailable,
    String? doctorId,
    String? reasoning,
  }) {
    return TimeSlot(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      isAvailable: isAvailable ?? this.isAvailable,
      doctorId: doctorId ?? this.doctorId,
      reasoning: reasoning ?? this.reasoning,
    );
  }
}

/// Represents a booking response from the AI assistant
class BookingResponse {
  final String sessionId;
  final String intent;
  final double confidence;
  final List<String> nextSteps;
  final String responseMessage;
  final List<TimeSlot>? suggestedSlots;
  final List<dynamic>? suggestedDoctors;
  final Map<String, dynamic>? metadata;

  const BookingResponse({
    required this.sessionId,
    required this.intent,
    required this.confidence,
    required this.nextSteps,
    required this.responseMessage,
    this.suggestedSlots,
    this.suggestedDoctors,
    this.metadata,
  });

  BookingResponse copyWith({
    String? sessionId,
    String? intent,
    double? confidence,
    List<String>? nextSteps,
    String? responseMessage,
    List<TimeSlot>? suggestedSlots,
    List<dynamic>? suggestedDoctors,
    Map<String, dynamic>? metadata,
  }) {
    return BookingResponse(
      sessionId: sessionId ?? this.sessionId,
      intent: intent ?? this.intent,
      confidence: confidence ?? this.confidence,
      nextSteps: nextSteps ?? this.nextSteps,
      responseMessage: responseMessage ?? this.responseMessage,
      suggestedSlots: suggestedSlots ?? this.suggestedSlots,
      suggestedDoctors: suggestedDoctors ?? this.suggestedDoctors,
      metadata: metadata ?? this.metadata,
    );
  }
}
