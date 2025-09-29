import 'dart:developer';

import 'package:dio/dio.dart';
import 'api_service.dart';
import '../utils/token_manager.dart';

class AuthService {
  // Login API call
  static Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    try {
      log('Login API called with username: $username');
      final response = await ApiService.dio.post(
        'Login',
        data: FormData.fromMap({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        log('Login response: $data');

        // Store token if present in response
        if (data['token'] != null) {
          await TokenManager.storeToken(data['token']);
          ApiService.setAuthToken(data['token']);
          log('Token stored: ${data['token']}');
        }

        // Store user data if present
        if (data['user'] != null) {
          await TokenManager.storeUserData(data['user']);
        }

        return {
          'success': true,
          'message': data['message'] ?? 'Login successful',
          'data': data,
        };
      } else {
        log('Login failed with status: ${response.statusCode}');
        return {'success': false, 'message': 'Login failed', 'data': null};
      }
    } on DioException catch (e) {
      String errorMessage = 'Login failed';
      log('DioException: ${e.toString()}');
      log('Response data: ${e.response?.data}');

      if (e.response?.data != null) {
        errorMessage =
            e.response!.data['message'] ??
            e.response!.data['error'] ??
            'Login failed';
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage =
            'Connection timeout. Please check your internet connection.';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'Request timeout. Please try again.';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'No internet connection. Please check your network.';
      }

      return {'success': false, 'message': errorMessage, 'data': null};
    } catch (e) {
      return {
        'success': false,
        'message': 'An unexpected error occurred: ${e.toString()}',
        'data': null,
      };
    }
  }

  // Get stored token
  static Future<String?> getStoredToken() async {
    return await TokenManager.getToken();
  }

  // Get stored user data
  static Future<Map<String, dynamic>?> getStoredUserData() async {
    return await TokenManager.getUserData();
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    return await TokenManager.isLoggedIn();
  }

  // Logout - clear stored data
  static Future<void> logout() async {
    await TokenManager.clearAll();
    ApiService.clearAuthToken();
  }

  // Initialize auth token on app start
  static Future<void> initializeAuth() async {
    final token = await TokenManager.getToken();
    if (token != null && token.isNotEmpty) {
      ApiService.setAuthToken(token);
    }
  }
}
