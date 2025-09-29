import 'dart:developer';
import 'package:dio/dio.dart';
import 'api_service.dart';
import '../models/branch_model.dart';

class BranchService {
  // Get branch list API call - parse response and return branches
  static Future<Map<String, dynamic>> getBranchList() async {
    try {
      log('Fetching branch list...');
      log('API Base URL: ${ApiService.dio.options.baseUrl}');
      log('Full URL: ${ApiService.dio.options.baseUrl}BranchList');
      log('Headers: ${ApiService.dio.options.headers}');

      final response = await ApiService.dio.get(
        'BranchList',
        options: Options(
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 10),
        ),
      );

      log('Branch list response status: ${response.statusCode}');
      log('Branch list response data: ${response.data}');
      log('Branch list response data type: ${response.data.runtimeType}');

      if (response.statusCode == 200) {
        final data = response.data;
        List<BranchModel> branches = [];

        // Parse the actual API response structure
        if (data is Map<String, dynamic>) {
          if (data['status'] == true && data['branches'] is List) {
            log('✅ Found branches array in response');
            final branchesList = data['branches'] as List;
            log('Number of branches: ${branchesList.length}');

            branches = branchesList.map((json) {
              log('Parsing branch: $json');
              return BranchModel.fromJson(json);
            }).toList();

            log('Successfully parsed ${branches.length} branches');
            for (var branch in branches) {
              log('Branch: ${branch.toString()}');
            }
          } else {
            log('❌ No branches array found in response');
          }
        } else {
          log('❌ Unexpected response format: ${data.runtimeType}');
        }

        return {
          'success': true,
          'message': 'Branch list fetched successfully',
          'data': branches,
          'count': branches.length,
        };
      } else {
        log('❌ BranchList API call failed with status: ${response.statusCode}');
        return {
          'success': false,
          'message': 'Failed to fetch branch list',
          'data': [],
          'count': 0,
        };
      }
    } on DioException catch (e) {
      log('❌ DioException in BranchList: ${e.toString()}');
      log('Response data: ${e.response?.data}');

      String errorMessage = 'Failed to fetch branch list';
      if (e.response?.data != null) {
        errorMessage = e.response!.data['message'] ?? errorMessage;
        log('Error response: ${e.response!.data}');
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage =
            'Connection timeout. Please check your internet connection.';
        log('Connection timeout error');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'Request timeout. Please try again.';
        log('Request timeout error');
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'No internet connection. Please check your network.';
        log('No internet connection error');
      }

      return {
        'success': false,
        'message': errorMessage,
        'data': [],
        'count': 0,
      };
    } catch (e) {
      log('❌ Unexpected error in BranchList: $e');
      return {
        'success': false,
        'message': 'An unexpected error occurred: ${e.toString()}',
        'data': [],
        'count': 0,
      };
    }
  }
}
