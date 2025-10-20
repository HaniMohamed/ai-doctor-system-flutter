---
title: "Error Handling & Resilience - AI Doctor System Flutter Client"
updated: "2024-12-01"
tags: ["error-handling", "resilience", "recovery", "healthcare"]
summary: "Comprehensive error handling and resilience strategy for healthcare-grade Flutter application"
---

# Error Handling & Resilience - AI Doctor System Flutter Client

## Error Handling Architecture Overview

The AI Doctor System implements a comprehensive error handling and resilience framework designed to ensure system reliability, graceful degradation, and optimal user experience even under adverse conditions. This framework is critical for healthcare applications where system failures can have serious consequences.

## Global Exception Strategy

### **Exception Hierarchy**
```dart
// Base exception class
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final Map<String, dynamic>? details;
  final StackTrace? stackTrace;
  
  AppException({
    required this.message,
    this.code,
    this.details,
    this.stackTrace,
  });
  
  @override
  String toString() => 'AppException: $message';
}

// Network-related exceptions
class NetworkException extends AppException {
  NetworkException({
    required String message,
    String? code,
    Map<String, dynamic>? details,
    StackTrace? stackTrace,
  }) : super(
    message: message,
    code: code ?? 'NETWORK_ERROR',
    details: details,
    stackTrace: stackTrace,
  );
}

class TimeoutException extends NetworkException {
  TimeoutException({
    required String message,
    Map<String, dynamic>? details,
    StackTrace? stackTrace,
  }) : super(
    message: message,
    code: 'TIMEOUT_ERROR',
    details: details,
    stackTrace: stackTrace,
  );
}

class ConnectivityException extends NetworkException {
  ConnectivityException({
    required String message,
    Map<String, dynamic>? details,
    StackTrace? stackTrace,
  }) : super(
    message: message,
    code: 'CONNECTIVITY_ERROR',
    details: details,
    stackTrace: stackTrace,
  );
}

// Authentication-related exceptions
class AuthenticationException extends AppException {
  AuthenticationException({
    required String message,
    String? code,
    Map<String, dynamic>? details,
    StackTrace? stackTrace,
  }) : super(
    message: message,
    code: code ?? 'AUTH_ERROR',
    details: details,
    stackTrace: stackTrace,
  );
}

class AuthorizationException extends AppException {
  AuthorizationException({
    required String message,
    Map<String, dynamic>? details,
    StackTrace? stackTrace,
  }) : super(
    message: message,
    code: 'AUTHORIZATION_ERROR',
    details: details,
    stackTrace: stackTrace,
  );
}

// AI service exceptions
class AIServiceException extends AppException {
  AIServiceException({
    required String message,
    String? code,
    Map<String, dynamic>? details,
    StackTrace? stackTrace,
  }) : super(
    message: message,
    code: code ?? 'AI_SERVICE_ERROR',
    details: details,
    stackTrace: stackTrace,
  );
}

class RateLimitException extends AIServiceException {
  RateLimitException({
    required String message,
    Map<String, dynamic>? details,
    StackTrace? stackTrace,
  }) : super(
    message: message,
    code: 'RATE_LIMIT_EXCEEDED',
    details: details,
    stackTrace: stackTrace,
  );
}

// Data-related exceptions
class DataException extends AppException {
  DataException({
    required String message,
    String? code,
    Map<String, dynamic>? details,
    StackTrace? stackTrace,
  }) : super(
    message: message,
    code: code ?? 'DATA_ERROR',
    details: details,
    stackTrace: stackTrace,
  );
}

class ValidationException extends DataException {
  ValidationException({
    required String message,
    Map<String, dynamic>? details,
    StackTrace? stackTrace,
  }) : super(
    message: message,
    code: 'VALIDATION_ERROR',
    details: details,
    stackTrace: stackTrace,
  );
}

// System exceptions
class SystemException extends AppException {
  SystemException({
    required String message,
    String? code,
    Map<String, dynamic>? details,
    StackTrace? stackTrace,
  }) : super(
    message: message,
    code: code ?? 'SYSTEM_ERROR',
    details: details,
    stackTrace: stackTrace,
  );
}
```

