import 'package:dio/dio.dart';

import '../../errors/error_handler.dart';
import '../../observability/performance_metrics.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Map Dio errors to domain-relevant messages and integrate with error handling
    ErrorHandler.mapError(err);

    // Record error metrics for observability
    PerformanceMetrics().recordError(
      err,
      err.requestOptions.uri.toString(),
      err.requestOptions.method,
    );

    // Note: API error logging is now handled by LoggingInterceptor
    // to avoid duplication. This interceptor focuses on error mapping
    // and metrics collection.

    handler.next(err);
  }
}
