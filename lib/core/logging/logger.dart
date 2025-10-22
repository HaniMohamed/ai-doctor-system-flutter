import 'dart:convert';
import 'dart:developer' as developer;
import '../config/environment_config.dart';

enum LogLevel {
  debug,
  info,
  warning,
  error,
  fatal,
}

class Logger {
  static const String _logName = 'AI_Doctor_App';

  static void debug(String message,
      [String? tag, Object? error, StackTrace? stackTrace]) {
    _log(LogLevel.debug, message, tag, error, stackTrace);
  }

  static void info(String message,
      [String? tag, Object? error, StackTrace? stackTrace]) {
    _log(LogLevel.info, message, tag, error, stackTrace);
  }

  static void warning(String message,
      [String? tag, Object? error, StackTrace? stackTrace]) {
    _log(LogLevel.warning, message, tag, error, stackTrace);
  }

  static void error(String message,
      [String? tag, Object? error, StackTrace? stackTrace]) {
    _log(LogLevel.error, message, tag, error, stackTrace);
  }

  static void fatal(String message,
      [String? tag, Object? error, StackTrace? stackTrace]) {
    _log(LogLevel.fatal, message, tag, error, stackTrace);
  }

  static void _log(LogLevel level, String message, String? tag, Object? error,
      StackTrace? stackTrace) {
    // Only log in non-production environments or for errors/fatal messages
    if (!EnvironmentConfig.enableLogging &&
        level != LogLevel.error &&
        level != LogLevel.fatal) {
      return;
    }

    final timestamp = DateTime.now().toIso8601String();
    final levelName = level.name.toUpperCase();
    final tagPrefix = tag != null ? '[$tag] ' : '';
    final logMessage = '$timestamp [$levelName] $tagPrefix$message';

    // Use developer.log for better integration with Flutter tools
    developer.log(
      logMessage,
      name: _logName,
      level: _getDeveloperLogLevel(level),
      error: error,
      stackTrace: stackTrace,
    );

    // Also print to console in development for immediate feedback
    if (EnvironmentConfig.enableLogging) {
      _printToConsole(level, logMessage);
    }
  }

