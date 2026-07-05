import 'dart:convert';

import 'package:epic_nz/core/base_url/api_constants.dart';
import 'package:epic_nz/core/service/storage_service.dart';
import 'package:epic_nz/features/home/home%20_controller/home_controller.dart';
import 'package:epic_nz/features/map/map_controller/map_controller.dart';
import 'package:epic_nz/features/save_location/model/location_model.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:shared_preferences/shared_preferences.dart';

class BookmarkController extends GetxController {
  final dio.Dio _dio = dio.Dio(dio.BaseOptions(baseUrl: ApiConstants.baseUrl));
  final HomeController homeController = Get.put(HomeController());

  var savedLocations = <LocationModel>[].obs;
  var isLoading = false.obs;

  static const _cacheKey = 'cached_saved_locations';

  @override
  void onInit() {
    super.onInit();

    _loadFromCache();

    fetchSavedLocations();
  }

  Future<void> _loadFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_cacheKey);

    if (raw == null) return;

    try {
      final List list = jsonDecode(raw);
      final cached = list.map((e) => LocationModel.fromJson(e)).toList();

      savedLocations.assignAll(cached);
    } catch (_) {}
  }

  Future<void> _saveToCache() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = savedLocations.map((e) => e.toJson()).toList();
    await prefs.setString(_cacheKey, jsonEncode(jsonList));
  }

  Future<void> fetchSavedLocations() async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;
      final token = await StorageService.getToken();
      if (token == null || token.isEmpty) return;

      final response = await _dio.get(
        'user/get_me',
        options: dio.Options(headers: ApiConstants.headers(token)),
      );

      if (response.statusCode != 200) return;

      final List savedItems =
          response.data['data']?['savedLocationDetails'] ?? [];

      final mapController = Get.isRegistered<MapController>()
          ? Get.find<MapController>()
          : null;

      final list = <LocationModel>[];

      for (final saved in savedItems) {
        final id = saved['_id'].toString();

        final match = mapController?.apiPlaces.firstWhereOrNull(
          (p) => p['_id'].toString() == id,
        );

        list.add(
          LocationModel(
            id: id,
            title: match?['name'] ?? "Saved Spot",
            location: match?['address'] ?? "New Zealand",
            image: (saved['imageUrl'] as List?)?.isNotEmpty == true
                ? saved['imageUrl'][0]
                : "",
            category: match?['category'] ?? "General",
            distance: "Saved",
            tag: "#Favorite",
            weatherOrRating: homeController.calculateAverageRating(
              (match?['ratings'] as List?) ?? [],
            ),
          ),
        );
      }

      savedLocations.assignAll(list);
      _saveToCache();
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleBookmark(LocationModel spot) async {
    final alreadySaved = isBookmarked(spot.id);

    if (alreadySaved) {
      savedLocations.removeWhere((e) => e.id == spot.id);
    } else {
      savedLocations.add(spot);
    }

    _saveToCache();

    try {
      final token = await StorageService.getToken();
      if (token == null) return;

      await _dio.post(
        'location/${spot.id}/${alreadySaved ? 'unsave' : 'save'}',
        options: dio.Options(headers: ApiConstants.headers(token)),
      );
    } catch (_) {
      fetchSavedLocations();
    }
  }

  bool isBookmarked(String id) => savedLocations.any((e) => e.id == id);
}
