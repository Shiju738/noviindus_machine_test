import 'dart:developer';

import 'package:app/models/patient_model.dart';
import 'package:app/services/patient_service.dart';
import 'package:get/get.dart';
import '../../services/auth_service.dart';

class HomeController extends GetxController {
  final RxInt selectedSortIndex = 0.obs;
  final RxList<PatientModel> bookings = <PatientModel>[].obs;
  final RxList<PatientModel> filteredBookings = <PatientModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString searchQuery = ''.obs;

  final List<String> sortOptions = const ['Date', 'Name'];

  @override
  void onInit() {
    super.onInit();
    fetchBookingList();
  }

  void setSort(int index) {
    selectedSortIndex.value = index;
    applyFiltersAndSort();
  }

  // Search functionality
  void searchBookings(String query) {
    searchQuery.value = query;
    applyFiltersAndSort();
  }

  // Apply search filter and sorting
  void applyFiltersAndSort() {
    List<PatientModel> filtered = bookings.where((booking) {
      if (searchQuery.value.isEmpty) return true;

      final query = searchQuery.value.toLowerCase();
      return booking.name.toLowerCase().contains(query) ||
          booking.treatmentName.toLowerCase().contains(query) ||
          booking.treatments.toLowerCase().contains(query);
    }).toList();

    // Apply sorting
    if (selectedSortIndex.value == 0) {
      // Sort by Date (newest first)
      filtered.sort((a, b) {
        try {
          final dateA = DateTime.parse(a.createdAt);
          final dateB = DateTime.parse(b.createdAt);
          return dateB.compareTo(dateA);
        } catch (e) {
          return 0;
        }
      });
    } else if (selectedSortIndex.value == 1) {
      // Sort by Name (A-Z)
      filtered.sort((a, b) => a.name.compareTo(b.name));
    }

    filteredBookings.value = filtered;
    log('Filtered ${filtered.length} bookings from ${bookings.length} total');
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
        applyFiltersAndSort(); // Apply current filters and sorting

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
