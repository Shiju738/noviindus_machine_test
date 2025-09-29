import 'package:app/modules/register/register_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../helpers/colors/app_colors.dart';
import '../../helpers/widgets/primary_button.dart';
import '../../helpers/widgets/booking_card_widget.dart';
import 'home_controller.dart';
import '../../routes/app_pages.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
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
        title: const Text('', style: TextStyle(color: AppColors.textPrimary)),
        actions: [
          const Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: Icon(Icons.notifications_none, color: AppColors.textPrimary),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) => controller.searchBookings(value),
                      decoration: InputDecoration(
                        hintText: 'Search by name or treatment',
                        prefixIcon: const Icon(
                          Icons.search,
                          color: AppColors.textSecondary,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: AppColors.borderShade,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: AppColors.borderShade,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 1.2,
                          ),
                        ),
                        fillColor: const Color.fromARGB(255, 255, 255, 255),
                        filled: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 45,
                    child: GestureDetector(
                      onTap: () {
                        controller.searchBookings(''); // Clear search
                      },
                      child: Container(
                        width: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: AppColors.primary,
                        ),
                        child: Center(
                          child: const Text(
                            'Clear',
                            style: TextStyle(color: AppColors.onPrimary),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Sort by :',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Obx(
                    () => Container(
                      height: 36,
                      width: 130,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: AppColors.surface,
                        border: Border.all(color: AppColors.border),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          value: controller.selectedSortIndex.value,
                          items: List.generate(
                            controller.sortOptions.length,
                            (index) => DropdownMenuItem<int>(
                              value: index,
                              child: Text(
                                controller.sortOptions[index],
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            if (value != null) controller.setSort(value);
                          },
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: AppColors.primary,
                            size: 20,
                          ),
                          isExpanded: true,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await controller.fetchBookingList(isRefresh: true);
                },
                color: AppColors.primary,
                backgroundColor: AppColors.surface,
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: AppColors.primary),
                          SizedBox(height: 16),
                          Text(
                            'Loading bookings...',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'This may take up to 2 minutes',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (controller.errorMessage.value.isNotEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red[300],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            controller.errorMessage.value,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => controller.fetchBookingList(),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (controller.filteredBookings.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.book_online_outlined,
                            size: 64,
                            color: AppColors.textSecondary,
                          ),
                          SizedBox(height: 16),
                          Text(
                            controller.searchQuery.value.isNotEmpty
                                ? 'No bookings match your search'
                                : 'No bookings found',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemBuilder: (context, index) {
                      final booking = controller.filteredBookings[index];
                      return BookingCardWidget(
                        booking: booking,
                        onTap: () {
                          // Handle booking card tap
                        },
                      );
                    },
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemCount: controller.filteredBookings.length,
                  );
                }),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: PrimaryButton(
          label: 'Register Now',
          onPressed: () {
            Get.toNamed(Routes.register);
            Get.find<RegisterController>().fetchBranchList();
            Get.find<RegisterController>().fetchTreatmentList();
          },
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}
