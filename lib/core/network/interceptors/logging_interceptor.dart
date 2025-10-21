import 'dart:convert';
import 'package:dio/dio.dart';
import '../../logging/logger.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Store start time for response time calculation
    options.extra['start_time'] = DateTime.now();

    // Generate correlation ID for request tracking
    final correlationId = _generateCorrelationId();
    options.extra['correlation_id'] = correlationId;

    // Extract user ID from headers if available
    final userId = _extractUserId(options.headers);

    // Generate curl command for debugging
    final curlCommand = _generateCurlCommand(options);

    // Enhanced request logging
    Logger.apiRequest(
      method: options.method,
      url: options.uri.toString(),
      data: options.data,
      headers: options.headers,
      correlationId: correlationId,
      userId: userId,
    );

    Logger.info('CURL Command: $curlCommand', 'API');

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final startTime = response.requestOptions.extra['start_time'] as DateTime?;
    final responseTime = startTime != null
        ? DateTime.now().difference(startTime)
        : Duration.zero;

    final correlationId =
        response.requestOptions.extra['correlation_id'] as String?;
    final contentLength = _getContentLength(response);

    // Enhanced response logging
    Logger.apiResponse(
      statusCode: response.statusCode ?? 0,
      url: response.requestOptions.uri.toString(),
      responseTime: responseTime,
      data: response.data,
      headers: response.headers.map,
      correlationId: correlationId,
      contentLength: contentLength,
    );

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final startTime = err.requestOptions.extra['start_time'] as DateTime?;
    final responseTime =
        startTime != null ? DateTime.now().difference(startTime) : null;

    final correlationId = err.requestOptions.extra['correlation_id'] as String?;
    final userId = _extractUserId(err.requestOptions.headers);

    // Enhanced error logging
    Logger.apiError(
      method: err.requestOptions.method,
      url: err.requestOptions.uri.toString(),
      error: err,
      correlationId: correlationId,
      userId: userId,
      statusCode: err.response?.statusCode,
      responseTime: responseTime,
    );

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
        // Convert to proper JSON string using jsonEncode
        dataString = jsonEncode(options.data);
      } else {
        dataString = options.data.toString();
      }

      // Escape quotes in data for shell
      dataString = dataString.replaceAll('"', '\\"');
      buffer.write(' -d "$dataString"');
    }

    // Add query parameters if any
    if (options.queryParameters.isNotEmpty) {
      final queryString = options.queryParameters.entries
          .map((e) => '${e.key}=${Uri.encodeComponent(e.value.toString())}')
          .join('&');
      buffer.write(' "?$queryString"');
    }

    return buffer.toString();
  }

  /// Generate a unique correlation ID for request tracking
  String _generateCorrelationId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = (timestamp % 10000).toString().padLeft(4, '0');
    return 'req_${timestamp}_$random';
  }

  /// Extract user ID from headers or request context
  String? _extractUserId(Map<String, dynamic> headers) {
    // Try to extract from Authorization header
    final authHeader = headers['Authorization'] as String?;
    if (authHeader != null && authHeader.startsWith('Bearer ')) {
      // In a real implementation, you might decode the JWT to get user ID
      // For now, we'll just indicate that a user is authenticated
      return 'authenticated_user';
    }

    // Try to extract from custom header
    final userIdHeader = headers['X-User-ID'] as String?;
    if (userIdHeader != null && userIdHeader.isNotEmpty) {
      return userIdHeader;
    }

    return null;
  }

  /// Get content length from response
  int? _getContentLength(Response response) {
    final contentLengthHeader = response.headers.value('content-length');
    if (contentLengthHeader != null) {
      return int.tryParse(contentLengthHeader);
    }

    // Try to calculate from response data
    if (response.data != null) {
      try {
        final jsonString = response.data is String
            ? response.data as String
            : jsonEncode(response.data);
        return jsonString.length;
      } catch (e) {
        return null;
      }
    }

    return null;
  }
}
