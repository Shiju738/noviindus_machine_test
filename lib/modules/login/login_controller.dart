import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/auth_service.dart';

class LoginController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final RxBool isPasswordHidden = true.obs;
  final RxBool isLoading = false.obs;

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) return 'Enter username';
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.length < 6) return 'Min 6 chars';
    return null;
  }

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  Future<void> submit() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    Get.focusScope?.unfocus();

    isLoading.value = true;

    try {
      final result = await AuthService.login(
        username: usernameController.text.trim(),
        password: passwordController.text,
      );

      if (result['success']) {
        Get.snackbar(
          'Success',
          result['message'] ?? 'Login successful',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        // Navigate to home page which will automatically fetch patient list
        Get.offAllNamed('/home');
      } else {
        Get.snackbar(
          'Error',
          result['message'] ?? 'Login failed',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      log('Error: $e');
      Get.snackbar(
        'Error',
        'An unexpected error occurred: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
