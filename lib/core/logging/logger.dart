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
  
  static void debug(String message, [String? tag, Object? error, StackTrace? stackTrace]) {
    _log(LogLevel.debug, message, tag, error, stackTrace);
  }
  
  static void info(String message, [String? tag, Object? error, StackTrace? stackTrace]) {
    _log(LogLevel.info, message, tag, error, stackTrace);
  }
  
  static void warning(String message, [String? tag, Object? error, StackTrace? stackTrace]) {
    _log(LogLevel.warning, message, tag, error, stackTrace);
  }
  
  static void error(String message, [String? tag, Object? error, StackTrace? stackTrace]) {
    _log(LogLevel.error, message, tag, error, stackTrace);
  }
  
  static void fatal(String message, [String? tag, Object? error, StackTrace? stackTrace]) {
    _log(LogLevel.fatal, message, tag, error, stackTrace);
  }
  
  static void _log(LogLevel level, String message, String? tag, Object? error, StackTrace? stackTrace) {
    // Only log in non-production environments or for errors/fatal messages
    if (!EnvironmentConfig.enableLogging && level != LogLevel.error && level != LogLevel.fatal) {
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
  
  // Convenience methods for common use cases
  static void apiRequest(String method, String url, Map<String, dynamic>? data) {
    debug('API Request: $method $url', 'API');
    if (data != null && EnvironmentConfig.enableLogging) {
      debug('Request Data: $data', 'API');
    }
  }
  
  static void apiResponse(int statusCode, String url, Duration responseTime) {
    final level = statusCode >= 400 ? LogLevel.error : LogLevel.info;
    _log(level, 'API Response: $statusCode $url (${responseTime.inMilliseconds}ms)', 'API', null, null);
  }
  
  static void apiError(String method, String url, Object error) {
    _log(LogLevel.error, 'API Error: $method $url', 'API', error, null);
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
}