  static int _getDeveloperLogLevel(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return 500; // developer.log levels: 0=fine, 100=debug, 200=info, 400=warning, 800=error, 1600=severe
      case LogLevel.info:
        return 200;
      case LogLevel.warning:
        return 400;
      case LogLevel.error:
        return 800;
      case LogLevel.fatal:
        return 1600;
    }
  }

  static void _printToConsole(LogLevel level, String message) {
    switch (level) {
      case LogLevel.debug:
        // Use a subtle color for debug messages
        developer.log(message, name: 'DEBUG');
        break;
      case LogLevel.info:
        // Use default color for info messages
        developer.log(message, name: 'INFO');
        break;
      case LogLevel.warning:
        // Use yellow color for warnings
        developer.log(message, name: 'WARNING');
        break;
      case LogLevel.error:
        // Use red color for errors
        developer.log(message, name: 'ERROR');
        break;
      case LogLevel.fatal:
        // Use bold red for fatal errors
        developer.log(message, name: 'FATAL');
        break;
    }
  }

  // Enhanced API logging methods
  static void apiRequest({
    required String method,
    required String url,
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
    String? correlationId,
    String? userId,
  }) {
    final requestInfo = StringBuffer();
    requestInfo.write('🚀 API Request: $method $url');

    if (correlationId != null) {
      requestInfo.write(' [ID: $correlationId]');
    }
    if (userId != null) {
      requestInfo.write(' [User: $userId]');
    }

    debug(requestInfo.toString(), 'API');

    if (EnvironmentConfig.enableLogging) {
      if (data != null) {
        final dataSize = _calculateDataSize(data);
        debug('📤 Request Data (${dataSize}): ${_truncateData(data)}', 'API');
      }

      if (headers != null && headers.isNotEmpty) {
        final filteredHeaders = _filterSensitiveHeaders(headers);
        debug('📋 Headers: $filteredHeaders', 'API');
      }
    }
  }

  static void apiResponse({
    required int statusCode,
    required String url,
    required Duration responseTime,
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
    String? correlationId,
    int? contentLength,
  }) {
    final level = statusCode >= 400 ? LogLevel.error : LogLevel.info;
    final emoji = statusCode >= 400 ? '❌' : (statusCode >= 300 ? '⚠️' : '✅');

    final responseInfo = StringBuffer();
    responseInfo.write('$emoji API Response: $statusCode $url');
    responseInfo.write(' (${responseTime.inMilliseconds}ms)');

    if (correlationId != null) {
      responseInfo.write(' [ID: $correlationId]');
    }
    if (contentLength != null) {
      responseInfo.write(' [Size: ${_formatBytes(contentLength)}]');
    }

    _log(level, responseInfo.toString(), 'API', null, null);

    if (EnvironmentConfig.enableLogging && data != null) {
      debug('📥 Response Data: ${_truncateData(data)}', 'API');
    }

    if (EnvironmentConfig.enableLogging &&
        headers != null &&
        headers.isNotEmpty) {
      final filteredHeaders = _filterSensitiveHeaders(headers);
      debug('📋 Response Headers: $filteredHeaders', 'API');
    }
  }

  static void apiError({
    required String method,
    required String url,
    required Object error,
    String? correlationId,
    String? userId,
    int? statusCode,
    Duration? responseTime,
  }) {
    final errorInfo = StringBuffer();
    errorInfo.write('💥 API Error: $method $url');

    if (statusCode != null) {
      errorInfo.write(' [$statusCode]');
    }
    if (correlationId != null) {
      errorInfo.write(' [ID: $correlationId]');
    }
    if (userId != null) {
      errorInfo.write(' [User: $userId]');
    }
    if (responseTime != null) {
      errorInfo.write(' (${responseTime.inMilliseconds}ms)');
    }

    _log(LogLevel.error, errorInfo.toString(), 'API', error, null);
  }

  static void authEvent(String event, String? userId) {
    final message = userId != null ? '$event (User: $userId)' : event;
    info(message, 'AUTH');
  }

  static void navigationEvent(String from, String to) {
    debug('Navigation: $from -> $to', 'NAVIGATION');
  }

  static void userAction(String action, [Map<String, dynamic>? data]) {
    debug('User Action: $action', 'USER');
    if (data != null && EnvironmentConfig.enableLogging) {
      debug('Action Data: $data', 'USER');
    }
  }

  // Public helper to safely truncate/preview data structures in logs
  static dynamic preview(dynamic data, {int maxLength = 1000}) {
    return _truncateData(data, maxLength: maxLength);
  }

  // Helper methods for enhanced API logging
  static String _calculateDataSize(dynamic data) {
    try {
      final jsonString = data is String ? data : jsonEncode(data);
      return _formatBytes(jsonString.length);
    } catch (e) {
      return 'Unknown';
    }
  }

  static String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  static Map<String, dynamic> _filterSensitiveHeaders(
      Map<String, dynamic> headers) {
    final sensitiveKeys = [
      'authorization',
      'cookie',
      'x-api-key',
      'x-auth-token'
    ];
    final filtered = <String, dynamic>{};

    headers.forEach((key, value) {
      if (!sensitiveKeys.contains(key.toLowerCase())) {
        filtered[key] = value;
      } else {
        filtered[key] = '***REDACTED***';
      }
    });

    return filtered;
  }

  static dynamic _truncateData(dynamic data, {int maxLength = 1000}) {
    try {
      final jsonString = data is String ? data : jsonEncode(data);
      if (jsonString.length <= maxLength) {
        return data;
      }
      return '${jsonString.substring(0, maxLength)}... [TRUNCATED]';
    } catch (e) {
      return data.toString().length <= maxLength
          ? data.toString()
          : '${data.toString().substring(0, maxLength)}... [TRUNCATED]';
    }
  }
}
