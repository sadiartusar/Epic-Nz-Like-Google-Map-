import 'package:epic_nz/features/home/weather/screen/weather_details_screen.dart';
import 'package:epic_nz/features/home/weather/weather_controller/weather_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../subscription/data/subscription_controller.dart';
import '../../subscription/widgets/premium_glass_dialog.dart';

class AiSuggestionCard extends StatelessWidget {
  const AiSuggestionCard({super.key});

  @override
  Widget build(BuildContext context) {
    final weatherController = Get.find<WeatherController>();
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final sub = Get.find<SubscriptionController>();

    return Obx(() {
      if (weatherController.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: Colors.green),
        );
      }

      final data = weatherController.weather.value;
      String temp = data != null
          ? "${data.temperature.toStringAsFixed(0)} °C"
          : "N/A";
      String desc = data != null
          ? data.description
          : "Based On The Weather, Check Out Thesespectacular Waterfalls Nearby.";

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E2A28) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.green.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.auto_awesome,
                      color: Colors.green,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'AI SUGGESTED',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.wb_cloudy_outlined,
                      color: Colors.lightBlueAccent,
                      size: 34,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      temp,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              "It's currently $desc in ${data?.location ?? ''}. Perfect time for recommendations!",
              style: TextStyle(color: isDark ? Colors.white70 : Colors.black54,
              fontSize: 16),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  if (sub.isPremium) {
                    Get.to(() => const WeatherDetailsScreen());
                  } else {
                    Get.dialog(const PremiumGlassDialog());
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'View Recommendations',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
