import 'package:epic_nz/core/theme/app_colors.dart';
import 'package:epic_nz/features/home/home%20_controller/home_controller.dart';
import 'package:epic_nz/features/home/weather/weather_controller/weather_controller.dart';
import 'package:epic_nz/features/map/map_controller/map_controller.dart';
import 'package:epic_nz/features/save_location/model/location_model.dart';
import 'package:epic_nz/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../preferences/controller/preferences_controller.dart';
import '../widgets/ai_suggestion_card.dart';
import '../widgets/home_header.dart';
import '../widgets/nearby_spots_carousel.dart';
import '../widgets/section_header.dart';
import '../widgets/spot_card.dart';
import 'category_see_all_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onSpotTap;

  const HomeScreen({super.key, required this.onSpotTap});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherController weatherController = Get.find<WeatherController>();
  final MapController mapController = Get.find<MapController>();
  final HomeController homeController = Get.find<HomeController>();
  final preferencesController = Get.find<PreferencesController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _refreshAllData());
  }

  Future<void> _refreshAllData() async {
    await mapController.fetchApprovedLocations();
    await weatherController.fetchWeather();
  }

  Future<LocationModel> _mapToLocationModel(Map<String, dynamic> spot) async {
    final coords = spot['coordinates']['coordinates'];
    final double lat = (coords[1] as num).toDouble();
    final double lng = (coords[0] as num).toDouble();

    String address = spot['address'] ?? "Unknown Location";

    if (address == "Unknown Location") {
      address = await mapController.resolveAddressFromCoordinates(lat, lng);
    }

    return LocationModel(
      id: spot['_id'].toString(),
      title: spot['name'] ?? "Unknown Spot",
      location: address,
      image: (spot['imageUrl'] as List?)?.isNotEmpty == true
          ? spot['imageUrl'][0]
          : 'https://placehold.jp/600x400.png',
      category: spot['category'] ?? "Hike",
      distance: mapController.calculateDistance(lat, lng),
      tag: homeController.getTagFromCategory(spot['category']),
      weatherOrRating: homeController.calculateAverageRating(
        spot['ratings'] ?? [],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          backgroundColor: AppColors.greenLight,
          color: Colors.green,
          onRefresh: _refreshAllData,
          child: Obx(() {
            if (mapController.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.green),
              );
            }

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HomeHeader(),
                  const SizedBox(height: 20),

                  const AiSuggestionCard(),
                  const SizedBox(height: 28),

                  if (mapController.apiPlaces.isEmpty)
                    _emptyState(context)
                  else ...[
                    SectionHeader(
                      title: "Nearby Spots",
                      onSeeAll: preferencesController.locationEnabled.value
                          ? () {
                              Get.to(
                                () => const CategorySeeAllScreen(),
                                arguments: "Nearby",
                              );
                            }
                          : null,
                    ),
                    const SizedBox(height: 14),

                    if (!preferencesController.locationEnabled.value)
                      _locationOffCard(context)
                    else if (mapController.nearYouPlaces.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Center(
                          child: Text(
                            "No nearby spots found",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      )
                    else
                      const NearbySpotsCarousel(),

                    const SizedBox(height: 32),

                    if (preferencesController.isCategoryEnabled(
                      "Epic Photo Spot",
                    ))
                      _buildCategorySection(
                        title: "Epic Photo Spots",
                        category: "Epic Photo Spot",
                      ),

                    if (preferencesController.isCategoryEnabled("Hike"))
                      _buildCategorySection(title: "Hikes", category: "Hike"),

                    if (preferencesController.isCategoryEnabled("Campground"))
                      _buildCategorySection(
                        title: "Campgrounds",
                        category: "Campground",
                      ),

                    if (preferencesController.isCategoryEnabled(
                      "Freedom Camping",
                    ))
                      _buildCategorySection(
                        title: "Freedom Camping",
                        category: "Freedom Camping",
                      ),
                  ],
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildCategorySection({
    required String title,
    required String category,
  }) {
    final List filtered = mapController.apiPlaces
        .where((s) => s['category'] == category)
        .take(10)
        .toList();

    final isDark = Theme.of(Get.context!).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: title,
          onSeeAll: filtered.isNotEmpty
              ? () {
                  Get.to(
                    () => const CategorySeeAllScreen(),
                    arguments: category,
                  );
                }
              : null,
        ),
        const SizedBox(height: 14),

        if (filtered.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: isDark
                  ? Colors.white.withValues(alpha: 0.06)
                  : Colors.black.withValues(alpha: 0.04),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.12)
                    : Colors.black.withValues(alpha: 0.08),
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.explore_off,
                  size: 32,
                  color: isDark ? Colors.white54 : Colors.black45,
                ),
                const SizedBox(height: 10),
                Text(
                  "No locations available at the moment",
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Please check back later or explore other categories.",
                  style: TextStyle(
                    color: isDark ? Colors.white54 : Colors.black54,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        else
          SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final spot = filtered[index];

                return FutureBuilder<LocationModel>(
                  future: _mapToLocationModel(spot),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Padding(
                        padding: EdgeInsets.only(right: 16),
                        child: SizedBox(
                          width: 200,
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      );
                    }

                    final spotModel = snapshot.data!;

                    return Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: SizedBox(
                        width: 200,
                        child: SpotCard(
                          onTap: () {
                            Get.toNamed(AppRoutes.spotDetail, arguments: spot);
                          },
                          title: spotModel.title,
                          location: spotModel.location,
                          distance: spotModel.distance,
                          image: spotModel.image,
                          badge: spotModel.tag,
                          rating: spotModel.weatherOrRating,
                          isHike: category == "Hike",
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

        const SizedBox(height: 32),
      ],
    );
  }

  Widget _locationOffCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isDark
            ? Colors.white.withValues(alpha: 0.08)
            : Colors.black.withValues(alpha: 0.05),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.15)
              : Colors.black.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_off, color: Colors.orange),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "Turn on location to see nearby spots",
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.find<PreferencesController>().enableLocation();
            },
            child: Text("Enable", style: TextStyle(color: AppColors.greenDark)),
          ),
        ],
      ),
    );
  }

  Widget _emptyState(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(top: 80),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.hourglass_empty,
              size: 64,
              color: isDark ? Colors.white54 : Colors.black45,
            ),
            const SizedBox(height: 20),
            Text(
              "No spots available right now",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "We're working on adding amazing places for you.\nPlease check back soon.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white60 : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
