import 'package:flutter/material.dart';
import '../weather/model/weather_model.dart';

class DetailAiRecommendation extends StatelessWidget {
  final WeatherModel? weather;

  const DetailAiRecommendation({super.key, this.weather});

  @override
  Widget build(BuildContext context) {
    String aiText = weather != null
        ? "The weather is currently ${weather!.description} with ${weather!.temperature.toStringAsFixed(0)}°C. Based on this, it's a perfect time to explore the unique features of this spot!"
        : "Gathering AI recommendations based on the local weather of this spot...";

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.auto_awesome, color: Colors.green, size: 18),
              SizedBox(width: 8),
              Text(
                "Ai Recommendation",
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(aiText, style: const TextStyle(color: Colors.grey, height: 1.5)),
        ],
      ),
    );
  }
}
