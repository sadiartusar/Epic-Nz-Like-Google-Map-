import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../map/map_controller/map_controller.dart';
import '../screens/place_ai_details_screen.dart';
import '../widgets/stacked_place_images.dart';

class PlaceDetailsSheet extends StatelessWidget {
  const PlaceDetailsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final mapController = Get.find<MapController>();
    final place = mapController.selectedPlace.value!;

    final String tag = place['category'] ?? 'General';
    final String title = place['name'] ?? 'Unnamed Place';
    final String description = place['description'] ?? '';
    final List<String> images =
        (place['imageUrl'] as List?)?.cast<String>() ?? [];

    final gradient = _gradientByTag(tag);

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            height: 4,
            width: 44,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _circleIcon(icon: Icons.close, onTap: () => Get.back()),
                const Spacer(),
                _circleIcon(
                  icon: Icons.auto_awesome,
                  onTap: () {
                    Get.to(
                          () => PlaceAiDetailsScreen(place: place),
                      transition: Transition.fadeIn,
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      StackedPlaceImages(images: images),
                      Positioned(left: -50, top: 2, child: _tagChip(tag)),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Text(
                    title,
                    style: AppTextStyles.h1.copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 6),
                  _tagSpecificInfo(tag),

                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      description,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white70, height: 1.5),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  LinearGradient _gradientByTag(String tag) {
    if (tag.contains('Epic')) {
      return const LinearGradient(
        colors: [Color(0xFF2E1A47), Color(0xFF6A3FA0)],
      );
    } else if (tag.contains('Hike')) {
      return const LinearGradient(
        colors: [Color(0xFF0F3C4C), Color(0xFF3BA3D0)],
      );
    } else if (tag.contains('Camp') || tag.contains('Freedom')) {
      return const LinearGradient(
        colors: [Color(0xFF1F2A44), Color(0xFF5B6CFF)],
      );
    } else {
      return const LinearGradient(
        colors: [Color(0xFF0E3B2E), Color(0xFF3FAF7C)],
      );
    }
  }

  Widget _circleIcon({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 16,
        backgroundColor: Colors.white.withValues(alpha: 0.2),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }

  Widget _tagChip(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        tag,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _tagSpecificInfo(String tag) {
    const TextStyle tagStyle = TextStyle(
      color: Colors.white70,
      fontSize: 6,
    );

    if (tag.contains('Hike')) {
      return const Text(
        '🥾 Hiking Spot',
        style: tagStyle,
      );
    } else if (tag.contains('Camp')) {
      return const Text(
        '🏕 Campground',
        style: tagStyle,
      );
    } else if (tag.contains('Epic')) {
      return const Text(
        '✨ Epic Photo Spot',
        style: tagStyle,
      );
    } else {
      return const Text(
        '📍 Nearby Place',
        style: tagStyle,
      );
    }
  }
}