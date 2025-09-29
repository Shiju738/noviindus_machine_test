import 'dart:developer';
import 'package:dio/dio.dart';
import 'api_service.dart';
import '../models/patient_model.dart';

class PatientService {
  // Get patient list API call
  static Future<Map<String, dynamic>> getPatientList() async {
    try {
      log('Fetching patient list...');
      final response = await ApiService.dio.get('PatientList');

      log('Patient list response status: ${response.statusCode}');
      log('Patient list response data: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;

        // Parse patient list from response
        List<PatientModel> patients = [];
        if (data is List) {
          patients = data.map((json) => PatientModel.fromJson(json)).toList();
        } else if (data['data'] is List) {
          patients = (data['data'] as List)
              .map((json) => PatientModel.fromJson(json))
              .toList();
        } else if (data['patients'] is List) {
          patients = (data['patients'] as List)
              .map((json) => PatientModel.fromJson(json))
              .toList();
        }

        return {
          'success': true,
          'message': 'Patient list fetched successfully',
          'data': patients,
          'count': patients.length,
        };
      } else {
        log('Patient list failed with status: ${response.statusCode}');
        return {
          'success': false,
          'message': 'Failed to fetch patient list',
          'data': [],
          'count': 0,
        };
      }
    } on DioException catch (e) {
      String errorMessage = 'Failed to fetch patient list';
      log('DioException in PatientList: ${e.toString()}');
      log('Response data: ${e.response?.data}');

      if (e.response?.data != null) {
        errorMessage =
            e.response!.data['message'] ??
            e.response!.data['error'] ??
            'Failed to fetch patient list';
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
      log('Unexpected error in PatientList: $e');
      return {
        'success': false,
        'message': 'An unexpected error occurred: ${e.toString()}',
        'data': [],
        'count': 0,
      };
    }
  }
}
