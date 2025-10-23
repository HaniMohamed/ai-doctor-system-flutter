/// Data models for streaming WebSocket messages following the standardized format
/// Based on the streaming format documentation

import 'dart:convert';

/// Base interface for all streaming messages
abstract class StreamMessage {
  final String type;
  final String? sessionId;
  final DateTime timestamp;
  final bool isComplete;

  const StreamMessage({
    required this.type,
    this.sessionId,
    required this.timestamp,
    required this.isComplete,
  });

  Map<String, dynamic> toJson();
}

/// Metadata message sent at the beginning of processing
class MetadataMessage extends StreamMessage {
  final Map<String, dynamic> processingInfo;

  const MetadataMessage({
    required super.sessionId,
    required super.timestamp,
    required this.processingInfo,
  }) : super(type: 'metadata', isComplete: false);

  factory MetadataMessage.fromJson(Map<String, dynamic> json) {
    DateTime timestamp;
    try {
      if (json['timestamp'] != null && json['timestamp'] is String) {
        timestamp = DateTime.parse(json['timestamp'] as String);
      } else {
        timestamp = DateTime.now();
      }
    } catch (e) {
      timestamp = DateTime.now();
    }

    return MetadataMessage(
      sessionId: json['session_id']?.toString(),
      timestamp: timestamp,
      processingInfo: json['processing_info'] as Map<String, dynamic>? ?? {},
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'session_id': sessionId,
      'timestamp': timestamp.toIso8601String(),
      'is_complete': isComplete,
      'processing_info': processingInfo,
    };
  }
}

/// Chunk message for streaming text from AI model
class ChunkMessage extends StreamMessage {
  final String chunk;
  final String? responseMessage;
  final String? intent;
  final double? confidence;
  final List<String>? nextSteps;
  final bool? actionTaken;
  final String? actionResult;

  const ChunkMessage({
    required super.sessionId,
    required super.timestamp,
    required super.isComplete,
    required this.chunk,
    this.responseMessage,
    this.intent,
    this.confidence,
    this.nextSteps,
    this.actionTaken,
    this.actionResult,
  }) : super(type: 'chunk');

  factory ChunkMessage.fromJson(Map<String, dynamic> json) {
    DateTime timestamp;
    try {
      if (json['timestamp'] != null && json['timestamp'] is String) {
        timestamp = DateTime.parse(json['timestamp'] as String);
      } else {
        timestamp = DateTime.now();
      }
    } catch (e) {
      timestamp = DateTime.now();
    }

    return ChunkMessage(
      sessionId: json['session_id']?.toString(),
      timestamp: timestamp,
      isComplete: json['is_complete'] as bool? ?? false,
      chunk: json['chunk'] as String? ?? '',
      responseMessage: json['response_message'] as String?,
      intent: json['intent'] as String?,
      confidence: (json['confidence'] as num?)?.toDouble(),
      nextSteps: (json['next_steps'] as List<dynamic>?)?.cast<String>(),
      actionTaken: json['action_taken'] as bool?,
      actionResult: json['action_result'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'session_id': sessionId,
      'timestamp': timestamp.toIso8601String(),
      'is_complete': isComplete,
      'chunk': chunk,
      if (responseMessage != null) 'response_message': responseMessage,
      if (intent != null) 'intent': intent,
      if (confidence != null) 'confidence': confidence,
      if (nextSteps != null) 'next_steps': nextSteps,
      if (actionTaken != null) 'action_taken': actionTaken,
      if (actionResult != null) 'action_result': actionResult,
    };
  }
}

/// Action message when AI executes a specific action
class ActionMessage extends StreamMessage {
  final String intent;
  final double confidence;
  final bool actionTaken;
  final String actionResult;
  final Map<String, dynamic>? metadata;

  const ActionMessage({
    required super.sessionId,
    required super.timestamp,
    required super.isComplete,
    required this.intent,
    required this.confidence,
    required this.actionTaken,
    required this.actionResult,
    this.metadata,
  }) : super(type: 'action');

  factory ActionMessage.fromJson(Map<String, dynamic> json) {
    DateTime timestamp;
    try {
      if (json['timestamp'] != null && json['timestamp'] is String) {
        timestamp = DateTime.parse(json['timestamp'] as String);
      } else {
        timestamp = DateTime.now();
      }
    } catch (e) {
      timestamp = DateTime.now();
    }

    return ActionMessage(
      sessionId: json['session_id']?.toString(),
      timestamp: timestamp,
      isComplete: json['is_complete'] as bool? ?? false,
      intent: json['intent'] as String? ?? '',
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
      actionTaken: json['action_taken'] as bool? ?? false,
      actionResult: json['action_result'] as String? ?? '',
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'session_id': sessionId,
      'timestamp': timestamp.toIso8601String(),
      'is_complete': isComplete,
      'intent': intent,
      'confidence': confidence,
      'action_taken': actionTaken,
      'action_result': actionResult,
      'metadata': metadata,
    };
  }
}

/// Complete message with final processing results
class CompleteMessage extends StreamMessage {
  final String intent;
  final double confidence;
  final List<String> nextSteps;
  final bool actionTaken;
  final String actionResult;
  final Map<String, dynamic>? metadata;

