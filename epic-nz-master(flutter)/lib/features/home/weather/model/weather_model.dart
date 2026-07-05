import 'package:hive/hive.dart';

part 'weather_model.g.dart';

@HiveType(typeId: 1)
class WeatherModel {
  @HiveField(0)
  final String location;

  @HiveField(1)
  final String country;

  @HiveField(2)
  final double temperature;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final int humidity;

  @HiveField(5)
  final double windSpeed;

  @HiveField(6)
  final String icon;

  @HiveField(7)
  final DateTime sunrise;

  @HiveField(8)
  final DateTime sunset;

  @HiveField(9)
  final String sunriseLocal;

  @HiveField(10)
  final String sunsetLocal;

  WeatherModel({
    required this.location,
    required this.country,
    required this.temperature,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.icon,
    required this.sunrise,
    required this.sunset,
    required this.sunriseLocal,
    required this.sunsetLocal,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      location: json['location'] ?? "Unknown",
      country: json['country'] ?? "",
      temperature: (json['temperature'] ?? 0).toDouble(),
      description: json['description'] ?? "",
      humidity: json['humidity'] ?? 0,
      windSpeed: (json['windSpeed'] ?? 0).toDouble(),
      icon: json['icon'] ?? "01d",
      sunrise: DateTime.fromMillisecondsSinceEpoch(
        (json['sunrise'] ?? 0) * 1000,
        isUtc: true,
      ),
      sunset: DateTime.fromMillisecondsSinceEpoch(
        (json['sunset'] ?? 0) * 1000,
        isUtc: true,
      ),
      sunriseLocal: json['sunriseLocal'] ?? "--:--",
      sunsetLocal: json['sunsetLocal'] ?? "--:--",
    );
  }
}
