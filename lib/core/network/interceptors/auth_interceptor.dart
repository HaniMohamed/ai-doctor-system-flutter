import 'package:dio/dio.dart';
import '../../di/injection_container.dart';
import '../../../../features/auth/domain/services/auth_service.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      final auth = sl<AuthService>();
      final token = await auth.getAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (_) {
      // ignore token errors here; error handling will be in ErrorInterceptor
    }
    handler.next(options);
  }
}


