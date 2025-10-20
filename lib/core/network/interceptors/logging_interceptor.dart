import 'package:dio/dio.dart';
import '../../logging/logger.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Store start time for response time calculation
    options.extra['start_time'] = DateTime.now();
    Logger.apiRequest(options.method, options.uri.toString(), options.data);
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final startTime = response.requestOptions.extra['start_time'] as DateTime?;
    final responseTime = startTime != null 
        ? DateTime.now().difference(startTime)
        : Duration.zero;
    Logger.apiResponse(response.statusCode ?? 0, response.requestOptions.uri.toString(), responseTime);
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    Logger.apiError(err.requestOptions.method, err.requestOptions.uri.toString(), err);
    handler.next(err);
  }
}


