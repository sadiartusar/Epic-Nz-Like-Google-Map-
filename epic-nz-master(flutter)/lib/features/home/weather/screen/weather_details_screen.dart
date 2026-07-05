import 'dart:ui';
import 'package:epic_nz/core/widgets/app_back_button.dart';
import 'package:epic_nz/features/home/weather/weather_controller/weather_controller.dart';
import 'package:epic_nz/features/home/weather/widgets/recommendation_card.dart';
import 'package:epic_nz/features/map/map_controller/map_controller.dart';
import 'package:epic_nz/features/preferences/controller/preferences_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';

class WeatherDetailsScreen extends StatelessWidget {
  const WeatherDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final weatherController = Get.find<WeatherController>();
    final mapController = Get.find<MapController>();
    final prefs = Get.find<PreferencesController>();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          _buildBackgroundImage(),
          _darkOverlay(),
          SafeArea(
            child: Obx(() {
              if (!prefs.locationEnabled.value) {
                return _LocationDisabledView(
                  onEnable: () async {
                    prefs.enableLocation();
                    await weatherController.fetchWeather();
                  },
                );
              }

              if (weatherController.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.greyLight),
                );
              }

              final data = weatherController.weather.value;
              if (data == null) {
                return const Center(
                  child: Text(
                    "Weather data unavailable",
                    style: TextStyle(color: Colors.white70),
                  ),
                );
              }

              final suggestedSpots = weatherController.getSuggestedSpots(
                mapController.apiPlaces.cast<Map<String, dynamic>>(),
              );

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _buildHeader(data.location),
                    const SizedBox(height: 25),
                    _buildMainWeatherCard(data),
                    const SizedBox(height: 18),
                    _buildSunCard(data),
                    const SizedBox(height: 32),
                    _buildSectionTitle('Best For You'),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: suggestedSpots.length,
                        itemBuilder: (context, index) {
                          final spot = suggestedSpots[index];
                          return RecommendationCard(
                            title: spot['name'],
                            type: spot['category'],
                            image:
                                (spot['imageUrl'] as List?)?.isNotEmpty == true
                                ? spot['imageUrl'][0]
                                : 'https://placehold.jp/300x300.png',
                            facilities: _mapFacilities(spot),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _LocationDisabledView({required VoidCallback onEnable}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_off, color: Colors.white70, size: 80),
            const SizedBox(height: 20),
            const Text(
              "Location Access is Off",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Turn on location to see local weather and recommendations tailored for you.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 28),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.green,
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: onEnable,
              child: const Text(
                "Enable Location",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundImage() {
    final index = DateTime.now().millisecondsSinceEpoch % 10 + 1;
    return Positioned.fill(
      child: Image.asset('assets/background/w$index.jpg', fit: BoxFit.cover),
    );
  }

  Widget _darkOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black.withValues(alpha: 0.55),
              Colors.black.withValues(alpha: 0.25),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String location) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const AppBackButton(),
        Row(
          children: [
            const Icon(Icons.location_on, color: Colors.greenAccent, size: 22),
            const SizedBox(width: 4),
            Text(
              location,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(width: 46),
      ],
    );
  }

  Widget _buildMainWeatherCard(data) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(35),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(35),
            border: Border.all(color: Colors.white12),
          ),
          child: Column(
            children: [
              Text(
                '${data.temperature.toStringAsFixed(0)}°',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 70,
                  fontWeight: FontWeight.w200,
                ),
              ),
              Text(
                data.description.toUpperCase(),
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 20),
              const Divider(color: Colors.white10),
              Row(
                children: [
                  _infoItem(Icons.opacity, '${data.humidity}%', 'Humidity'),
                  _vDivider(),
                  _infoItem(Icons.air, '${data.windSpeed} km/h', 'Wind'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSunCard(data) {
    final sunrise = DateFormat('hh:mm a').format(data.sunrise.toLocal());
    final sunset = DateFormat('hh:mm a').format(data.sunset.toLocal());

    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _sunItem(Icons.wb_sunny_outlined, sunrise, 'Sunrise'),
            _sunItem(Icons.nightlight_round, sunset, 'Sunset'),
          ],
        ),
      ),
    );
  }

  Widget _sunItem(IconData icon, String time, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.orangeAccent, size: 30),
        const SizedBox(height: 6),
        Text(
          time,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 16),
        ),
      ],
    );
  }

  Widget _infoItem(IconData icon, String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: Colors.white70),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.white38, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _vDivider() => Container(height: 30, width: 1, color: Colors.white10);

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  List<IconData> _mapFacilities(Map<String, dynamic> spot) {
    final icons = <IconData>[];
    if (spot['networkQuality'] == "Excellent") {
      icons.add(Icons.signal_cellular_alt);
    }
    if (spot['animalClearance'] == "Pet Friendly") {
      icons.add(Icons.pets);
    }
    if (spot['watererType'] == "Sunny") {
      icons.add(Icons.wb_sunny);
    }
    return icons;
  }
}
