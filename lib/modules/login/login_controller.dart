import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../../routes/app_pages.dart';

class LoginController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final RxBool isPasswordHidden = true.obs;
  late final Dio dioClient;

  @override
  void onInit() {
    super.onInit();
    dioClient = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Enter email';
    if (!value.contains('@')) return 'Invalid email';
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
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
      await Future<void>.delayed(const Duration(seconds: 1));
      // Example request (replace with real API):
      // final response = await dioClient.post('https://example.com/login', data: {'email': emailController.text, 'password': passwordController.text});
      // Handle response...
      Get.back();
      Get.snackbar('Success', 'Logged in');
      Get.offAllNamed(Routes.home);
    } catch (e) {
      Get.back();
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
