import 'package:dio/dio.dart';
import '../utils/const/api_url.dart';

class ApiService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiUrl.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 60),
      headers: {'Accept': 'application/json'},
    ),
  );

  static Dio get dio => _dio;

  // Add authorization header to all requests
  static void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  // Remove authorization header
  static void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }
}
