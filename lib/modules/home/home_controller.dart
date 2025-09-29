import 'dart:developer';

import 'package:app/models/patient_model.dart';
import 'package:app/services/patient_service.dart';
import 'package:get/get.dart';
import '../../services/auth_service.dart';

class HomeController extends GetxController {
  final RxInt selectedSortIndex = 0.obs;
  final RxList<PatientModel> bookings = <PatientModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final List<String> sortOptions = const ['Date', 'Name'];

  @override
  void onInit() {
    super.onInit();
    fetchBookingList();
  }

  void setSort(int index) {
    selectedSortIndex.value = index;
  }

  // Fetch booking list from API
  Future<void> fetchBookingList({bool isRefresh = false}) async {
    try {
      if (!isRefresh) {
        isLoading.value = true;
      }
      errorMessage.value = '';

      final result = await PatientService.getBookingList();

      if (result['success'] == true) {
        bookings.value = List<PatientModel>.from(result['data']);

        if (isRefresh) {
          log('Booking list refreshed successfully');
        }
      } else {
        errorMessage.value = result['message'] ?? 'Failed to fetch bookings';

        if (isRefresh) {
          log('Failed to refresh booking list');
        }
      }
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred: ${e.toString()}';

      if (isRefresh) {
        log('Failed to refresh booking list');
      }
    } finally {
      if (!isRefresh) {
        isLoading.value = false;
      }
    }
  }

  // Logout functionality
  Future<void> logout() async {
    try {
      await AuthService.logout();
      Get.offAllNamed('/login'); // Navigate to login screen
      log('Logged out successfully');
    } catch (e) {
      log('Logout failed: ${e.toString()}');
    }
  }
}
