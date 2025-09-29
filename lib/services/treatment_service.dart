import 'dart:developer';
import 'package:dio/dio.dart';
import 'api_service.dart';
import '../models/treatment_model.dart';

class TreatmentService {
  // Get treatment list API call
  static Future<Map<String, dynamic>> getTreatmentList() async {
    try {
      log('Fetching treatment list...');
      log('API Base URL: ${ApiService.dio.options.baseUrl}');
      log('Full URL: ${ApiService.dio.options.baseUrl}TreatmentList');
      log('Headers: ${ApiService.dio.options.headers}');

      final response = await ApiService.dio.get(
        'TreatmentList',
        options: Options(
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 10),
        ),
      );

      log('Treatment list response status: ${response.statusCode}');
      log('Treatment list response data: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;
        List<TreatmentModel> treatments = [];

        log('Raw API response data type: ${data.runtimeType}');
        log('Raw API response data: $data');

        // Parse the actual API response structure
        if (data is Map<String, dynamic>) {
          if (data['status'] == true && data['treatments'] is List) {
            log('✅ Found treatments array in response');
            final treatmentsList = data['treatments'] as List;
            log('Number of treatments: ${treatmentsList.length}');

            treatments = treatmentsList.map((json) {
              log('Parsing treatment: $json');
              log(
                'Treatment price type: ${json['price'].runtimeType}, value: ${json['price']}',
              );
              try {
                final treatment = TreatmentModel.fromJson(json);
                log(
                  'Successfully parsed treatment: ${treatment.name} - ₹${treatment.price}',
                );
                return treatment;
              } catch (e) {
                log('Error parsing treatment ${json['name']}: $e');
                // Return a default treatment if parsing fails
                return TreatmentModel(
                  id: json['id'] ?? 0,
                  name: json['name'] ?? 'Unknown Treatment',
                  duration: json['duration'] ?? '',
                  price: 0.0,
                  isActive: json['is_active'] ?? false,
                  createdAt: json['created_at'] ?? '',
                  updatedAt: json['updated_at'] ?? '',
                  branches: json['branches'] ?? [],
                );
              }
            }).toList();

            log('Successfully parsed ${treatments.length} treatments');
            for (var treatment in treatments) {
              log('Treatment: ${treatment.toString()}');
            }
          } else {
            log('❌ No treatments array found in response');
          }
        } else {
          log('❌ Unexpected response format: ${data.runtimeType}');
        }

        log('Parsed ${treatments.length} treatments');

        return {
          'success': true,
          'message': 'Treatment list fetched successfully',
          'data': treatments,
          'count': treatments.length,
        };
      } else {
        log('Treatment list failed with status: ${response.statusCode}');
        return {
          'success': false,
          'message': 'Failed to fetch treatment list',
          'data': [],
          'count': 0,
        };
      }
    } on DioException catch (e) {
      String errorMessage = 'Failed to fetch treatment list';
      log('DioException in TreatmentList: ${e.toString()}');
      log('Response data: ${e.response?.data}');

      if (e.response?.data != null) {
        errorMessage =
            e.response!.data['message'] ??
            e.response!.data['error'] ??
            'Failed to fetch treatment list';
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage =
            'Connection timeout. Please check your internet connection.';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'Request timeout. Please try again.';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'No internet connection. Please check your network.';
      }

      return {
        'success': false,
        'message': errorMessage,
        'data': [],
        'count': 0,
      };
    } catch (e) {
      log('Unexpected error in TreatmentList: $e');
      return {
        'success': false,
        'message': 'An unexpected error occurred: ${e.toString()}',
        'data': [],
        'count': 0,
      };
    }
  }
}
