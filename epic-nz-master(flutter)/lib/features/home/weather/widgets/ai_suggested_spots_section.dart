import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../map/map_controller/map_controller.dart';
import '../../widgets/section_header.dart';
import '../weather_controller/weather_controller.dart';
import 'recommendation_card.dart';

class AiSuggestedSpotsSection extends StatelessWidget {
  const AiSuggestedSpotsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final mapController = Get.find<MapController>();
    final weatherController = Get.find<WeatherController>();

    return Obx(() {
      if (weatherController.weather.value == null ||
          mapController.apiPlaces.isEmpty) {
        return const SizedBox();
      }

      final categories = weatherController.getSuggestedCategories();

      List<Map<String, dynamic>> suggestedSpots = mapController.apiPlaces
          .where((spot) => categories.contains(spot['category']))
          .cast<Map<String, dynamic>>()
          .take(4)
          .toList();

      if (suggestedSpots.isEmpty) {
        suggestedSpots = mapController.apiPlaces
            .take(4)
            .cast<Map<String, dynamic>>()
            .toList();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: "Best For Today"),
          const SizedBox(height: 12),

          ...suggestedSpots.map((spot) {
            return RecommendationCard(
              title: spot['name'],
              type: spot['category'],
              image: (spot['imageUrl'] as List?)?.isNotEmpty == true
                  ? spot['imageUrl'][0]
                  : 'https://placehold.jp/300x300.png',
              facilities: _buildFacilities(spot),
            );
          }).toList(),
        ],
      );
    });
  }

  List<IconData> _buildFacilities(Map<String, dynamic> spot) {
    final icons = <IconData>[];

    if (spot['animalClearance'] == "Pet Friendly") {
      icons.add(Icons.pets);
    }
    if (spot['networkQuality'] == "Good" ||
        spot['networkQuality'] == "Excellent") {
      icons.add(Icons.signal_cellular_alt);
    }
    if (spot['watererType'] == "Sunny") {
      icons.add(Icons.wb_sunny);
    }

    return icons;
  }
}
