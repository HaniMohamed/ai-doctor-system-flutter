import 'package:dio/dio.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Map Dio errors to domain-relevant messages if needed
    // TODO: integrate with error_handler and observability hooks
    handler.next(err);
  }
}


