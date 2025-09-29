import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/auth_service.dart';

class HomeController extends GetxController {
  final RxInt selectedSortIndex = 0.obs;

  final List<String> sortOptions = const ['Date', 'Name'];

  void setSort(int index) {
    selectedSortIndex.value = index;
  }

  // Logout functionality
  Future<void> logout() async {
    try {
      await AuthService.logout();
      Get.offAllNamed('/login'); // Navigate to login screen
      Get.snackbar(
        'Success',
        'Logged out successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Logout failed: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
