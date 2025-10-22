import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';

import '../config/environment_config.dart';
import '../services/language_service.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/logging_interceptor.dart';

class ApiClient {
  late dio.Dio _dio;

  ApiClient() {
    _dio = dio.Dio(
      dio.BaseOptions(
        baseUrl: '${EnvironmentConfig.apiBaseUrl}/api/v1',
        connectTimeout: const Duration(minutes: 1),
        receiveTimeout: const Duration(minutes: 4),
        sendTimeout: const Duration(seconds: 20),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Accept-Language': _getLanguageHeader(),
        },
      ),
    );
    _setupInterceptors();
  }

  String _getLanguageHeader() {
    try {
      if (Get.isRegistered<LanguageService>()) {
        return LanguageService.instance.currentLanguageHeader;
      }
    } catch (e) {
      // Fallback to default language
    }
    return 'en-US';
  }

  void _setupInterceptors() {
    _dio.interceptors.addAll([
      AuthInterceptor(),
      ErrorInterceptor(),
      LoggingInterceptor(),
    ]);
  }

  void updateLanguageHeader() {
    _dio.options.headers['Accept-Language'] = _getLanguageHeader();
  }

  Future<dio.Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    dio.Options? options,
  }) async {
    return _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<dio.Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    dio.Options? options,
  }) async {
    return _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<dio.Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    dio.Options? options,
  }) async {
    return _dio.put<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<dio.Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    dio.Options? options,
  }) async {
    return _dio.delete<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }
}
