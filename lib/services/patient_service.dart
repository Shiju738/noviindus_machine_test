import 'dart:developer';
import 'package:app/models/patient_model.dart';
import 'package:dio/dio.dart';
import 'api_service.dart';

class PatientService {
  // Get booking list API call
  static Future<Map<String, dynamic>> getBookingList() async {
    try {
      log('Fetching booking list from PatientList endpoint...');
      log('API Base URL: ${ApiService.dio.options.baseUrl}');
      log('Full URL: ${ApiService.dio.options.baseUrl}PatientList');
      log('Headers: ${ApiService.dio.options.headers}');

      // Create a custom request with extended timeout for PatientList
      // Note: Using PatientList as BookingList endpoint doesn't exist
      final response = await ApiService.dio.get(
        'PatientList',
        options: Options(
          receiveTimeout: const Duration(seconds: 120), // 2 minutes
          sendTimeout: const Duration(seconds: 30),
        ),
      );

      log('Booking list response status: ${response.statusCode}');
      log('Booking list response data: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;

        // Parse patient list and convert to booking format
        List<PatientModel> bookings = [];
        List<dynamic> patientData = [];

        // Check for different response structures
        if (data is List) {
          patientData = data;
        } else if (data['data'] is List) {
          patientData = data['data'];
        } else if (data['patients'] is List) {
          patientData = data['patients'];
        } else if (data['patient'] is List) {
          // This is the actual structure from your API
          patientData = data['patient'];
        }

        log('Found ${patientData.length} patients in response');
        if (patientData.isNotEmpty) {
          log('First patient data structure: ${patientData.first}');
        }

        // Convert patient data to booking format
        for (var patientJson in patientData) {
          try {
            // Extract treatment information from patientdetails_set
            String treatmentName = '';
            String treatments = '';
            if (patientJson['patientdetails_set'] != null &&
                patientJson['patientdetails_set'] is List &&
                (patientJson['patientdetails_set'] as List).isNotEmpty) {
              var firstTreatment =
                  (patientJson['patientdetails_set'] as List).first;
              treatmentName = firstTreatment['treatment_name'] ?? '';
              treatments = firstTreatment['treatment_name'] ?? '';
            }

            // Extract branch information
            String branchName = '';
            if (patientJson['branch'] != null) {
              branchName = patientJson['branch']['name'] ?? '';
            }

            // Create a booking from patient data
            final bookingJson = {
              'name': patientJson['name'] ?? '',
              'executive':
                  patientJson['user'] ?? '', // Using 'user' field as executive
              'payment': patientJson['payment'] ?? 'pending',
              'phone': patientJson['phone'] ?? '',
              'address': patientJson['address'] ?? '',
              'total_amount': (patientJson['total_amount'] ?? 0.0).toDouble(),
              'discount_amount': (patientJson['discount_amount'] ?? 0.0)
                  .toDouble(),
              'advance_amount': (patientJson['advance_amount'] ?? 0.0)
                  .toDouble(),
              'balance_amount': (patientJson['balance_amount'] ?? 0.0)
                  .toDouble(),
              'date_nd_time':
                  patientJson['date_nd_time'] ??
                  patientJson['created_at'] ??
                  '',
              'id': patientJson['id']?.toString() ?? '',
              'male':
                  patientJson['patientdetails_set'] != null &&
                      patientJson['patientdetails_set'] is List &&
                      (patientJson['patientdetails_set'] as List).isNotEmpty
                  ? (patientJson['patientdetails_set'] as List).first['male']
                            ?.toString() ??
                        '0'
                  : '0',
              'female':
                  patientJson['patientdetails_set'] != null &&
                      patientJson['patientdetails_set'] is List &&
                      (patientJson['patientdetails_set'] as List).isNotEmpty
                  ? (patientJson['patientdetails_set'] as List).first['female']
                            ?.toString() ??
                        '0'
                  : '0',
              'branch': branchName,
              'treatments': treatments,
              'treatment_name': treatmentName,
              'created_at': patientJson['created_at'] ?? '',
            };

            bookings.add(PatientModel.fromJson(bookingJson));
          } catch (e) {
            log('Error converting patient to booking: $e');
            log('Patient data: $patientJson');
          }
        }

        return {
          'success': true,
          'message': 'Booking list fetched successfully',
          'data': bookings,
          'count': bookings.length,
        };
      } else {
        log('Booking list failed with status: ${response.statusCode}');
        return {
          'success': false,
          'message': 'Failed to fetch booking list',
          'data': [],
          'count': 0,
        };
      }
    } on DioException catch (e) {
      String errorMessage = 'Failed to fetch booking list';
      log('DioException in PatientList (used for bookings): ${e.toString()}');
      log('Response data: ${e.response?.data}');

      if (e.response?.data != null) {
        errorMessage =
            e.response!.data['message'] ??
            e.response!.data['error'] ??
            'Failed to fetch booking list';
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage =
            'Connection timeout. Please check your internet connection.';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage =
            'Server is taking too long to respond. This may be due to a large dataset. Please try again or contact support if the issue persists.';
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
      log('Unexpected error in PatientList (used for bookings): $e');
      return {
        'success': false,
        'message': 'An unexpected error occurred: ${e.toString()}',
        'data': [],
        'count': 0,
      };
    }
  }
}
