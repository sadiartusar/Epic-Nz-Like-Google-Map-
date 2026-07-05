import 'dart:io';

import 'package:epic_nz/core/theme/app_colors.dart';
import 'package:epic_nz/features/my_submission/controller/submission_controller.dart';
import 'package:epic_nz/features/my_submission/widgets/app_primary_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';

class PendingApprovalScreen extends StatelessWidget {
  const PendingApprovalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SubmissionController>();
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final String? previewImage = controller.selectedImages.isNotEmpty
        ? controller.selectedImages.first
        : null;

    final String title = controller.nameController.text.trim().isEmpty
        ? "New Location"
        : controller.nameController.text.trim();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black12 : Colors.white,
        leading: IconButton(
          icon: CircleAvatar(
            backgroundColor: isDark ? Colors.white10 : Colors.black12,
            child: const Icon(Icons.close, size: 20),
          ),
          onPressed: () {
            Get.delete<SubmissionController>(force: true);
            Get.offAllNamed(AppRoutes.main);
          },
        ),
        title: const Text(
          "Submission Received",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.green.withValues(alpha: 0.1),
                  border: Border.all(
                    color: AppColors.green.withValues(alpha: 0.2),
                    width: 10,
                  ),
                ),
                child: const Icon(
                  Icons.fact_check,
                  size: 60,
                  color: AppColors.green,
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                "Pending Approval",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 16),

              const Text(
                "Your discovery has been sent to our admin team.\n"
                "We review all spots to keep New Zealand\n"
                "beautiful and safe.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, height: 1.5, fontSize: 15),
              ),

              const SizedBox(height: 24),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.green.withValues(alpha: 0.1)
                      : AppColors.greenLight,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.green.withValues(alpha: 0.3),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.access_time, size: 16, color: AppColors.green),
                    SizedBox(width: 8),
                    Text(
                      "ET: 24–48 Hours",
                      style: TextStyle(
                        color: AppColors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  image: previewImage != null
                      ? DecorationImage(
                          image: FileImage(File(previewImage)),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                            Colors.black.withValues(alpha: 0.35),
                            BlendMode.darken,
                          ),
                        )
                      : null,
                  color: Colors.black12,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(
                            Icons.location_on,
                            color: AppColors.green,
                            size: 16,
                          ),
                          SizedBox(width: 4),
                          Text(
                            "Location Submitted",
                            style: TextStyle(
                              color: AppColors.green,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.green.withValues(alpha: 0.4),
                              ),
                            ),
                            child: const Text(
                              "Pending",
                              style: TextStyle(
                                color: AppColors.green,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 4),

                      const Text(
                        "Submitted just now",
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),

              AppPrimaryButton(
                text: "Return To Map",
                icon: Icons.map_outlined,
                onPressed: () {
                  Get.delete<SubmissionController>(force: true);
                  Get.offAllNamed(AppRoutes.main);
                },
              ),

              const SizedBox(height: 12),
              Text("Go to your profile to see all submission."),
            ],
          ),
        ),
      ),
    );
  }
}