### **Global Error Handler**
```dart
class GlobalErrorHandler {
  static final GlobalErrorHandler _instance = GlobalErrorHandler._internal();
  factory GlobalErrorHandler() => _instance;
  GlobalErrorHandler._internal();
  
  final List<ErrorHandler> _handlers = [];
  final ErrorReportingService _errorReportingService;
  final LoggingService _loggingService;
  
  GlobalErrorHandler({
    ErrorReportingService? errorReportingService,
    LoggingService? loggingService,
  }) : _errorReportingService = errorReportingService ?? ErrorReportingService(),
       _loggingService = loggingService ?? LoggingService();
  
  void initialize() {
    // Set up Flutter error handling
    FlutterError.onError = (FlutterErrorDetails details) {
      _handleFlutterError(details);
    };
    
    // Set up Dart error handling
    PlatformDispatcher.instance.onError = (error, stack) {
      _handleDartError(error, stack);
      return true;
    };
    
    // Set up zone error handling
    runZonedGuarded(() {
      runApp(MyApp());
    }, (error, stack) {
      _handleZoneError(error, stack);
    });
  }
  
  void _handleFlutterError(FlutterErrorDetails details) {
    final error = FlutterException(
      message: details.exception.toString(),
      library: details.library,
      context: details.context?.toString(),
      stackTrace: details.stack,
    );
    
    _processError(error);
  }
  
  void _handleDartError(dynamic error, StackTrace stack) {
    final appError = SystemException(
      message: error.toString(),
      stackTrace: stack,
    );
    
    _processError(appError);
  }
  
  void _handleZoneError(dynamic error, StackTrace stack) {
    final appError = SystemException(
      message: error.toString(),
      stackTrace: stack,
    );
    
    _processError(appError);
  }
  
  void _processError(AppException error) {
    // Log error
    _loggingService.logError(error);
    
    // Report to error tracking service
    _errorReportingService.reportError(error);
    
    // Execute custom handlers
    for (final handler in _handlers) {
      try {
        handler.handleError(error);
      } catch (e) {
        // Prevent handler errors from causing infinite loops
        _loggingService.logError(SystemException(
          message: 'Error in error handler: $e',
          details: {'original_error': error.toString()},
        ));
      }
    }
    
    // Show user-friendly error message if appropriate
    _showUserError(error);
  }
  
  void _showUserError(AppException error) {
    // Only show user errors for certain types
    if (error is NetworkException || 
        error is AuthenticationException ||
        error is AIServiceException) {
      
      final userMessage = _getUserFriendlyMessage(error);
      
      Get.snackbar(
        'Error',
        userMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
  
  String _getUserFriendlyMessage(AppException error) {
    switch (error.runtimeType) {
      case NetworkException:
        return 'Please check your internet connection and try again.';
      case AuthenticationException:
        return 'Please log in again to continue.';
      case AIServiceException:
        return 'AI service is temporarily unavailable. Please try again later.';
      case RateLimitException:
        return 'You have reached the limit for AI requests. Please try again later.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
  
  void addHandler(ErrorHandler handler) {
    _handlers.add(handler);
  }
  
  void removeHandler(ErrorHandler handler) {
    _handlers.remove(handler);
  }
}

abstract class ErrorHandler {
  void handleError(AppException error);
}

class FlutterException extends AppException {
  final String? library;
  final String? context;
  
  FlutterException({
    required String message,
    this.library,
    this.context,
    StackTrace? stackTrace,
  }) : super(
    message: message,
    code: 'FLUTTER_ERROR',
    details: {
      'library': library,
      'context': context,
    },
    stackTrace: stackTrace,
  );
}
```

## Retry & Backoff Logic