  const CompleteMessage({
    required super.sessionId,
    required super.timestamp,
    required this.intent,
    required this.confidence,
    required this.nextSteps,
    required this.actionTaken,
    required this.actionResult,
    this.metadata,
  }) : super(isComplete: true, type: 'complete');

  factory CompleteMessage.fromJson(Map<String, dynamic> json) {
    DateTime timestamp;
    try {
      if (json['timestamp'] != null && json['timestamp'] is String) {
        timestamp = DateTime.parse(json['timestamp'] as String);
      } else {
        timestamp = DateTime.now();
      }
    } catch (e) {
      timestamp = DateTime.now();
    }

    return CompleteMessage(
      sessionId: json['session_id']?.toString(),
      timestamp: timestamp,
      intent: json['intent'] as String? ?? '',
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
      nextSteps: (json['next_steps'] as List<dynamic>?)?.cast<String>() ?? [],
      actionTaken: json['action_taken'] as bool? ?? false,
      actionResult: json['action_result'] as String? ?? '',
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'session_id': sessionId,
      'timestamp': timestamp.toIso8601String(),
      'is_complete': isComplete,
      'intent': intent,
      'confidence': confidence,
      'next_steps': nextSteps,
      'action_taken': actionTaken,
      'action_result': actionResult,
      'metadata': metadata,
    };
  }
}

/// Error message for error handling
class ErrorMessage extends StreamMessage {
  final bool isError;
  final String errorMessage;

  const ErrorMessage({
    required super.sessionId,
    required super.timestamp,
    required this.errorMessage,
  })  : isError = true,
        super(type: 'error', isComplete: true);

  factory ErrorMessage.fromJson(Map<String, dynamic> json) {
    DateTime timestamp;
    try {
      if (json['timestamp'] != null && json['timestamp'] is String) {
        timestamp = DateTime.parse(json['timestamp'] as String);
      } else {
        timestamp = DateTime.now();
      }
    } catch (e) {
      timestamp = DateTime.now();
    }

    // Get error message from either 'error_message' or 'message' field
    String errorMessage = 'Unknown error';
    if (json['error_message'] != null && json['error_message'] is String) {
      errorMessage = json['error_message'] as String;
    } else if (json['message'] != null && json['message'] is String) {
      errorMessage = json['message'] as String;
    }

    return ErrorMessage(
      sessionId: json['session_id']?.toString(),
      timestamp: timestamp,
      errorMessage: errorMessage,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'session_id': sessionId,
      'timestamp': timestamp.toIso8601String(),
      'is_complete': isComplete,
      'error': isError,
      'error_message': errorMessage,
    };
  }
}

/// Helper class for parsing JSON chunks and extracting structured data
class JsonChunkParser {
  static String _accumulatedJson = '';

  /// Accumulate JSON chunks and return parsed data when complete
  static Map<String, dynamic>? parseJsonChunk(String chunk) {
    _accumulatedJson += chunk;

    try {
      // Try to parse the accumulated JSON
      final jsonData = _accumulatedJson.trim();
      if (jsonData.isEmpty) return null;

      // Check if we have a complete JSON object
      if (_isCompleteJson(jsonData)) {
        // Parse the JSON string
        final parsed = json.decode(jsonData) as Map<String, dynamic>;
        _accumulatedJson = ''; // Reset for next message
        return parsed;
      }

      return null;
    } catch (e) {
      // If parsing fails, continue accumulating
      return null;
    }
  }

  /// Check if the JSON string is complete
  static bool _isCompleteJson(String json) {
    if (json.isEmpty) return false;

    // Simple heuristic: check for balanced braces
    int braceCount = 0;
    bool inString = false;
    bool escaped = false;

    for (int i = 0; i < json.length; i++) {
      final char = json[i];

      if (escaped) {
        escaped = false;
        continue;
      }

      if (char == '\\') {
        escaped = true;
        continue;
      }

      if (char == '"' && !escaped) {
        inString = !inString;
        continue;
      }

      if (!inString) {
        if (char == '{') {
          braceCount++;
        } else if (char == '}') {
          braceCount--;
        }
      }
    }

    return braceCount == 0 && !inString;
  }

  /// Reset the accumulator
  static void reset() {
    _accumulatedJson = '';
  }
}

/// Factory class to parse streaming messages
class StreamMessageFactory {
  static StreamMessage? fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String?;

    switch (type) {
      case 'metadata':
        return MetadataMessage.fromJson(json);
      case 'chunk':
        return ChunkMessage.fromJson(json);
      case 'action':
        return ActionMessage.fromJson(json);
      case 'complete':
        return CompleteMessage.fromJson(json);
      case 'error':
        // Handle both 'error_message' and 'message' fields for error messages
        return ErrorMessage.fromJson(json);
      default:
        return null;
    }
  }
}
