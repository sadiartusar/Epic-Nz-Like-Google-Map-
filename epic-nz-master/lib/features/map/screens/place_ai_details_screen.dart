import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../widgets/stacked_place_images.dart';

class PlaceAiDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> place;

  const PlaceAiDetailsScreen({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    final List<String> images = List<String>.from(place['imageUrl'] ?? []);

    final String tag = place['category'] ?? 'General';

    final coords = place['coordinates']['coordinates'];
    final double lat = coords[1];
    final double lng = coords[0];

    final gradient = _gradientByTag(tag);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(decoration: BoxDecoration(gradient: gradient)),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _circleIcon(Icons.arrow_back, () => Get.back()),
                      const Spacer(),
                      const Text(
                        'Powered by AI',
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                      const Spacer(flex: 2),
                    ],
                  ),

                  const SizedBox(height: 28),

                  SizedBox(
                    width: double.infinity,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        StackedPlaceImages(images: images),
                        Positioned(left: 40, top: 16, child: _tagChip(tag)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  Center(
                    child: Text(
                      place['name'] ?? '',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.place_outlined,
                          size: 16,
                          color: Colors.white70,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Near your location',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 6),

                  Center(child: _tagSpecificInfo(tag)),

                  const SizedBox(height: 22),

                  _sectionHeader(Icons.auto_awesome_outlined, 'AI Insights'),
                  const SizedBox(height: 6),
                  Text(
                    place['description'] ?? '',
                    style: const TextStyle(color: Colors.white70, height: 1.45),
                  ),

                  const SizedBox(height: 26),

                  _sectionHeader(Icons.wb_sunny_outlined, 'Conditions'),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      if ((place['watererType'] ?? '').isNotEmpty)
                        BlurredInfoChip(
                          icon: Icons.cloud_outlined,
                          label: place['watererType'],
                        ),
                      if ((place['animalClearance'] ?? '').isNotEmpty)
                        BlurredInfoChip(
                          icon: Icons.pets_outlined,
                          label: place['animalClearance'],
                        ),
                      if ((place['networkQuality'] ?? '').isNotEmpty)
                        BlurredInfoChip(
                          icon: Icons.network_cell_outlined,
                          label: place['networkQuality'],
                        ),
                    ],
                  ),

                  const SizedBox(height: 34),

                  ElevatedButton.icon(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: "$lat, $lng"));
                      Get.snackbar(
                        "Copied",
                        "Coordinates copied to clipboard",
                        backgroundColor: Colors.black87,
                        colorText: Colors.white,
                      );
                    },
                    icon: const Icon(Icons.copy),
                    label: const Text('Copy Coordinates'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: gradient.colors.last,
                      minimumSize: const Size(double.infinity, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
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
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
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

  Widget _circleIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 20,
        backgroundColor: Colors.white.withValues(alpha: 0.2),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }

  Widget _tagChip(String tag) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            tag,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.white),
        const SizedBox(width: 6),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _tagSpecificInfo(String tag) {
    if (tag.contains('Hike')) {
      return const Text(
        '🥾 Hiking Friendly',
        style: TextStyle(color: Colors.white70),
      );
    } else if (tag.contains('Camp') || tag.contains('Freedom')) {
      return const Text(
        '🏕 Camping Spot',
        style: TextStyle(color: Colors.white70),
      );
    } else if (tag.contains('Epic')) {
      return const Text(
        '✨ Epic Experience Expected',
        style: TextStyle(color: Colors.white70),
      );
    } else {
      return const SizedBox();
    }
  }
}

class BlurredInfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const BlurredInfoChip({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: Colors.white),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