### **Retry Policy Framework**
```dart
class RetryPolicy {
  final int maxRetries;
  final Duration initialDelay;
  final double backoffMultiplier;
  final Duration maxDelay;
  final bool exponentialBackoff;
  final List<Type> retryableExceptions;
  
  RetryPolicy({
    this.maxRetries = 3,
    this.initialDelay = const Duration(seconds: 1),
    this.backoffMultiplier = 2.0,
    this.maxDelay = const Duration(minutes: 5),
    this.exponentialBackoff = true,
    this.retryableExceptions = const [
      NetworkException,
      TimeoutException,
      AIServiceException,
    ],
  });
  
  bool shouldRetry(dynamic error, int attemptCount) {
    if (attemptCount >= maxRetries) return false;
    
    return retryableExceptions.any((type) => error.runtimeType == type);
  }
  
  Duration getDelay(int attemptCount) {
    if (!exponentialBackoff) return initialDelay;
    
    final delay = Duration(
      milliseconds: (initialDelay.inMilliseconds * 
                    pow(backoffMultiplier, attemptCount)).round(),
    );
    
    return delay > maxDelay ? maxDelay : delay;
  }
}

class RetryService {
  final RetryPolicy _policy;
  
  RetryService({RetryPolicy? policy}) : _policy = policy ?? RetryPolicy();
  
  Future<T> executeWithRetry<T>(
    Future<T> Function() operation, {
    String? operationName,
  }) async {
    int attemptCount = 0;
    
    while (attemptCount <= _policy.maxRetries) {
      try {
        return await operation();
      } catch (error) {
        attemptCount++;
        
        if (!_policy.shouldRetry(error, attemptCount)) {
          rethrow;
        }
        
        if (attemptCount <= _policy.maxRetries) {
          final delay = _policy.getDelay(attemptCount - 1);
          
          // Log retry attempt
          LoggingService.logInfo(
            'Retrying operation: $operationName (attempt $attemptCount)',
            details: {
              'error': error.toString(),
              'delay_ms': delay.inMilliseconds,
            },
          );
          
          await Future.delayed(delay);
        }
      }
    }
    
    throw SystemException(
      message: 'Operation failed after ${_policy.maxRetries} retries',
      details: {'operation': operationName},
    );
  }
}
```

### **Circuit Breaker Pattern**
```dart
enum CircuitBreakerState {
  closed,
  open,
  halfOpen,
}

class CircuitBreaker {
  final int failureThreshold;
  final Duration timeout;
  final Duration resetTimeout;
  
  CircuitBreakerState _state = CircuitBreakerState.closed;
  int _failureCount = 0;
  DateTime? _lastFailureTime;
  DateTime? _nextAttemptTime;
  
  CircuitBreaker({
    this.failureThreshold = 5,
    this.timeout = const Duration(minutes: 1),
    this.resetTimeout = const Duration(minutes: 5),
  });
  
  Future<T> execute<T>(Future<T> Function() operation) async {
    if (_state == CircuitBreakerState.open) {
      if (_nextAttemptTime != null && DateTime.now().isBefore(_nextAttemptTime!)) {
        throw SystemException(
          message: 'Circuit breaker is open',
          code: 'CIRCUIT_BREAKER_OPEN',
        );
      }
      
      _state = CircuitBreakerState.halfOpen;
    }
    
    try {
      final result = await operation().timeout(timeout);
      _onSuccess();
      return result;
    } catch (error) {
      _onFailure();
      rethrow;
    }
  }
  
  void _onSuccess() {
    _failureCount = 0;
    _state = CircuitBreakerState.closed;
    _lastFailureTime = null;
    _nextAttemptTime = null;
  }
  
  void _onFailure() {
    _failureCount++;
    _lastFailureTime = DateTime.now();
    
    if (_failureCount >= failureThreshold) {
      _state = CircuitBreakerState.open;
      _nextAttemptTime = DateTime.now().add(resetTimeout);
      
      LoggingService.logError(
        SystemException(
          message: 'Circuit breaker opened due to $failureCount failures',
          code: 'CIRCUIT_BREAKER_OPENED',
        ),
      );
    }
  }
  
  CircuitBreakerState get state => _state;
  int get failureCount => _failureCount;
}
```

