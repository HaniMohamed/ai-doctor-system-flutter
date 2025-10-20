import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../models/auth_tokens_model.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<void> logout();
  Future<UserModel> getCurrentUser();
  Future<AuthTokensModel> refreshToken(String refreshToken);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _apiClient;

  AuthRemoteDataSourceImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<UserModel> login(String email, String password) async {
    final response = await _apiClient.post(
      '/auth/login',
      data: {
        'username': email,
        'password': password,
      },
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
    return UserModel.fromJson(response.data);
  }

  @override
  Future<void> logout() async {
    await _apiClient.post('/auth/logout');
  }

  @override
  Future<UserModel> getCurrentUser() async {
    final response = await _apiClient.get('/auth/me');
    return UserModel.fromJson(response.data);
  }

  @override
  Future<AuthTokensModel> refreshToken(String refreshToken) async {
    final response = await _apiClient.post(
      '/auth/refresh',
    );
    return AuthTokensModel.fromJson(response.data);
  }
}
