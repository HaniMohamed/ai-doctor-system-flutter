import 'package:dio/dio.dart';

import '../../errors/error_handler.dart';
import '../../logging/logger.dart';
import '../../observability/performance_metrics.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Map Dio errors to domain-relevant messages and integrate with error handling
    final failure = ErrorHandler.mapError(err);
    
    // Record error metrics for observability
    PerformanceMetrics().recordError(
      err,
      err.requestOptions.uri.toString(),
      err.requestOptions.method,
    );
    
    // Log error details for debugging with failure message
    Logger.error(
      'API Error: ${err.response?.statusCode} ${err.requestOptions.uri} - ${failure.message}',
      'API',
      err,
    );
    
    handler.next(err);
  }
}