## Offline UX Patterns

### **Offline State Management**
```dart
class OfflineManager {
  final ConnectivityService _connectivityService;
  final LocalStorageService _localStorageService;
  final StreamController<OfflineState> _stateController = StreamController.broadcast();
  
  OfflineState _currentState = OfflineState.online;
  final List<PendingOperation> _pendingOperations = [];
  
  OfflineManager({
    required ConnectivityService connectivityService,
    required LocalStorageService localStorageService,
  }) : _connectivityService = connectivityService,
       _localStorageService = localStorageService;
  
  Stream<OfflineState> get stateStream => _stateController.stream;
  OfflineState get currentState => _currentState;
  
  void initialize() {
    _connectivityService.connectivityStream.listen((connectivity) {
      _updateOfflineState(connectivity);
    });
  }
  
  void _updateOfflineState(ConnectivityResult connectivity) {
    final newState = connectivity == ConnectivityResult.none 
        ? OfflineState.offline 
        : OfflineState.online;
    
    if (newState != _currentState) {
      _currentState = newState;
      _stateController.add(newState);
      
      if (newState == OfflineState.online) {
        _processPendingOperations();
      }
    }
  }
  
  Future<void> executeOperation(PendingOperation operation) async {
    if (_currentState == OfflineState.online) {
      try {
        await operation.execute();
      } catch (error) {
        // If operation fails, queue it for retry
        _pendingOperations.add(operation);
      }
    } else {
      // Queue operation for when we're back online
      _pendingOperations.add(operation);
      _localStorageService.storePendingOperation(operation);
    }
  }
  
  Future<void> _processPendingOperations() async {
    final operations = List<PendingOperation>.from(_pendingOperations);
    _pendingOperations.clear();
    
    for (final operation in operations) {
      try {
        await operation.execute();
        await _localStorageService.removePendingOperation(operation.id);
      } catch (error) {
        // Re-queue failed operations
        _pendingOperations.add(operation);
      }
    }
  }
}

enum OfflineState {
  online,
  offline,
  reconnecting,
}

class PendingOperation {
  final String id;
  final String type;
  final Map<String, dynamic> data;
  final DateTime createdAt;
  
  PendingOperation({
    required this.id,
    required this.type,
    required this.data,
    required this.createdAt,
  });
  
  Future<void> execute() async {
    // Implementation depends on operation type
    switch (type) {
      case 'create_appointment':
        await _executeCreateAppointment();
        break;
      case 'send_message':
        await _executeSendMessage();
        break;
      case 'update_profile':
        await _executeUpdateProfile();
        break;
      default:
        throw SystemException(message: 'Unknown operation type: $type');
    }
  }
  
  Future<void> _executeCreateAppointment() async {
    // Execute appointment creation
  }
  
  Future<void> _executeSendMessage() async {
    // Execute message sending
  }
  
  Future<void> _executeUpdateProfile() async {
    // Execute profile update
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'data': data,
      'created_at': createdAt.toIso8601String(),
    };
  }
  
  factory PendingOperation.fromJson(Map<String, dynamic> json) {
    return PendingOperation(
      id: json['id'] as String,
      type: json['type'] as String,
      data: json['data'] as Map<String, dynamic>,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
```

