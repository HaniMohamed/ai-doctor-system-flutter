import 'package:dio/dio.dart';
import 'exceptions.dart';
import 'failures.dart';

class ErrorHandler {
  static Failure mapError(Object error) {
    if (error is Failure) return error;
    if (error is DioException) {
      final status = error.response?.statusCode;
      final message = error.message ?? 'Network error';
      if (status == 401) return const AuthenticationFailure('Unauthorized');
      return ServerFailure(message, statusCode: status);
    }
    if (error is ServerException) {
      return ServerFailure(error.message, statusCode: error.statusCode);
    }
    if (error is CacheException) {
      return CacheFailure(error.message);
    }
    if (error is AuthenticationException) {
      return AuthenticationFailure(error.message);
    }
    return const ServerFailure('Unexpected error');
  }
}


