import 'dart:io';

import 'package:epic_nz/core/theme/app_colors.dart';
import 'package:epic_nz/features/my_submission/controller/submission_controller.dart';
import 'package:epic_nz/features/my_submission/screens/add_details_screen.dart';
import 'package:epic_nz/features/my_submission/widgets/app_primary_button.dart';
import 'package:epic_nz/features/my_submission/widgets/app_secoundary_button.dart';
import 'package:epic_nz/features/my_submission/widgets/dashed_painter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/widgets/error_snackbar.dart';

class NewLocationScreen extends StatelessWidget {
  const NewLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SubmissionController(), permanent: true);
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black12 : Colors.white,
        leading: IconButton(
          icon: CircleAvatar(
            backgroundColor: isDark ? const Color(0xFF1A1F1C) : Colors.black12,
            child: Icon(
              Icons.close,
              color: isDark ? Colors.white : Colors.black,
              size: 20,
            ),
          ),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "New Location",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text(
              "Share a Hidden Gem",
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Upload your photos to allow AI to automatically generate the relevant details. A maximum of 5 photos may be added.",
              style: TextStyle(color: AppColors.grey, fontSize: 16),
            ),
            const SizedBox(height: 30),
            CustomPaint(
              painter: DashedBorderPainter(
                color: AppColors.green.withValues(alpha: 0.5),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF0F1612)
                      : AppColors.greenLight.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.greenDarkHover,
                      radius: 32,
                      child: Icon(
                        Icons.camera_enhance,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 30),
                    AppPrimaryButton(
                      text: "Take Pictures",
                      icon: Icons.camera_alt,
                      onPressed: () => controller.takePhoto(),
                    ),
                    const SizedBox(height: 12),
                    AppSecondaryButton(
                      text: "Choose From Library",
                      icon: Icons.photo_library,
                      onPressed: () => controller.pickFromGallery(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "Picked Images",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Obx(() {
              if (controller.selectedImages.isEmpty) {
                return Container(
                  width: double.infinity,
                  height: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: isDark ? const Color(0xFF1A1F1C) : Colors.black12,
                  ),
                  child: const Center(child: Text("No Preview Available")),
                );
              }

              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: isDark ? const Color(0xFF1A1F1C) : Colors.black12,
                ),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.selectedImages.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.file(
                            File(controller.selectedImages[index]),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                        Positioned(
                          top: 6,
                          right: 6,
                          child: GestureDetector(
                            onTap: () =>
                                controller.selectedImages.removeAt(index),
                            child: CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.black54,
                              child: const Icon(
                                Icons.close,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );
            }),
            const SizedBox(height: 30),

            Obx(
              () => AppPrimaryButton(
                text: controller.isGenerating.value ? "Generating..." : "Next",
                onPressed: () async {
                  if (controller.isGenerating.value) return;

                  if (controller.selectedImages.isEmpty) {
                    Get.showSnackbar(
                      ErrorSnackbar(
                        message:
                            "Please upload at least one photo before proceeding.",
                      ),
                    );
                    return;
                  }

                  final success = await controller.generateCaptionFromAI();

                  if (success) {
                    Get.to(() => AddDetailsScreen());
                  }
                },
              ),
            ),
            // AppPrimaryButton(
            //   text: "Next",
            //   onPressed: () {
            //     Get.to(() => AddDetailsScreen());
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
