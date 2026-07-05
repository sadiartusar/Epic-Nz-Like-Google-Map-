import 'package:cached_network_image/cached_network_image.dart';
import 'package:epic_nz/features/home/home%20_controller/nearby_adventure_controller.dart';
import 'package:epic_nz/features/map/map_controller/map_controller.dart';
import 'package:epic_nz/features/save_location/model/location_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

class NearbyAdventure extends StatelessWidget {
  final List<LocationModel> nearbySpots;
  final String currentSpotId;

  const NearbyAdventure({
    super.key,
    required this.nearbySpots,
    required this.currentSpotId,
  });

  @override
  Widget build(BuildContext context) {
    if (nearbySpots.isEmpty) return const SizedBox();
    final controller = Get.put(
      NearbyAdventureController(),
      tag: UniqueKey().toString(),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Nearby Adventure",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 180,

          child: Listener(
            onPointerDown: (_) => controller.pauseScroll(),
            onPointerUp: (_) => controller.resumeScroll(),
            child: ListView.builder(
              controller: controller.scrollController,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: nearbySpots.length,
              itemBuilder: (context, index) {
                final spot = nearbySpots[index];

                return GestureDetector(
                  onTap: () {
                    final mapController = Get.find<MapController>();
                    final fullData = mapController.apiPlaces.firstWhere(
                      (p) => p['_id'] == spot.id,
                    );

                    Get.toNamed(
                      AppRoutes.spotDetail,
                      arguments: fullData,
                      preventDuplicates: false,
                    );
                  },
                  child: Container(
                    width: 150,
                    margin: const EdgeInsets.only(right: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(spot.image),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.8),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 12,
                          left: 12,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                spot.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                spot.distance,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
