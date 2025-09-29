import 'dart:developer';
import 'package:dio/dio.dart';
import 'api_service.dart';

class PatientUpdateService {
  // Register new patient API call
  static Future<Map<String, dynamic>> registerPatient({
    required String name,
    required String executive,
    required String payment,
    required String phone,
    required String address,
    required double totalAmount,
    required double discountAmount,
    required double advanceAmount,
    required double balanceAmount,
    required String dateAndTime,
    required String branch,
    required String maleTreatments,
    required String femaleTreatments,
    required String treatments,
  }) async {
    try {
      log('Registering new patient...');
      log('API Base URL: ${ApiService.dio.options.baseUrl}');
      log('Full URL: ${ApiService.dio.options.baseUrl}PatientUpdate');
      log('Headers: ${ApiService.dio.options.headers}');

      final formData = FormData.fromMap({
        'name': name,
        'excecutive': executive,
        'payment': payment,
        'phone': phone,
        'address': address,
        'total_amount': totalAmount.toInt(), // Convert to integer
        'discount_amount': discountAmount.toInt(), // Convert to integer
        'advance_amount': advanceAmount.toInt(), // Convert to integer
        'balance_amount': balanceAmount.toInt(), // Convert to integer
        'date_nd_time': dateAndTime,
        'id': '', // Pass empty string as specified
        'male': maleTreatments,
        'female': femaleTreatments,
        'branch': branch,
        'treatments': treatments,
      });

      log(
        'Amount values - Total: ${totalAmount.toInt()}, Discount: ${discountAmount.toInt()}, Advance: ${advanceAmount.toInt()}, Balance: ${balanceAmount.toInt()}',
      );
      log('Request form data: $formData');
      log('Form data fields: ${formData.fields}');
      log('Form data files: ${formData.files}');

      final response = await ApiService.dio.post(
        'PatientUpdate',
        data: formData,
        options: Options(
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 10),
        ),
      );

      log('Patient registration response status: ${response.statusCode}');
      log('Patient registration response data: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is Map<String, dynamic>) {
          if (data['status'] == true || data['success'] == true) {
            log('✅ Patient registered successfully');
            return {
              'success': true,
              'message': data['message'] ?? 'Patient registered successfully',
              'data': data,
            };
          } else {
            log('❌ Patient registration failed');
            return {
              'success': false,
              'message': data['message'] ?? 'Failed to register patient',
              'data': data,
            };
          }
        }
      }

      log('❌ Patient registration failed with status: ${response.statusCode}');
      return {
        'success': false,
        'message': 'Failed to register patient',
        'data': null,
      };
    } on DioException catch (e) {
      log('❌ DioException in PatientUpdate: ${e.toString()}');
      log('Response data: ${e.response?.data}');

      String errorMessage = 'Failed to register patient';
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

      return {'success': false, 'message': errorMessage, 'data': null};
    } catch (e) {
      log('❌ Unexpected error in PatientUpdate: $e');
      return {
        'success': false,
        'message': 'An unexpected error occurred: ${e.toString()}',
        'data': null,
      };
    }
  }
}
