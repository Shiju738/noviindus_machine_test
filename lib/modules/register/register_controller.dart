import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../helpers/colors/app_colors.dart';
import '../../models/branch_model.dart';
import '../../models/treatment_model.dart';
import '../../services/branch_service.dart';
import '../../services/treatment_service.dart';
import '../../services/patient_update_service.dart';

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

  final RxInt maleCount = 1.obs;
  final RxInt femaleCount = 1.obs;

  final RxString paymentMethod = 'Cash'.obs;

  // API data
  final RxList<BranchModel> branches = <BranchModel>[].obs;
  final RxList<TreatmentModel> treatments = <TreatmentModel>[].obs;
  final RxBool isLoadingBranches = false.obs;
  final RxBool isLoadingTreatments = false.obs;

  // Screen loading state
  final RxBool isScreenLoading = true.obs;
  final RxBool isSubmitting = false.obs;

  // Validation error states
  final RxString nameError = ''.obs;
  final RxString phoneError = ''.obs;
  final RxString addressError = ''.obs;
  final RxString branchError = ''.obs;
  final RxString treatmentError = ''.obs;
  final RxString totalAmountError = ''.obs;
  final RxString discountAmountError = ''.obs;
  final RxString advanceAmountError = ''.obs;
  final RxString balanceAmountError = ''.obs;

  // Selected values
  final RxnString selectedBranch = RxnString();
  final RxnString selectedTreatment = RxnString();
  final RxnString selectedLocation = RxnString();

  // Selected treatments list
  final RxList<TreatmentModel> selectedTreatments = <TreatmentModel>[].obs;

  // Selected date for treatment
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  final Rx<TimeOfDay?> selectedTime = Rx<TimeOfDay?>(null);

  // Selected hour and minute
  final RxString selectedHour = ''.obs;
  final RxString selectedMinute = ''.obs;

  void incrementMale() => maleCount.value++;
  void decrementMale() {
    if (maleCount.value > 0) maleCount.value--;
  }

  void incrementFemale() => femaleCount.value++;
  void decrementFemale() {
    if (femaleCount.value > 0) femaleCount.value--;
  }

  @override
  void onInit() {
    super.onInit();
    log('RegisterController onInit called');
    initializeScreen();
  }

  // Manual initialization method that can be called from view
  void startInitialization() {
    log('Manual initialization triggered');
    if (isScreenLoading.value) {
      initializeScreen();
    }
  }

  // Initialize screen by fetching required APIs
  Future<void> initializeScreen() async {
    try {
      log('🚀 Starting register screen initialization...');
      isScreenLoading.value = true;
      log('Initializing register screen...');

      // Fetch branch list first
      log('📡 Fetching branch list...');
      await fetchBranchList();
      log('✅ Branch list fetch completed');

      // Then fetch treatment list
      await fetchTreatmentList();

      log('🎉 Register screen initialization completed');
    } catch (e) {
      log('❌ Error initializing register screen: $e');
    } finally {
      isScreenLoading.value = false;
      log('🏁 Screen loading set to false');
    }
  }

  // Fetch branch list from API
  Future<void> fetchBranchList() async {
    try {
      isLoadingBranches.value = true;
      branchError.value = '';

      log('Fetching branch list from register controller...');
      final result = await BranchService.getBranchList();

      if (result['success'] == true) {
        branches.value = List<BranchModel>.from(result['data']);
        log('Successfully fetched ${branches.length} branches');
        for (var branch in branches) {
          log('Branch: ${branch.name} (${branch.location})');
        }
      } else {
        branchError.value = result['message'] ?? 'Failed to fetch branches';
        log('Error fetching branches: ${branchError.value}');
      }
    } catch (e) {
      branchError.value = 'An unexpected error occurred: ${e.toString()}';
      log('Exception in fetchBranchList: $e');
    } finally {
      isLoadingBranches.value = false;
    }
  }

  // Fetch treatment list from API
  Future<void> fetchTreatmentList() async {
    try {
      isLoadingTreatments.value = true;
      treatmentError.value = '';

      log('Fetching treatment list...');
      final result = await TreatmentService.getTreatmentList();

      if (result['success'] == true) {
        treatments.value = List<TreatmentModel>.from(result['data']);
        log('Successfully fetched ${treatments.length} treatments');
        for (var treatment in treatments) {
          log(
            'Treatment: ${treatment.name} (${treatment.duration}) - ₹${treatment.price}',
          );
        }
      } else {
        treatmentError.value =
            result['message'] ?? 'Failed to fetch treatments';
        log('Error fetching treatments: ${treatmentError.value}');
      }
    } catch (e) {
      treatmentError.value = 'An unexpected error occurred: ${e.toString()}';
      log('Exception in fetchTreatmentList: $e');
    } finally {
      isLoadingTreatments.value = false;
    }
  }

  // Add selected treatment to the list
  void addSelectedTreatment() {
    if (selectedTreatment.value != null) {
      final treatmentName = selectedTreatment.value!;
      final treatment = treatments.firstWhere(
        (t) => t.name == treatmentName,
        orElse: () => TreatmentModel(
          id: 0,
          name: treatmentName,
          duration: '',
          price: 0.0,
          isActive: true,
          createdAt: '',
          updatedAt: '',
          branches: [],
        ),
      );

      // Check if treatment already exists
      if (!selectedTreatments.any((t) => t.name == treatmentName)) {
        selectedTreatments.add(treatment);
        log('Added treatment: ${treatment.name}');
      } else {
        log('Treatment already exists: ${treatment.name}');
      }

      // Clear selection
      selectedTreatment.value = null;
    }
  }

  // Remove treatment from the list
  void removeTreatment(int index) {
    if (index >= 0 && index < selectedTreatments.length) {
      final removedTreatment = selectedTreatments.removeAt(index);
      log('Removed treatment: ${removedTreatment.name}');
    }
  }

  // Clear all validation errors
  void clearValidationErrors() {
    nameError.value = '';
    phoneError.value = '';
    addressError.value = '';
    branchError.value = '';
    treatmentError.value = '';
    totalAmountError.value = '';
    discountAmountError.value = '';
    advanceAmountError.value = '';
    balanceAmountError.value = '';
  }

  // Clear individual field errors when user starts typing
  void clearNameError() => nameError.value = '';
  void clearPhoneError() => phoneError.value = '';
  void clearAddressError() => addressError.value = '';
  void clearTotalAmountError() => totalAmountError.value = '';
  void clearDiscountAmountError() => discountAmountError.value = '';
  void clearAdvanceAmountError() => advanceAmountError.value = '';
  void clearBalanceAmountError() => balanceAmountError.value = '';
  void clearTreatmentError() => treatmentError.value = '';

  // Generate hour and minute lists
  List<String> get hourList {
    return List.generate(24, (index) => index.toString().padLeft(2, '0'));
  }

  List<String> get minuteList {
    return List.generate(60, (index) => index.toString().padLeft(2, '0'));
  }

  // Date picker method
  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate.value) {
      selectedDate.value = picked;
      log('Selected date: ${selectedDate.value}');
    }
  }

  // Time picker method
  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime.value ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedTime.value) {
      selectedTime.value = picked;
      log('Selected time: ${selectedTime.value}');
    }
  }

  // Validation method
  bool validateForm() {
    clearValidationErrors();
    bool isValid = true;

    // Check required fields
    if (nameController.text.trim().isEmpty) {
      nameError.value = 'Name is required';
      isValid = false;
    }
    if (whatsappController.text.trim().isEmpty) {
      phoneError.value = 'WhatsApp number is required';
      isValid = false;
    }
    if (addressController.text.trim().isEmpty) {
      addressError.value = 'Address is required';
      isValid = false;
    }
    if (selectedBranch.value == null || selectedBranch.value!.isEmpty) {
      branchError.value = 'Branch selection is required';
      isValid = false;
    }
    if (selectedTreatments.isEmpty) {
      treatmentError.value = 'At least one treatment is required';
      isValid = false;
    }
    if (totalAmountController.text.trim().isEmpty) {
      totalAmountError.value = 'Total amount is required';
      isValid = false;
    }
    if (discountAmountController.text.trim().isEmpty) {
      discountAmountError.value = 'Discount amount is required';
      isValid = false;
    }
    if (advanceAmountController.text.trim().isEmpty) {
      advanceAmountError.value = 'Advance amount is required';
      isValid = false;
    }
    if (balanceAmountController.text.trim().isEmpty) {
      balanceAmountError.value = 'Balance amount is required';
      isValid = false;
    }

    if (!isValid) {
      log('Validation failed - errors shown on form fields');
    }

    return isValid;
  }

  Future<void> submit() async {
    if (!validateForm()) return;

    try {
      isSubmitting.value = true;
      log('All validations passed, submitting form...');
      log('Selected treatments: ${selectedTreatments.length}');
      for (var treatment in selectedTreatments) {
        log('Treatment: ${treatment.name} - ₹${treatment.price}');
      }

      // Prepare treatment IDs
      final treatmentIds = selectedTreatments
          .map((t) => t.id.toString())
          .join(',');
      log('Treatment IDs: $treatmentIds');

      // Get selected date and current time
      final selectedDateValue = selectedDate.value ?? DateTime.now();
      final now = DateTime.now();
      final dateAndTime =
          '${selectedDateValue.day.toString().padLeft(2, '0')}/${selectedDateValue.month.toString().padLeft(2, '0')}/${selectedDateValue.year}-${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'PM' : 'AM'}';

      // Get selected branch ID
      final selectedBranchName = selectedBranch.value!;
      final selectedBranchModel = branches.firstWhere(
        (b) => b.name == selectedBranchName,
        orElse: () => BranchModel(
          id: 0,
          name: selectedBranchName,
          location: '',
          phone: '',
          email: '',
          address: '',
          gst: '',
          isActive: true,
          patientsCount: 0,
        ),
      );

      log(
        'Selected branch: ${selectedBranchModel.name} (ID: ${selectedBranchModel.id})',
      );

      // Call PatientUpdate API
      final result = await PatientUpdateService.registerPatient(
        name: nameController.text.trim(),
        executive: 'Default Executive', // You can make this dynamic
        payment: paymentMethod.value,
        phone: whatsappController.text.trim(),
        address: addressController.text.trim(),
        totalAmount: double.tryParse(totalAmountController.text.trim()) ?? 0.0,
        discountAmount:
            double.tryParse(discountAmountController.text.trim()) ?? 0.0,
        advanceAmount:
            double.tryParse(advanceAmountController.text.trim()) ?? 0.0,
        balanceAmount:
            double.tryParse(balanceAmountController.text.trim()) ?? 0.0,
        dateAndTime: dateAndTime,
        branch: selectedBranchModel.id.toString(),
        maleTreatments: treatmentIds, // Same for male and female for now
        femaleTreatments: treatmentIds,
        treatments: treatmentIds,
      );

      if (result['success'] == true) {
        log('✅ Patient registered successfully');
        Get.snackbar(
          'Success',
          'Patient registered successfully!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );

        // TODO: Generate PDF
        // TODO: Navigate to success page or clear form
      } else {
        log('❌ Patient registration failed: ${result['message']}');
        Get.snackbar(
          'Registration Failed',
          result['message'] ?? 'Failed to register patient',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      log('❌ Error during patient registration: $e');
      Get.snackbar(
        'Error',
        'An error occurred while registering patient: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isSubmitting.value = false;
    }
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
