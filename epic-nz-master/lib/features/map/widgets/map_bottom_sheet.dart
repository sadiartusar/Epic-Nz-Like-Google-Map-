import 'package:epic_nz/features/map/map_controller/map_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../subscription/data/subscription_controller.dart';
import '../../subscription/widgets/premium_glass_dialog.dart';
import 'nearby_place_card.dart';

class MapBottomSheet extends StatefulWidget {
  const MapBottomSheet({super.key});

  @override
  State<MapBottomSheet> createState() => _MapBottomSheetState();
}

class _MapBottomSheetState extends State<MapBottomSheet> {
  final DraggableScrollableController _sheetController =
      DraggableScrollableController();

  bool _isSheetOpen = false;

  @override
  Widget build(BuildContext context) {
    final mapController = Get.find<MapController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DraggableScrollableSheet(
      controller: _sheetController,
      initialChildSize: 0.28,
      minChildSize: 0.28,
      maxChildSize: 0.75,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0E0E0E) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 30,
                offset: const Offset(0, -10),
              ),
            ],
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),

              GestureDetector(
                onTap: () {
                  _sheetController.animateTo(
                    _isSheetOpen ? 0.28 : 0.75,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );

                  setState(() => _isSheetOpen = !_isSheetOpen);
                },
                child: Container(
                  height: 4,
                  width: 44,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Near you',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        final sub = Get.find<SubscriptionController>();


                      //   if (sub.isPremium) {
                      //     mapController.goToContribute();
                      //   } else {
                      //     Get.dialog(const PremiumGlassDialog());
                      //   }
                      // },
                      // icon: const Icon(Icons.add, size: 18),
                      // label: const Text('Contribute'),

                        if (sub.isPremium) {
                          _showContributeOptions(context, mapController);
                        } else {
                          Get.dialog(const PremiumGlassDialog());
                        }
                      },
                      icon: const Icon(Icons.add, size: 20),
                      label: const Text('Contribute',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              Expanded(
                child: Obx(() {
                  if (mapController.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.green),
                    );
                  }

                  if (mapController.nearYouPlaces.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          "No spots found near you.\nUse map to explore other areas.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isDark ? Colors.white54 : Colors.grey,
                          ),
                        ),
                      ),
                    );
                  }

                  return GridView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.78,
                        ),
                    itemCount: mapController.nearYouPlaces.length,
                    itemBuilder: (context, index) {
                      final spot = mapController.nearYouPlaces[index];
                      final coords = spot['coordinates']['coordinates'];

                      final double lng = (coords[0] as num).toDouble();
                      final double lat = (coords[1] as num).toDouble();

                      final distance = mapController.calculateDistance(
                        lat,
                        lng,
                      );

                      final image =
                          (spot['imageUrl'] as List?)?.isNotEmpty == true
                          ? spot['imageUrl'][0]
                          : 'https://placehold.jp/150x150.png';

                      final List ratings = spot['ratings'] ?? [];
                      final double rating = ratings.isNotEmpty
                          ? ratings
                                    .map((e) => (e['rating'] ?? 0).toDouble())
                                    .reduce((a, b) => a + b) /
                                ratings.length
                          : 0.0;

                      return GestureDetector(
                        onTap: () => mapController.onMarkerTap(
                          Map<String, dynamic>.from(spot),
                        ),
                        child: NearbyPlaceCard(
                          tag: spot['category'] ?? "General",
                          name: spot['name'] ?? "Unnamed",
                          imageUrl: image,
                          distance: distance,
                          rating: rating.toStringAsFixed(1),
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showContributeOptions(BuildContext context, MapController mapController) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Contribute Spot",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            ListTile(
              leading: const Icon(Icons.my_location, color: AppColors.green),
              title: const Text("Current Location"),
              subtitle: const Text("Use your current GPS position"),
              onTap: () {
                Get.back();
                mapController.goToContributeCurrentLocation();
              },
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.map, color: Colors.blue),
              title: const Text("Select from Map"),
              subtitle: const Text("Use the pin you dropped on the map"),
              onTap: () {
                Get.back();
                if (mapController.selectedLocation.value == null) {
                  Get.snackbar("Tip", "Please tap on the map first to drop a pin.");
                } else {
                  mapController.goToContribute();
                }
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }
}
