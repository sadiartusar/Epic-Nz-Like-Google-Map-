import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';

import '../../../preferences/controller/preferences_controller.dart';
import '../model/weather_model.dart';
import 'package:epic_nz/core/base_url/api_constants.dart';

class WeatherController extends GetxController {
  final isLoading = true.obs;
  final isSpotLoading = false.obs;

  final weather = Rxn<WeatherModel>();
  final spotWeather = Rxn<WeatherModel>();

  final PreferencesController prefs = Get.find<PreferencesController>();

  late Box<WeatherModel> _weatherBox;

  @override
  void onInit() {
    super.onInit();
    _initializeWeather();
  }

  Future<void> _initializeWeather() async {
    _weatherBox = await Hive.openBox<WeatherModel>('weather_cache');

    if (_weatherBox.containsKey('current')) {
      weather.value = _weatherBox.get('current');
      isLoading(false);
    }

    Future.microtask(() {
      if (prefs.locationEnabled.value) {
        fetchWeather();
      }
    });
  }

  Future<void> _initCache() async {
    _weatherBox = await Hive.openBox<WeatherModel>('weather_cache');

    if (_weatherBox.containsKey('current')) {
      weather.value = _weatherBox.get('current');
      isLoading(false);
    }

    if (prefs.locationEnabled.value) {
      fetchWeather();
    }
  }

  Future<void> fetchWeather() async {
    if (!prefs.locationEnabled.value) {
      isLoading(false);
      return;
    }

    try {
      isLoading(true);

      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        isLoading(false);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        isLoading(false);
        return;
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        isLoading(false);
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 5),
      );

      String cityName = "Nearby";
      try {
        final placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          cityName =
              placemarks[0].subAdministrativeArea ??
              placemarks[0].locality ??
              "Unknown";
        }
      } catch (_) {}

      final prefsStore = await SharedPreferences.getInstance();
      final token = prefsStore.getString('token');

      final response = await http.get(
        Uri.parse(
          "${ApiConstants.baseUrl}weather"
          "?latitude=${position.latitude}&longitude=${position.longitude}",
        ),
        headers: {
          'Cookie': 'accessToken=$token',
          'ngrok-skip-browser-warning': 'true',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        final apiData = WeatherModel.fromJson(data);

        final freshWeather = WeatherModel(
          location: cityName,
          country: apiData.country,
          temperature: apiData.temperature,
          description: apiData.description,
          humidity: apiData.humidity,
          windSpeed: apiData.windSpeed,
          icon: apiData.icon,
          sunrise: apiData.sunrise,
          sunset: apiData.sunset,
          sunriseLocal: apiData.sunriseLocal,
          sunsetLocal: apiData.sunsetLocal,
        );

        weather.value = freshWeather;

        await _weatherBox.put('current', freshWeather);
      }
    } catch (e) {
      print("🌦 Weather error (cached fallback): $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchWeatherByLocation(double lat, double lng) async {
    if (!prefs.locationEnabled.value) return;

    final cacheKey = 'spot_${lat}_$lng';

    if (_weatherBox.containsKey(cacheKey)) {
      spotWeather.value = _weatherBox.get(cacheKey);
    }

    try {
      isSpotLoading(true);

      final prefsStore = await SharedPreferences.getInstance();
      final token = prefsStore.getString('token');

      final response = await http.get(
        Uri.parse(
          "${ApiConstants.baseUrl}weather"
          "?latitude=$lat&longitude=$lng",
        ),
        headers: {
          'Cookie': 'accessToken=$token',
          'ngrok-skip-browser-warning': 'true',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        final fresh = WeatherModel.fromJson(data);

        spotWeather.value = fresh;
        await _weatherBox.put(cacheKey, fresh);
      }
    } catch (e) {
      print("🌦 Spot weather error: $e");
    } finally {
      isSpotLoading(false);
    }
  }

  List<String> getSuggestedCategories() {
    final data = weather.value;
    if (data == null) return [];

    final temp = data.temperature;
    final humidity = data.humidity;
    final desc = data.description.toLowerCase();

    final List<String> categories = [];

    if (desc.contains("sun") && temp >= 18 && temp <= 32) {
      categories.add("Epic Photo Spot");
      categories.add("Hike");
    }

    if (desc.contains("cloud") && humidity < 75) {
      categories.add("Campground");
    }

    if (!desc.contains("rain") && humidity < 70 && temp >= 15) {
      categories.add("Freedom Camping");
    }

    return categories.toSet().toList();
  }

  List<Map<String, dynamic>> getSuggestedSpots(
    List<Map<String, dynamic>> allSpots,
  ) {
    final categories = getSuggestedCategories();

    List<Map<String, dynamic>> spots = allSpots
        .where((spot) => categories.contains(spot['category']))
        .cast<Map<String, dynamic>>()
        .toList();

    if (spots.isEmpty) {
      spots = allSpots.take(5).toList();
    }

    final seen = <String>{};
    spots = spots.where((s) => seen.add(s['_id'].toString())).toList();

    return spots.take(5).toList();
  }
}
