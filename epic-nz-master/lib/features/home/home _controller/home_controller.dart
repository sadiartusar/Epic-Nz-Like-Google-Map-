import 'package:dio/dio.dart' as dio;
import 'package:epic_nz/core/base_url/api_constants.dart';
import 'package:epic_nz/core/service/storage_service.dart';
import 'package:epic_nz/features/map/map_controller/map_controller.dart';
import 'package:epic_nz/features/save_location/model/location_model.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class HomeController extends GetxController {
  final dio.Dio _dio = dio.Dio(dio.BaseOptions(baseUrl: ApiConstants.baseUrl));

  final MapController mapController = Get.find<MapController>();

  final allLocations = <LocationModel>[].obs;
  final isLoading = false.obs;

  late Box<LocationModel> _homeBox;

  @override
  void onInit() {
    super.onInit();
    _initCache();
  }

  Future<void> _initCache() async {
    _homeBox = await Hive.openBox<LocationModel>('home_locations');

    if (_homeBox.isNotEmpty) {
      allLocations.assignAll(_homeBox.values.toList());
    }

    fetchLocations();
  }

  Future<void> fetchLocations() async {
    try {
      isLoading.value = true;

      final token = await StorageService.getToken();
      if (token == null || token.isEmpty) {
        return;
      }

      final response = await _dio.get(
        'location/all',
        options: dio.Options(
          headers: {
            'Cookie': 'accessToken=$token',
            'ngrok-skip-browser-warning': 'true',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List result = response.data['data']['result'];

        final List<LocationModel> freshList = result
            .where((loc) => loc['status'] == 'APPROVED')
            .map<LocationModel>((json) {
              final coords = json['coordinates']['coordinates'];
              final double lat = (coords[1] as num).toDouble();
              final double lng = (coords[0] as num).toDouble();

              return LocationModel(
                id: json['_id'].toString(),
                title: json['name'] ?? "Unknown Spot",
                location: json['address'] ?? "New Zealand",
                image: (json['imageUrl'] as List).isNotEmpty
                    ? json['imageUrl'][0]
                    : 'assets/images/placeholder.jpg',
                category: json['category'] ?? "Hike",
                distance: mapController.calculateDistance(lat, lng),
                tag: getTagFromCategory(json['category']),
                weatherOrRating: calculateAverageRating(json['ratings']),
                isHike: json['category'] == "Hike",
              );
            })
            .toList();

        allLocations.assignAll(freshList);

        await _homeBox.clear();
        await _homeBox.addAll(freshList);
      }
    } catch (e) {
      print("Home Fetch Error (using cache): $e");
    } finally {
      isLoading.value = false;
    }
  }

  String getTagFromCategory(String? category) {
    switch (category) {
      case "Hike":
        return "#Hike";
      case "Epic Photo Spot":
        return "#Epic";
      case "Campground":
        return "#Camp";
      case "Freedom Camping":
        return "#Freedom";
      default:
        return "#Explore";
    }
  }

  Future<void> submitRating(String locationId, double ratingValue) async {
    try {
      final token = await StorageService.getToken();

      final response = await _dio.post(
        'location/$locationId/rating',
        data: {'rating': ratingValue.toInt().toString()},
        options: dio.Options(
          headers: {
            'Cookie': 'accessToken=$token',
            'ngrok-skip-browser-warning': 'true',
          },
        ),
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Thank you for your rating!');
        fetchLocations();
        mapController.fetchApprovedLocations();
      }
    } on dio.DioException catch (e) {
      Get.snackbar(
        'Error',
        e.response?.data['message'] ?? "Failed to submit rating",
      );
    }
  }

  String calculateAverageRating(List? ratings) {
    if (ratings == null || ratings.isEmpty) return "0.0";

    double total = 0;
    for (var r in ratings) {
      total += double.tryParse(r['rating'].toString()) ?? 0.0;
    }

    return (total / ratings.length).toStringAsFixed(1);
  }
}
