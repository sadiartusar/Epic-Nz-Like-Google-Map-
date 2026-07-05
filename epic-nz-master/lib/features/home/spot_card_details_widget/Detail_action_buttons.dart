import 'package:epic_nz/features/home/home%20_controller/home_controller.dart';
import 'package:epic_nz/features/map/map_controller/map_controller.dart';
import 'package:epic_nz/features/save_location/controller/bookmark_controller.dart';
import 'package:epic_nz/features/save_location/model/location_model.dart';
import 'package:flutter/material.dart';
import 'package:epic_nz/core/theme/app_colors.dart';
import 'package:get/get.dart';

import '../screens/main_controller.dart';

class DetailActionButtons extends StatelessWidget {
  final double lat;
  final double lng;
  final Map<String, dynamic> spotData;

  const DetailActionButtons({
    super.key,
    required this.lat,
    required this.lng,
    required this.spotData,
  });

  @override
  Widget build(BuildContext context) {
    final mapController = Get.find<MapController>();
    final bookmarkController = Get.find<BookmarkController>();
    final homeController = Get.find<HomeController>();

    final String spotId = spotData['_id'].toString();

    return Row(
      children: [
        Expanded(
          child: _ActionButton(
            icon: Icons.near_me,
            label: 'Navigate',
            onTap: () async {
              final mapController = Get.find<MapController>();
              final mainController = Get.find<MainController>();

              Get.back();

              mainController.goToMap();

              await Future.delayed(const Duration(milliseconds: 400));

              mapController.drawRouteTo(lat, lng);
            },
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Obx(() {
            final bool isSaved = bookmarkController.isBookmarked(spotId);

            return _ActionButton(
              icon: isSaved ? Icons.bookmark : Icons.bookmark_outline,
              label: isSaved ? 'Saved' : 'Save',
              onTap: () {
                final model = LocationModel(
                  id: spotId,
                  title: spotData['name'] ?? "Unknown",
                  location: spotData['address'] ?? "New Zealand",
                  image: (spotData['imageUrl'] as List).isNotEmpty
                      ? spotData['imageUrl'][0]
                      : "",
                  category: spotData['category'] ?? "General",
                  distance: mapController.calculateDistance(lat, lng),
                  tag: homeController.getTagFromCategory(spotData['category']),
                  weatherOrRating: homeController.calculateAverageRating(
                    spotData['ratings'],
                  ),
                );

                bookmarkController.toggleBookmark(model);
              },
            );
          }),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.green.withValues(alpha: 0.9),
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
