import 'package:epic_nz/features/map/map_controller/map_controller.dart';
import 'package:epic_nz/features/save_location/model/location_model.dart';
import 'package:epic_nz/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/hike_vertical_vard.dart';

class CategorySeeAllScreen extends StatelessWidget {
  const CategorySeeAllScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MapController mapController = Get.find<MapController>();
    final String category = Get.arguments as String;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final List filteredList = category == "Nearby"
        ? mapController.nearYouPlaces
        : mapController.apiPlaces.where((spot) {
            if (category == "Camping") {
              return spot['category'] == "Campground" ||
                  spot['category'] == "Freedom Camping";
            }
            return spot['category'] == category;
          }).toList();

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
        title: Text(
          category,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),

      body: filteredList.isEmpty
          ? const Center(child: Text("No spots found"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                final spot = filteredList[index];
                final coords = spot['coordinates']['coordinates'];

                final LocationModel model = LocationModel(
                  id: spot['_id'].toString(),
                  title: spot['name'] ?? "Unknown Spot",
                  location: spot['address'] ?? "New Zealand",
                  image: (spot['imageUrl'] as List?)?.isNotEmpty == true
                      ? spot['imageUrl'][0]
                      : 'https://placehold.jp/600x400.png',
                  category: spot['category'],
                  distance: mapController.calculateDistance(
                    (coords[1] as num).toDouble(),
                    (coords[0] as num).toDouble(),
                  ),
                  tag: "#${spot['category']}",
                  weatherOrRating: "0.0",
                );

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: HikeVerticalCard(
                    spot: model,
                    lat: (coords[1] as num).toDouble(),
                    lng: (coords[0] as num).toDouble(),
                    onTap: () {
                      Get.toNamed(AppRoutes.spotDetail, arguments: spot);
                    },
                  ),
                );
              },
            ),
    );
  }
}
