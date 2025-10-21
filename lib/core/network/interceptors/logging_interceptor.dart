import 'package:dio/dio.dart';
import '../../logging/logger.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Store start time for response time calculation
    options.extra['start_time'] = DateTime.now();

    // Generate curl command for debugging
    final curlCommand = _generateCurlCommand(options);
    Logger.apiRequest(options.method, options.uri.toString(), options.data);
    Logger.info('CURL Command: $curlCommand', 'API');

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final startTime = response.requestOptions.extra['start_time'] as DateTime?;
    final responseTime = startTime != null
        ? DateTime.now().difference(startTime)
        : Duration.zero;
    Logger.apiResponse(response.statusCode ?? 0,
        response.requestOptions.uri.toString(), responseTime);
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    Logger.apiError(
        err.requestOptions.method, err.requestOptions.uri.toString(), err);
    handler.next(err);
  }

  /// Generate curl command from Dio RequestOptions
  String _generateCurlCommand(RequestOptions options) {
    final buffer = StringBuffer();

    // Start with curl command
    buffer.write('curl -X ${options.method.toUpperCase()}');

    // Add URL
    buffer.write(' "${options.uri}"');

    // Add headers
    options.headers.forEach((key, value) {
      if (key.toLowerCase() != 'content-length') {
        buffer.write(' -H "$key: $value"');
      }
    });

    // Add data/body
    if (options.data != null) {
      String dataString;
      if (options.data is String) {
        dataString = options.data as String;
      } else if (options.data is Map || options.data is List) {
        dataString = options.data.toString();
      } else {
        dataString = options.data.toString();
      }

      // Escape quotes in data
      dataString = dataString.replaceAll('"', '\\"');
      buffer.write(' -d "$dataString"');
    }

    // Add query parameters if any
    if (options.queryParameters.isNotEmpty) {
      final queryString = options.queryParameters.entries
          .map((e) => '${e.key}=${e.value}')
          .join('&');
      buffer.write(' "?$queryString"');
    }

    return buffer.toString();
  }
}
