import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:epic_nz/features/map/map_controller/map_controller.dart';
import 'package:epic_nz/features/map/widgets/map_bottom_sheet.dart';
import 'package:epic_nz/features/map/widgets/map_fab_buttons.dart';
import 'package:epic_nz/features/map/widgets/map_filter_chips.dart';
import 'package:epic_nz/features/map/widgets/map_search_bar.dart';
import 'package:epic_nz/features/preferences/controller/preferences_controller.dart';

import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController mapController = Get.put(MapController());
  final PreferencesController prefs = Get.find<PreferencesController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (!prefs.locationEnabled.value) {
          return _LocationOffView(
            onEnable: () async {
              await prefs.enableLocation();

              if (prefs.locationEnabled.value) {
                mapController.fetchApprovedLocations();
              }
            },
          );
        }

        return Stack(
          children: [
            Obx(() {
              if (mapController.isLoading.value &&
                  mapController.apiPlaces.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.green),
                );
              }

              return mapbox.MapWidget(
                key: const ValueKey("mapbox-map"),
                onMapCreated: mapController.onMapCreated,
                onTapListener: mapController.handleTap,
              );
            }),

            const Positioned(
              top: 50,
              left: 16,
              right: 16,
              child: MapSearchBar(),
            ),

            const Positioned(
              top: 110,
              left: 16,
              right: 16,
              child: MapFilterChips(),
            ),

            const MapFabButtons(),
            const MapBottomSheet(),
          ],
        );
      }),
    );
  }

  @override
  void dispose() {
    mapController.clearRoute();
    super.dispose();
  }
}

class _LocationOffView extends StatelessWidget {
  final VoidCallback onEnable;

  const _LocationOffView({required this.onEnable});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_off, size: 80, color: Colors.grey),
            const SizedBox(height: 20),
            const Text(
              "Location is turned off",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              "Enable location access to discover nearby epic spots on the map.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: onEnable,
              icon: const Icon(Icons.location_on),
              label: const Text("Enable Location"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
