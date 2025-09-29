import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController whatsappController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController totalAmountController = TextEditingController();
  final TextEditingController discountAmountController =
      TextEditingController();
  final TextEditingController advanceAmountController = TextEditingController();
  final TextEditingController balanceAmountController = TextEditingController();

  final RxInt maleCount = 2.obs;
  final RxInt femaleCount = 2.obs;

  final RxString paymentMethod = 'Cash'.obs;

  // Dummy dropdown data
  final List<String> locations = const ['Kochi', 'Trivandrum', 'Calicut'];
  final List<String> branches = const [
    'Main Branch',
    'City Center',
    'North Wing',
  ];
  final RxnString selectedLocation = RxnString();
  final RxnString selectedBranch = RxnString();

  void incrementMale() => maleCount.value++;
  void decrementMale() {
    if (maleCount.value > 0) maleCount.value--;
  }

  void incrementFemale() => femaleCount.value++;
  void decrementFemale() {
    if (femaleCount.value > 0) femaleCount.value--;
  }

  void submit() {
    if (!(formKey.currentState?.validate() ?? false)) return;
    log('Registration saved');
  }

  @override
  void onClose() {
    nameController.dispose();
    whatsappController.dispose();
    addressController.dispose();
    totalAmountController.dispose();
    discountAmountController.dispose();
    advanceAmountController.dispose();
    balanceAmountController.dispose();
    super.onClose();
  }
}