### **Offline UI Components**
```dart
class OfflineIndicator extends StatelessWidget {
  final OfflineManager _offlineManager;
  
  const OfflineIndicator({
    Key? key,
    required OfflineManager offlineManager,
  }) : _offlineManager = offlineManager,
       super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<OfflineState>(
      stream: _offlineManager.stateStream,
      builder: (context, snapshot) {
        final state = snapshot.data ?? _offlineManager.currentState;
        
        if (state == OfflineState.offline) {
          return Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            color: Colors.orange,
            child: Row(
              children: [
                Icon(Icons.wifi_off, color: Colors.white, size: 16),
                SizedBox(width: 8),
                Text(
                  'You are offline. Changes will be synced when connection is restored.',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          );
        }
        
        return SizedBox.shrink();
      },
    );
  }
}

class OfflineAwareButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final OfflineManager _offlineManager;
  
  const OfflineAwareButton({
    Key? key,
    required this.child,
    this.onPressed,
    required OfflineManager offlineManager,
  }) : _offlineManager = offlineManager,
       super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<OfflineState>(
      stream: _offlineManager.stateStream,
      builder: (context, snapshot) {
        final state = snapshot.data ?? _offlineManager.currentState;
        
        return Opacity(
          opacity: state == OfflineState.offline ? 0.6 : 1.0,
          child: child,
        );
      },
    );
  }
}
```

## Conflict Resolution

### **Data Synchronization Conflicts**
```dart
class ConflictResolver {
  final LocalStorageService _localStorageService;
  final RemoteDataService _remoteDataService;
  
  ConflictResolver({
    required LocalStorageService localStorageService,
    required RemoteDataService remoteDataService,
  }) : _localStorageService = localStorageService,
       _remoteDataService = remoteDataService;
  
  Future<T> resolveConflict<T>(
    String entityId,
    T localVersion,
    T remoteVersion,
    ConflictResolutionStrategy strategy,
  ) async {
    switch (strategy) {
      case ConflictResolutionStrategy.lastWriteWins:
        return _resolveLastWriteWins(localVersion, remoteVersion);
      case ConflictResolutionStrategy.firstWriteWins:
        return _resolveFirstWriteWins(localVersion, remoteVersion);
      case ConflictResolutionStrategy.merge:
        return _resolveMerge(localVersion, remoteVersion);
      case ConflictResolutionStrategy.userChoice:
        return _resolveUserChoice(entityId, localVersion, remoteVersion);
    }
  }
  
  T _resolveLastWriteWins<T>(T localVersion, T remoteVersion) {
    // Compare timestamps and return the most recent version
    // Implementation depends on entity type
    return remoteVersion; // Simplified for example
  }
  
  T _resolveFirstWriteWins<T>(T localVersion, T remoteVersion) {
    // Return the first version that was written
    return localVersion; // Simplified for example
  }
  
  T _resolveMerge<T>(T localVersion, T remoteVersion) {
    // Merge changes from both versions
    // Implementation depends on entity type and merge logic
    return remoteVersion; // Simplified for example
  }
  
  Future<T> _resolveUserChoice<T>(
    String entityId,
    T localVersion,
    T remoteVersion,
  ) async {
    // Show conflict resolution dialog to user
    final choice = await _showConflictDialog(entityId, localVersion, remoteVersion);
    
    switch (choice) {
      case ConflictChoice.useLocal:
        return localVersion;
      case ConflictChoice.useRemote:
        return remoteVersion;
      case ConflictChoice.merge:
        return _resolveMerge(localVersion, remoteVersion);
    }
  }
  
  Future<ConflictChoice> _showConflictDialog<T>(
    String entityId,
    T localVersion,
    T remoteVersion,
  ) async {
    return await Get.dialog<ConflictChoice>(
      ConflictResolutionDialog(
        entityId: entityId,
        localVersion: localVersion,
        remoteVersion: remoteVersion,
      ),
    ) ?? ConflictChoice.useRemote;
  }
}

enum ConflictResolutionStrategy {
  lastWriteWins,
  firstWriteWins,
  merge,
  userChoice,
}

enum ConflictChoice {
  useLocal,
  useRemote,
  merge,
}

class ConflictResolutionDialog extends StatelessWidget {
  final String entityId;
  final dynamic localVersion;
  final dynamic remoteVersion;
  
  const ConflictResolutionDialog({
    Key? key,
    required this.entityId,
    required this.localVersion,
    required this.remoteVersion,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Data Conflict'),
      content: Text(
        'There is a conflict between local and remote versions of $entityId. '
        'Which version would you like to keep?',
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(result: ConflictChoice.useLocal),
          child: Text('Use Local'),
        ),
        TextButton(
          onPressed: () => Get.back(result: ConflictChoice.useRemote),
          child: Text('Use Remote'),
        ),
        TextButton(
          onPressed: () => Get.back(result: ConflictChoice.merge),
          child: Text('Merge'),
        ),
      ],
    );
  }
}
```

