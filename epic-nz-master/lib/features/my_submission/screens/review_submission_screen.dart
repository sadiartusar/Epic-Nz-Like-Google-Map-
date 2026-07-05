import 'dart:io';

import 'package:epic_nz/core/theme/app_colors.dart';
import 'package:epic_nz/features/my_submission/controller/submission_controller.dart';
import 'package:epic_nz/features/my_submission/widgets/app_secoundary_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;

class ReviewSubmissionScreen extends StatelessWidget {
  const ReviewSubmissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SubmissionController>();
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black12 : Colors.white,
        leading: IconButton(
          icon: CircleAvatar(
            backgroundColor: isDark ? Colors.white10 : Colors.black12,
            child: Icon(
              Icons.arrow_back,
              color: isDark ? Colors.white : Colors.black,
              size: 20,
            ),
          ),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Review Submission",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              final images = controller.selectedImages;
              if (images.isEmpty) return const SizedBox.shrink();

              if (images.length == 1) {
                return _ImageCard(imagePath: images.first);
              }

              return Row(
                children: [
                  Expanded(child: _ImageCard(imagePath: images[0])),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Stack(
                      children: [
                        _ImageCard(imagePath: images[1]),
                        if (images.length > 2)
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.black.withValues(alpha: 0.5),
                              ),
                              child: Center(
                                child: Text(
                                  "+${images.length - 2}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              );
            }),

            const SizedBox(height: 24),

            Obx(
              () => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: controller.selectedTags
                    .map(
                      (tag) => _StaticTag(
                        label: tag['label'],
                        color: tag['color'] ?? AppColors.green,
                      ),
                    )
                    .toList(),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              controller.nameController.text.isEmpty
                  ? "Untitled Location"
                  : controller.nameController.text,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              controller.descController.text.isEmpty
                  ? "No description provided."
                  : controller.descController.text,
              style: TextStyle(
                color: Colors.grey.shade400,
                height: 1.5,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 30),

            Row(
              children: [
                Expanded(
                  child: _InfoTile(
                    icon: Icons.cloud,
                    label: controller.weatherType.value.isEmpty
                        ? "Weather\nN/A"
                        : controller.weatherType.value,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _InfoTile(
                    icon: Icons.pets,
                    label: controller.animalClearance.value.isEmpty
                        ? "Animals\nN/A"
                        : controller.animalClearance.value,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _InfoTile(
                    icon: Icons.network_cell,
                    label: controller.networkQuality.value.isEmpty
                        ? "Network\nN/A"
                        : controller.networkQuality.value,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            _MapPreviewCard(isDark: isDark),

            const SizedBox(height: 32),
            Obx(() {
              final isLoading = controller.isLoading.value;

              return GestureDetector(
                onTap: isLoading ? null : controller.submitLocation,
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.green,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Center(
                    child: isLoading
                        ? SizedBox(
                            width: 28,
                            height: 28,
                            child: CircularProgressIndicator(
                              value: controller.submitProgress.value,
                              strokeWidth: 3,
                              backgroundColor: Colors.white24,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text(
                            "Submit For Approval",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                  ),
                ),
              );
            }),

            const SizedBox(height: 12),

            AppSecondaryButton(
              text: "Edit Submission",
              onPressed: () => Get.back(),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _MapPreviewCard extends StatelessWidget {
  final bool isDark;

  const _MapPreviewCard({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SubmissionController>();

    return Container(
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Obx(
          () => mapbox.MapWidget(
            key: const ValueKey("review-map-preview"),

            cameraOptions: mapbox.CameraOptions(
              center: mapbox.Point(
                coordinates: mapbox.Position(
                  controller.lng.value,
                  controller.lat.value,
                ),
              ),
              zoom: 15,
            ),

            onMapCreated: (map) async {
              final manager = await map.annotations
                  .createCircleAnnotationManager();

              await manager.create(
                mapbox.CircleAnnotationOptions(
                  geometry: mapbox.Point(
                    coordinates: mapbox.Position(
                      controller.lng.value,
                      controller.lat.value,
                    ),
                  ),
                  circleRadius: 8.0,
                  circleColor: Colors.red.value,
                  circleStrokeWidth: 2.0,
                  circleStrokeColor: Colors.white.value,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _StaticTag extends StatelessWidget {
  final String label;
  final Color color;

  const _StaticTag({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }
}

class _ImageCard extends StatelessWidget {
  final String imagePath;

  const _ImageCard({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey[900],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.file(File(imagePath), fit: BoxFit.cover),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoTile({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F1612) : Colors.grey[100],
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: const Color(0xFF1B3022),
            child: Icon(icon, color: AppColors.green, size: 14),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 11,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
