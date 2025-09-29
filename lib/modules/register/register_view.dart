import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../helpers/colors/app_colors.dart';
import '../../helpers/widgets/app_text_field.dart';
import '../../helpers/widgets/primary_button.dart';
import 'register_controller.dart'; // globals.dart

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<RegisterController>()) {
      Get.put(RegisterController());
    }

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            size: 18,
            color: AppColors.textPrimary,
          ),
          onPressed: () => Get.back(),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text(
          'Register',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(
              Icons.notifications_outlined,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: controller.formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              AppTextField(
                controller: controller.nameController,
                label: 'Name',
                hint: 'Enter your full name',
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: controller.whatsappController,
                label: 'Whatsapp Number',
                hint: 'Enter your Whatsapp number',
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: controller.addressController,
                label: 'Address',
                hint: 'Enter your full address',
              ),
              const SizedBox(height: 12),

              _DropdownField(
                label: 'Location',
                items: controller.locations,
                selected: controller.selectedLocation,
                onChanged: (v) => controller.selectedLocation.value = v,
              ),
              const SizedBox(height: 12),
              _DropdownField(
                label: 'Branch',
                items: controller.branches,
                selected: controller.selectedBranch,
                onChanged: (v) => controller.selectedBranch.value = v,
              ),
              const SizedBox(height: 12),

              const Text(
                'Treatments',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              _TreatmentCard(controller: controller),
              const SizedBox(height: 8),
              SizedBox(
                height: 44,
                child: ElevatedButton(
                  onPressed: () => _showAddTreatmentSheet(context, controller),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.lightGreen,
                    foregroundColor: AppColors.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('+ Add Treatments'),
                ),
              ),

              const SizedBox(height: 16),
              AppTextField(
                controller: controller.totalAmountController,
                label: 'Total Amount',
                hint: '',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: controller.discountAmountController,
                label: 'Discount Amount',
                hint: '',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),

              const Text(
                'Payment Option',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Obx(
                () => Row(
                  children: [
                    Radio<String>(
                      value: 'Cash',
                      groupValue: controller.paymentMethod.value,
                      onChanged: (v) => controller.paymentMethod.value = v!,
                    ),
                    const Text('Cash'),
                    const SizedBox(width: 12),
                    Radio<String>(
                      value: 'Card',
                      groupValue: controller.paymentMethod.value,
                      onChanged: (v) => controller.paymentMethod.value = v!,
                    ),
                    const Text('Card'),
                    const SizedBox(width: 12),
                    Radio<String>(
                      value: 'UPI',
                      groupValue: controller.paymentMethod.value,
                      onChanged: (v) => controller.paymentMethod.value = v!,
                    ),
                    const Text('UPI'),
                  ],
                ),
              ),

              const SizedBox(height: 12),
              AppTextField(
                controller: controller.advanceAmountController,
                label: 'Advance Amount',
                hint: '',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: controller.balanceAmountController,
                label: 'Balance Amount',
                hint: '',
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 12),
              const _DateField(),
              const SizedBox(height: 12),
              const _TimeField(),

              const SizedBox(height: 16),
              PrimaryButton(label: 'Save', onPressed: controller.submit),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  final String label;
  final List<String> items;
  final RxnString? selected;
  final ValueChanged<String?>? onChanged;
  const _DropdownField({
    required this.label,
    this.items = const [],
    this.selected,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    Widget buildDropdown(String? value) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            hint: Text(
              'Select the ${label.toLowerCase()}',
              style: TextStyle(color: AppColors.borderShade, fontSize: 12),
            ),
            isExpanded: true,
            items: items
                .map((e) => DropdownMenuItem<String>(value: e, child: Text(e)))
                .toList(),
            onChanged: onChanged,
            icon: const Icon(Icons.keyboard_arrow_down),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 6),
        selected == null
            ? buildDropdown(null)
            : Obx(() => buildDropdown(selected!.value)),
      ],
    );
  }
}

class _TreatmentCard extends StatelessWidget {
  final RegisterController controller;
  const _TreatmentCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: const [
                Text(
                  '1.  Couple Combo package L...',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Spacer(),
                Icon(Icons.close, color: AppColors.danger, size: 18),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _Chip(label: 'Male', value: controller.maleCount),
                const SizedBox(width: 8),
                _Chip(label: 'Female', value: controller.femaleCount),
                const SizedBox(width: 8),
                Icon(Icons.edit, color: AppColors.primary, size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final RxInt value;
  const _Chip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 6),
        Obx(
          () => Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.lightGrey,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.border),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            child: Text(
              '${value.value}',
              style: const TextStyle(fontSize: 12, color: AppColors.primary),
            ),
          ),
        ),
      ],
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Treatment Date', style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 6),
        TextField(
          readOnly: true,
          decoration: InputDecoration(
            hintText: '',
            suffixIcon: const Icon(
              Icons.calendar_month_outlined,
              color: AppColors.primary,
            ),
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TimeField extends StatelessWidget {
  const _TimeField();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Treatment Time', style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: TextField(
                readOnly: true,
                decoration: InputDecoration(
                  hintText: 'Hour',
                  hintStyle: TextStyle(
                    color: AppColors.borderShade,
                    fontSize: 12,
                  ),
                  filled: true,
                  suffixIcon: const Icon(Icons.keyboard_arrow_down),
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 1.2,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                readOnly: true,
                decoration: InputDecoration(
                  hintText: 'Minutes',
                  hintStyle: TextStyle(
                    color: AppColors.borderShade,
                    fontSize: 12,
                  ),
                  suffixIcon: const Icon(Icons.keyboard_arrow_down),
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 1.2,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

void _showAddTreatmentSheet(
  BuildContext context,
  RegisterController controller,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.background,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Choose Treatment',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              readOnly: true,
              decoration: InputDecoration(
                hintText: 'Choose prefered treatment',
                suffixIcon: const Icon(Icons.keyboard_arrow_down),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 1.2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Add Patients',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            _CounterRow(
              label: 'Male',
              onMinus: controller.decrementMale,
              onPlus: controller.incrementMale,
              value: controller.maleCount,
            ),
            const SizedBox(height: 12),
            _CounterRow(
              label: 'Female',
              onMinus: controller.decrementFemale,
              onPlus: controller.incrementFemale,
              value: controller.femaleCount,
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              label: 'Save',
              onPressed: () {
                Get.back();
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      );
    },
  );
}

class _CounterRow extends StatelessWidget {
  final String label;
  final VoidCallback onMinus;
  final VoidCallback onPlus;
  final RxInt value;
  const _CounterRow({
    required this.label,
    required this.onMinus,
    required this.onPlus,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: Text(label),
          ),
        ),
        const SizedBox(width: 12),
        _RoundIconButton(icon: Icons.remove, onTap: onMinus),
        const SizedBox(width: 12),
        Obx(
          () => Container(
            width: 44,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: Text('${value.value}'),
          ),
        ),
        const SizedBox(width: 12),
        _RoundIconButton(icon: Icons.add, onTap: onPlus),
      ],
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _RoundIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Ink(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.onPrimary),
      ),
    );
  }
}