## Logging & Error Reporting

### **Structured Logging System**
```dart
enum LogLevel {
  debug,
  info,
  warning,
  error,
  critical,
}

class LogEntry {
  final LogLevel level;
  final String message;
  final DateTime timestamp;
  final String? category;
  final Map<String, dynamic>? details;
  final StackTrace? stackTrace;
  
  LogEntry({
    required this.level,
    required this.message,
    required this.timestamp,
    this.category,
    this.details,
    this.stackTrace,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'level': level.name,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'category': category,
      'details': details,
      'stack_trace': stackTrace?.toString(),
    };
  }
}

class LoggingService {
  static final LoggingService _instance = LoggingService._internal();
  factory LoggingService() => _instance;
  LoggingService._internal();
  
  final List<LogSink> _sinks = [];
  final LogLevel _minimumLevel = LogLevel.info;
  
  void addSink(LogSink sink) {
    _sinks.add(sink);
  }
  
  void log(LogLevel level, String message, {
    String? category,
    Map<String, dynamic>? details,
    StackTrace? stackTrace,
  }) {
    if (level.index < _minimumLevel.index) return;
    
    final entry = LogEntry(
      level: level,
      message: message,
      timestamp: DateTime.now(),
      category: category,
      details: details,
      stackTrace: stackTrace,
    );
    
    for (final sink in _sinks) {
      sink.log(entry);
    }
  }
  
  static void logDebug(String message, {String? category, Map<String, dynamic>? details}) {
    _instance.log(LogLevel.debug, message, category: category, details: details);
  }
  
  static void logInfo(String message, {String? category, Map<String, dynamic>? details}) {
    _instance.log(LogLevel.info, message, category: category, details: details);
  }
  
  static void logWarning(String message, {String? category, Map<String, dynamic>? details}) {
    _instance.log(LogLevel.warning, message, category: category, details: details);
  }
  
  static void logError(AppException error, {String? category}) {
    _instance.log(
      LogLevel.error,
      error.message,
      category: category,
      details: {
        'code': error.code,
        'details': error.details,
      },
      stackTrace: error.stackTrace,
    );
  }
  
  static void logCritical(String message, {String? category, Map<String, dynamic>? details, StackTrace? stackTrace}) {
    _instance.log(LogLevel.critical, message, category: category, details: details, stackTrace: stackTrace);
  }
}

abstract class LogSink {
  void log(LogEntry entry);
}

class ConsoleLogSink implements LogSink {
  @override
  void log(LogEntry entry) {
    print('${entry.timestamp} [${entry.level.name.toUpperCase()}] ${entry.message}');
    if (entry.details != null) {
      print('Details: ${entry.details}');
    }
    if (entry.stackTrace != null) {
      print('Stack trace: ${entry.stackTrace}');
    }
  }
}

class FileLogSink implements LogSink {
  final String filePath;
  
  FileLogSink(this.filePath);
  
  @override
  void log(LogEntry entry) {
    // Write to file
    final file = File(filePath);
    final logLine = '${entry.toJson()}\n';
    file.writeAsStringSync(logLine, mode: FileMode.append);
  }
}

class RemoteLogSink implements LogSink {
  final String endpoint;
  final Dio _httpClient;
  
  RemoteLogSink(this.endpoint) : _httpClient = Dio();
  
  @override
  void log(LogEntry entry) {
    // Send to remote logging service
    _httpClient.post(endpoint, data: entry.toJson()).catchError((error) {
      // Don't let logging errors crash the app
      print('Failed to send log to remote service: $error');
    });
  }
}
```

