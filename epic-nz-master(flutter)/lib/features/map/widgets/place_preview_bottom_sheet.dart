import 'package:epic_nz/features/map/widgets/stacked_place_images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../map_controller/map_controller.dart';
import '../screens/place_ai_details_screen.dart';

class PlacePreviewBottomSheet extends StatelessWidget {
  const PlacePreviewBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MapController>();
    final place = controller.selectedPlace.value!;

    final images = List<String>.from(place['imageUrl'] ?? []);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          StackedPlaceImages(images: images),

          const SizedBox(height: 16),

          Text(
            place['name'] ?? 'Untitled Location',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            place['description'] ?? 'No description available.',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white70),
          ),

          const SizedBox(height: 18),

          ElevatedButton(
            onPressed: () {
              Get.to(() => PlaceAiDetailsScreen(place: place));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            child: const Text("AI Insights"),
          ),
        ],
      ),
    );
  }
}
