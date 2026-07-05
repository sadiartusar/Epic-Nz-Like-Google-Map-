import 'package:epic_nz/core/service/storage_service.dart';
import 'package:epic_nz/features/home/home%20_controller/home_controller.dart';
import 'package:epic_nz/features/map/map_controller/map_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../spot_card_details_widget/detail_header.dart';
import '../spot_card_details_widget/Detail_action_buttons.dart';
import '../spot_card_details_widget/detail_facilities.dart';
import '../spot_card_details_widget/detail_state.dart';
import '../spot_card_details_widget/detail_about.dart';
import '../spot_card_details_widget/detail_reviews.dart';
import '../spot_card_details_widget/give_rating.dart';
import '../../home/weather/weather_controller/weather_controller.dart';

class SpotDetailScreen extends StatelessWidget {
  final VoidCallback onBack;

  const SpotDetailScreen({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final dynamic args = Get.arguments;

    late final Map<String, dynamic> initialSpot;
    late final String spotId;

    if (args is Map && args.containsKey('locationId')) {
      final map = Map<String, dynamic>.from(args);

      spotId = map['locationId'] as String;
      initialSpot = {};
    } else if (args is Map && args.containsKey('_id')) {
      final map = Map<String, dynamic>.from(args);

      initialSpot = map;
      spotId = map['_id'] as String;
    } else {
      throw Exception("Invalid arguments passed to SpotDetailScreen");
    }

    final weatherController = Get.find<WeatherController>();
    final mapController = Get.find<MapController>();
    final homeController = Get.find<HomeController>();

    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return FutureBuilder<String?>(
      future: StorageService.getUserId(),
      builder: (context, snapshot) {
        final String? myId = snapshot.data;

        return Scaffold(
          backgroundColor: isDark ? Colors.black : Colors.white,
          body: Obx(() {
            final spot = mapController.apiPlaces.firstWhere(
              (e) => e['_id'] == spotId,
              orElse: () => initialSpot,
            );

            if (spot.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            final coords = spot['coordinates']['coordinates'];
            final double lat = (coords[1] as num).toDouble();
            final double lng = (coords[0] as num).toDouble();

            WidgetsBinding.instance.addPostFrameCallback((_) {
              weatherController.fetchWeatherByLocation(lat, lng);
            });

            final spotWeather = weatherController.spotWeather.value;

            final creator = spot['userId'];
            final creatorId = creator is Map
                ? creator['_id']?.toString()
                : creator.toString();

            final bool isMyOwnSpot =
                myId != null && creatorId.toString() == myId;

            final ratingsList = spot['ratings'] ?? [];
            bool hasRated = false;

            if (myId != null) {
              hasRated = ratingsList.any((r) {
                final rUser = r['userId'];
                final rId = rUser is Map
                    ? rUser['_id']?.toString()
                    : rUser.toString();
                return rId == myId;
              });
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 120),
              child: Column(
                children: [
                  DetailHeader(
                    onBack: onBack,
                    imageUrls: spot['imageUrl'] ?? [],
                    name: spot['name'] ?? "Unknown Spot",
                    address: spot['address'] ?? "Resolving location...",
                    weather: spotWeather,
                  ),

                  Transform.translate(
                    offset: const Offset(0, -17),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(9, 5, 5, 12),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF121212) : Colors.white,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(35),
                          topRight: Radius.circular(35),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DetailActionButtons(
                            lat: lat,
                            lng: lng,
                            spotData: spot,
                          ),

                          const SizedBox(height: 24),

                          DetailFacilities(
                            watererType: spot['watererType'] ?? "N/A",
                            animalClearance: spot['animalClearance'] ?? "N/A",
                            networkQuality: spot['networkQuality'] ?? "N/A",
                          ),

                          const SizedBox(height: 24),

                          DetailStats(
                            distance: mapController.calculateDistance(lat, lng),
                            driveTime: mapController.getTravelDuration(
                              lat,
                              lng,
                              false,
                            ),
                            walkTime: mapController.getTravelDuration(
                              lat,
                              lng,
                              true,
                            ),
                            rating: homeController.calculateAverageRating(
                              ratingsList,
                            ),
                          ),

                          const SizedBox(height: 24),

                          DetailAbout(
                            name: spot['name'] ?? "",
                            description:
                                spot['description'] ?? "No description",
                            category: spot['category'] ?? "",
                          ),

                          const SizedBox(height: 24),
                          DetailReviews(ratings: ratingsList),

                          if (!isMyOwnSpot && !hasRated) ...[
                            const SizedBox(height: 35),
                            GiveRatingWidget(locationId: spotId),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        );
      },
    );
  }
}