### **Error Reporting Service**
```dart
class ErrorReportingService {
  final List<ErrorReporter> _reporters = [];
  
  void addReporter(ErrorReporter reporter) {
    _reporters.add(reporter);
  }
  
  Future<void> reportError(AppException error) async {
    final errorReport = ErrorReport(
      error: error,
      timestamp: DateTime.now(),
      deviceInfo: await _getDeviceInfo(),
      userInfo: await _getUserInfo(),
      context: await _getContext(),
    );
    
    for (final reporter in _reporters) {
      try {
        await reporter.reportError(errorReport);
      } catch (e) {
        // Don't let error reporting failures crash the app
        print('Failed to report error: $e');
      }
    }
  }
  
  Future<Map<String, dynamic>> _getDeviceInfo() async {
    return {
      'platform': Platform.operatingSystem,
      'version': Platform.operatingSystemVersion,
      'app_version': await _getAppVersion(),
      'device_model': await _getDeviceModel(),
    };
  }
  
  Future<Map<String, dynamic>> _getUserInfo() async {
    final user = await AuthService.getCurrentUser();
    return {
      'user_id': user?.id,
      'organization_id': user?.organizationId,
      'role': user?.role,
    };
  }
  
  Future<Map<String, dynamic>> _getContext() async {
    return {
      'screen': Get.currentRoute,
      'timestamp': DateTime.now().toIso8601String(),
      'memory_usage': await _getMemoryUsage(),
    };
  }
  
  Future<String> _getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }
  
  Future<String> _getDeviceModel() async {
    // Implementation to get device model
    return 'Unknown';
  }
  
  Future<int> _getMemoryUsage() async {
    // Implementation to get memory usage
    return 0;
  }
}

abstract class ErrorReporter {
  Future<void> reportError(ErrorReport report);
}

class ErrorReport {
  final AppException error;
  final DateTime timestamp;
  final Map<String, dynamic> deviceInfo;
  final Map<String, dynamic> userInfo;
  final Map<String, dynamic> context;
  
  ErrorReport({
    required this.error,
    required this.timestamp,
    required this.deviceInfo,
    required this.userInfo,
    required this.context,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'error': {
        'message': error.message,
        'code': error.code,
        'details': error.details,
        'stack_trace': error.stackTrace?.toString(),
      },
      'timestamp': timestamp.toIso8601String(),
      'device_info': deviceInfo,
      'user_info': userInfo,
      'context': context,
    };
  }
}

class FirebaseCrashlyticsReporter implements ErrorReporter {
  @override
  Future<void> reportError(ErrorReport report) async {
    // Report to Firebase Crashlytics
    await FirebaseCrashlytics.instance.recordError(
      report.error,
      report.error.stackTrace,
      reason: report.error.message,
      information: [
        'Device Info: ${report.deviceInfo}',
        'User Info: ${report.userInfo}',
        'Context: ${report.context}',
      ],
    );
  }
}

class SentryReporter implements ErrorReporter {
  @override
  Future<void> reportError(ErrorReport report) async {
    // Report to Sentry
    await Sentry.captureException(
      report.error,
      stackTrace: report.error.stackTrace,
      withScope: (scope) {
        scope.setTag('error_code', report.error.code ?? 'unknown');
        scope.setContext('device_info', report.deviceInfo);
        scope.setContext('user_info', report.userInfo);
        scope.setContext('context', report.context);
      },
    );
  }
}
```

This comprehensive error handling and resilience framework ensures that the AI Doctor System can gracefully handle failures, maintain data consistency, and provide a reliable user experience even under adverse conditions. The system is designed to be self-healing and provides clear feedback to users about system state and any issues that may occur.
