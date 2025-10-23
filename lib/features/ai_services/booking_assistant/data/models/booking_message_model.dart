import '../../domain/entities/booking_message.dart';

/// Data model for booking messages
class BookingMessageModel extends BookingMessage {
  const BookingMessageModel({
    required super.id,
    required super.content,
    required super.isUser,
    required super.timestamp,
    required super.type,
    super.metadata,
  });

  /// Create a BookingMessageModel from JSON
  factory BookingMessageModel.fromJson(Map<String, dynamic> json) {
    return BookingMessageModel(
      id: json['id'] as String,
      content: json['content'] as String,
      isUser: json['is_user'] as bool,
      timestamp: DateTime.parse(json['timestamp'] as String),
      type: BookingMessageType.values.firstWhere(
        (type) => type.name == json['type'],
        orElse: () => BookingMessageType.text,
      ),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  /// Convert BookingMessageModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'is_user': isUser,
      'timestamp': timestamp.toIso8601String(),
      'type': type.name,
      'metadata': metadata,
    };
  }

  /// Create a BookingMessageModel from a BookingMessage entity
  factory BookingMessageModel.fromEntity(BookingMessage entity) {
    return BookingMessageModel(
      id: entity.id,
      content: entity.content,
      isUser: entity.isUser,
      timestamp: entity.timestamp,
      type: entity.type,
      metadata: entity.metadata,
    );
  }
}

/// Data model for booking sessions
class BookingSessionModel extends BookingSession {
  const BookingSessionModel({
    required super.id,
    required super.userId,
    required super.createdAt,
    super.lastActivityAt,
    required super.messages,
    super.intent,
    required super.context,
  });

  /// Create a BookingSessionModel from JSON
  factory BookingSessionModel.fromJson(Map<String, dynamic> json) {
    return BookingSessionModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      lastActivityAt: json['last_activity_at'] != null
          ? DateTime.parse(json['last_activity_at'] as String)
          : null,
      messages: (json['messages'] as List<dynamic>)
          .map((message) =>
              BookingMessageModel.fromJson(message as Map<String, dynamic>))
          .toList(),
      intent: json['intent'] != null
          ? BookingIntentModel.fromJson(json['intent'] as Map<String, dynamic>)
          : null,
      context: json['context'] as Map<String, dynamic>,
    );
  }

  /// Convert BookingSessionModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'created_at': createdAt.toIso8601String(),
      'last_activity_at': lastActivityAt?.toIso8601String(),
      'messages': messages
          .map((message) => (message as BookingMessageModel).toJson())
          .toList(),
      'intent': intent != null ? (intent as BookingIntentModel).toJson() : null,
      'context': context,
    };
  }
}

/// Data model for booking intents
class BookingIntentModel extends BookingIntent {
  const BookingIntentModel({
    required super.type,
    required super.confidence,
    required super.parameters,
    required super.nextSteps,
  });

  /// Create a BookingIntentModel from JSON
  factory BookingIntentModel.fromJson(Map<String, dynamic> json) {
    return BookingIntentModel(
      type: json['type'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      parameters: json['parameters'] as Map<String, dynamic>,
      nextSteps: (json['next_steps'] as List<dynamic>).cast<String>(),
    );
  }

  /// Convert BookingIntentModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'confidence': confidence,
      'parameters': parameters,
      'next_steps': nextSteps,
    };
  }
}

/// Data model for time slots
class TimeSlotModel extends TimeSlot {
  const TimeSlotModel({
    required super.id,
    required super.startTime,
    required super.endTime,
    required super.durationMinutes,
    required super.isAvailable,
    super.doctorId,
    super.reasoning,
  });

  /// Create a TimeSlotModel from JSON
  factory TimeSlotModel.fromJson(Map<String, dynamic> json) {
    return TimeSlotModel(
      id: json['id'] as String,
      startTime: DateTime.parse(json['start_time'] as String),
      endTime: DateTime.parse(json['end_time'] as String),
      durationMinutes: json['duration_minutes'] as int,
      isAvailable: json['is_available'] as bool,
      doctorId: json['doctor_id'] as String?,
      reasoning: json['reasoning'] as String?,
    );
  }

  /// Convert TimeSlotModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'duration_minutes': durationMinutes,
      'is_available': isAvailable,
      'doctor_id': doctorId,
      'reasoning': reasoning,
    };
  }
}

/// Data model for booking responses
class BookingResponseModel extends BookingResponse {
  const BookingResponseModel({
    required super.sessionId,
    required super.intent,
    required super.confidence,
    required super.nextSteps,
    required super.responseMessage,
    super.suggestedSlots,
    super.suggestedDoctors,
    super.metadata,
  });

  /// Create a BookingResponseModel from JSON
  factory BookingResponseModel.fromJson(Map<String, dynamic> json) {
    return BookingResponseModel(
      sessionId: json['session_id']?.toString() ?? '',
      intent: json['intent']?.toString() ?? '',
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
      nextSteps: (json['next_steps'] as List<dynamic>?)?.cast<String>() ?? [],
      responseMessage: json['response_message']?.toString() ?? '',
      suggestedSlots: json['suggested_slots'] != null
          ? (json['suggested_slots'] as List<dynamic>)
              .map((slot) =>
                  TimeSlotModel.fromJson(slot as Map<String, dynamic>))
              .toList()
          : null,
      suggestedDoctors: json['suggested_doctors'] as List<dynamic>?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  /// Convert BookingResponseModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'session_id': sessionId,
      'intent': intent,
      'confidence': confidence,
      'next_steps': nextSteps,
      'response_message': responseMessage,
      'suggested_slots': suggestedSlots
          ?.map((slot) => (slot as TimeSlotModel).toJson())
          .toList(),
      'suggested_doctors': suggestedDoctors,
      'metadata': metadata,
    };
  }
}
