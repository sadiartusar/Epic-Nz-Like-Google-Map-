import 'dart:io';

import 'package:epic_nz/core/theme/app_colors.dart';
import 'package:epic_nz/features/my_submission/controller/submission_controller.dart';
import 'package:epic_nz/features/my_submission/screens/review_submission_screen.dart';
import 'package:epic_nz/features/my_submission/widgets/app_primary_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/widgets/error_snackbar.dart';

class AddDetailsScreen extends StatelessWidget {
  AddDetailsScreen({super.key});

  final SubmissionController controller = Get.find<SubmissionController>();

  final List<Map<String, dynamic>> availableTags = [
    {'label': 'Hike', 'icon': Icons.directions_run, 'color': null},
    {
      'label': 'Epic Photo Spot',
      'icon': Icons.auto_awesome,
      'color': AppColors.purple,
    },
    {'label': 'Campground', 'icon': Icons.terrain, 'color': null},
    {'label': 'Freedom Camping', 'icon': Icons.forest, 'color': null},
  ];

  final List<String> weatherOptions = [
    'Sunny',
    'Cloudy',
    'Rainy',
    'Windy',
    'Stormy',
    'Foggy',
  ];

  final List<String> animalOptions = [
    'Pet Friendly',
    'Service Animals Only',
    'Not Pet Friendly',
  ];

  final List<String> networkOptions = [
    'Excellent',
    'Good',
    'Fair',
    'Poor',
    'Bad',
  ];

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black12 : Colors.white,
        leading: IconButton(
          icon: CircleAvatar(
            backgroundColor: isDark ? Colors.white10 : Colors.black12,
            child: const Icon(Icons.arrow_back, size: 20),
          ),
          onPressed: Get.back,
        ),
        title: const Text(
          "Add Details",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              if (controller.selectedImages.isEmpty) {
                return Container(
                  height: 220,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: Colors.grey,
                  ),
                  child: const Center(child: Text("No images selected")),
                );
              }

              return Container(
                height: 220,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: Colors.black12,
                ),
                child: GridView.builder(
                  itemCount: controller.selectedImages.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (_, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.file(
                        File(controller.selectedImages[index]),
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              );
            }),

            const SizedBox(height: 24),

            const Text(
              "What kind of place is this?",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Obx(
              () => Wrap(
                spacing: 10,
                runSpacing: 10,
                children: availableTags.map((tag) {
                  final bool isSelected = controller.isTagSelected(
                    tag['label'],
                  );

                  return GestureDetector(
                    onTap: () => controller.toggleTag(tag),
                    child: _buildSelectableTag(
                      label: tag['label'],
                      icon: tag['icon'],
                      isSelected: isSelected,
                      activeColor: tag['color'] ?? AppColors.green,
                      isDark: isDark,
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "Name this spot",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: controller.nameController,
              decoration: _inputDecoration(isDark, "e.g. Roys Peak Lookout"),
            ),

            const SizedBox(height: 24),

            const Text(
              "Description",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: controller.descController,
              maxLines: 4,
              decoration: _inputDecoration(isDark, "Tell us about the view..."),
            ),

            const SizedBox(height: 30),

            _buildChoiceSelector(
              label: "Weather Conditions",
              options: weatherOptions,
              selectedValueRx: controller.weatherType,
              onSelect: controller.setWeather,
              isDark: isDark,
            ),

            const SizedBox(height: 30),

            _buildChoiceSelector(
              label: "Animal Clearance",
              options: animalOptions,
              selectedValueRx: controller.animalClearance,
              onSelect: controller.setAnimal,
              isDark: isDark,
            ),

            const SizedBox(height: 30),

            _buildChoiceSelector(
              label: "Network Quality",
              options: networkOptions,
              selectedValueRx: controller.networkQuality,
              onSelect: controller.setNetwork,
              isDark: isDark,
            ),

            const SizedBox(height: 40),

            AppPrimaryButton(
              text: "Review Submission",
              icon: Icons.arrow_forward,
              onPressed: _onReviewPressed,
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  void _onReviewPressed() {
    if (controller.nameController.text.trim().isEmpty) {
      Get.showSnackbar(
        ErrorSnackbar(message: "Please enter a title for this location."),
      );
      return;
    }

    if (controller.descController.text.trim().isEmpty) {
      Get.showSnackbar(ErrorSnackbar(message: "Please add a description."));
      return;
    }

    if (controller.weatherType.value.isEmpty ||
        controller.animalClearance.value.isEmpty ||
        controller.networkQuality.value.isEmpty) {
      Get.showSnackbar(
        ErrorSnackbar(
          message:
              "Please select weather, animal clearance and network quality.",
        ),
      );
      return;
    }

    Get.to(() => const ReviewSubmissionScreen());
  }

  InputDecoration _inputDecoration(bool isDark, String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: isDark ? const Color(0xFF131A16) : Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _buildSelectableTag({
    required String label,
    required IconData icon,
    required bool isSelected,
    required Color activeColor,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? activeColor : Colors.transparent,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: isSelected
              ? Colors.transparent
              : AppColors.green.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 18,
            color: isSelected
                ? Colors.white
                : (isDark ? Colors.white : Colors.black),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? Colors.white
                  : (isDark ? Colors.white : Colors.black),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChoiceSelector({
    required String label,
    required List<String> options,
    required RxString selectedValueRx,
    required void Function(String) onSelect,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Obx(
          () => Wrap(
            spacing: 10,
            runSpacing: 10,
            children: options.map((option) {
              final bool isSelected = selectedValueRx.value == option;
              return GestureDetector(
                onTap: () => onSelect(option),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.green : Colors.transparent,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: isSelected
                          ? Colors.transparent
                          : AppColors.green.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Text(
                    option,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : (isDark ? Colors.white : Colors.black),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
