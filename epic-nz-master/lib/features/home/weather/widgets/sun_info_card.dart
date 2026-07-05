import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../weather_controller/weather_controller.dart';

class SunInfoCard extends StatelessWidget {
  const SunInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WeatherController>();
    final data = controller.weather.value;

    if (data == null) return const SizedBox();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _item(Icons.wb_twilight, data.sunsetLocal, "Sunset Today"),
          _item(Icons.wb_sunny_outlined, data.sunriseLocal, "Sunrise Tomorrow"),
        ],
      ),
    );
  }

  Widget _item(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.orange, size: 28),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
