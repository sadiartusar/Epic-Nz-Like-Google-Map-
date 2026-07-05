import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:epic_nz/core/base_url/api_constants.dart';
import 'package:epic_nz/features/map/map_controller/map_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/service/storage_service.dart';

class ProfileController extends GetxController {
  final dio.Dio _dio = dio.Dio(dio.BaseOptions(baseUrl: ApiConstants.baseUrl));

  var fullName = 'User'.obs;
  var email = ''.obs;
  var profilePic = ''.obs;
  var coverPic = ''.obs;
  var mySubmissions = [].obs;
  var isLoading = false.obs;
  var isUpdating = false.obs;

  var totalSubmissions = "0".obs;
  var totalSavedCount = "0".obs;
  var userAvgRating = "0.0".obs;

  var epicSavedCount = 0.obs;
  var hikeSavedCount = 0.obs;
  var campingSavedCount = 0.obs;
  var campGroundSavedCount = 0.obs;

  var selectedIds = <String>[].obs;

  bool get isAllSelected =>
      selectedIds.length == mySubmissions.length && mySubmissions.isNotEmpty;

  var selectedProfileImage = Rxn<File>();
  var selectedCoverImage = Rxn<File>();

  @override
  void onInit() {
    super.onInit();

    _initializeProfile();
  }

  Future<void> _initializeProfile() async {
    await _loadProfileFromCache();
    await refreshAllProfileData();
  }

  Future<void> fetchProfile() async {
    await refreshAllProfileData();
  }

  Future<void> _loadProfileFromCache() async {
    final cache = await StorageService.getProfileCache();
    if (cache == null) return;

    fullName.value = cache['fullName'] ?? fullName.value;
    email.value = cache['email'] ?? email.value;
    profilePic.value = cache['profilePic'] ?? profilePic.value;
    coverPic.value = cache['coverPic'] ?? coverPic.value;

    totalSavedCount.value = cache['totalSavedCount'] ?? totalSavedCount.value;
    totalSubmissions.value =
        cache['totalSubmissions'] ?? totalSubmissions.value;
    userAvgRating.value = cache['userAvgRating'] ?? userAvgRating.value;
  }

  Future<void> refreshAllProfileData() async {
    await fetchUserData();
    await fetchMySubmissions();
    _calculateMyGivenAvgRating();
  }

  Future<void> fetchUserData() async {
    try {
      String? token = await StorageService.getToken();
      if (token == null) return;

      final response = await _dio.get(
        'user/get_me',
        options: dio.Options(
          headers:  ApiConstants.headers(token),
        ),
      );

      if (response.statusCode == 200) {
        var data = response.data['data'];
        fullName.value = data['full_name'] ?? fullName.value;
        email.value = data['email'] ?? email.value;
        userAvgRating.value = (data['avgRating'] ?? 0.0).toStringAsFixed(1);

        if (data['profile_picture'] != null && data['profile_picture'] != "") {
          profilePic.value = data['profile_picture'];
        }
        if (data['coverPicture'] != null && data['coverPicture'] != "") {
          coverPic.value = data['coverPicture'];
        }

        List savedList = data['savedLocationDetails'] ?? [];
        totalSavedCount.value = savedList.length.toString();

        final mapController = Get.find<MapController>();
        if (mapController.apiPlaces.isEmpty) {
          Future.delayed(
            const Duration(seconds: 1),
            () => _calculateCategorizedSavedItems(savedList),
          );
        } else {
          _calculateMyGivenAvgRating();
          _calculateCategorizedSavedItems(savedList);
        }

        await StorageService.saveUserData(
          fullName.value,
          profilePic.value,
          coverPic.value,
        );

        await StorageService.saveProfileCache({
          'fullName': fullName.value,
          'email': email.value,
          'profilePic': profilePic.value,
          'coverPic': coverPic.value,
          'totalSavedCount': totalSavedCount.value,
          'totalSubmissions': totalSubmissions.value,
          'userAvgRating': userAvgRating.value,
        });
      }
    } catch (e) {
      print("Fetch User Error: $e");
    }
  }

  void _calculateCategorizedSavedItems(List savedList) {
    final mapController = Get.find<MapController>();
    int epic = 0;
    int hike = 0;
    int freedomCamping = 0;
    int campGround = 0;

    for (var item in savedList) {
      String id = item['_id'].toString();
      var match = mapController.apiPlaces.firstWhereOrNull(
        (p) => p['_id'].toString() == id,
      );
      if (match != null) {
        String cat = match['category'] ?? "";
        if (cat.contains("Epic")) {
          epic++;
        } else if (cat.contains("Hike")) {
          hike++;
        } else if (cat.contains("Freedom Camping")) {
          freedomCamping++;
        } else if (cat.contains("Campground")) {
          campGround++;
        }
      }
    }
    epicSavedCount.value = epic;
    hikeSavedCount.value = hike;
    campingSavedCount.value = freedomCamping;
    campGroundSavedCount.value = campGround;
  }

  void _calculateUserTotalAvgRating(List submissions) {
    double totalScore = 0;
    int totalPeopleRated = 0;

    for (var spot in submissions) {
      List ratings = spot['ratings'] ?? [];
      for (var r in ratings) {
        double val = double.tryParse(r['rating'].toString()) ?? 0.0;
        if (val > 0) {
          totalScore += val;
          totalPeopleRated++;
        }
      }
    }

    if (totalPeopleRated > 0) {
      userAvgRating.value = (totalScore / totalPeopleRated).toStringAsFixed(1);
    } else {
      userAvgRating.value = "0.0";
    }
    print("User Global Avg Rating Calculated: ${userAvgRating.value}");
  }

  void _calculateMyGivenAvgRating() async {
    final mapController = Get.find<MapController>();
    String? myId = await StorageService.getUserId();

    if (myId == null || mapController.apiPlaces.isEmpty) {
      userAvgRating.value = "0.0";
      return;
    }

    double totalScoreGivenByMe = 0;
    int countOfSpotsIRated = 0;

    for (var spot in mapController.apiPlaces) {
      List ratings = spot['ratings'] ?? [];

      for (var r in ratings) {
        var rUser = r['userId'];
        String rUserId = (rUser is Map)
            ? (rUser['_id'] ?? "").toString()
            : rUser.toString();

        if (rUserId == myId) {
          double val = double.tryParse(r['rating'].toString()) ?? 0.0;
          totalScoreGivenByMe += val;
          countOfSpotsIRated++;
          break;
        }
      }
    }

    if (countOfSpotsIRated > 0) {
      userAvgRating.value = (totalScoreGivenByMe / countOfSpotsIRated)
          .toStringAsFixed(1);
    } else {
      userAvgRating.value = "0.0";
    }

    print(
      "Personal Given Avg Rating: ${userAvgRating.value} based on $countOfSpotsIRated reviews.",
    );
  }

  Future<void> fetchMySubmissions() async {
    try {
      isLoading.value = true;

      final token = await StorageService.getToken();
      if (token == null) return;

      final response = await _dio.get(
        'location/my-submissions',
        options: dio.Options(
          headers: {
            'Cookie': 'accessToken=$token',
            'ngrok-skip-browser-warning': 'true',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List data = response.data['data'] ?? [];

        mySubmissions.assignAll(data);
        totalSubmissions.value = data.length.toString();

        _calculateUserTotalAvgRating(data);
      }
    } catch (e) {
      print("fetchMySubmissions error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickProfileImage(ImageSource source) async {
    final XFile? image = await ImagePicker().pickImage(source: source);
    if (image != null) {
      selectedProfileImage.value = File(image.path);
    }
  }

  Future<void> pickCoverImage(ImageSource source) async {
    final XFile? image = await ImagePicker().pickImage(source: source);
    if (image != null) {
      selectedCoverImage.value = File(image.path);
    }
  }

  Future<void> updateProfile(String newName) async {
    try {
      isUpdating.value = true;
      String? token = await StorageService.getToken();

      if (token == null) {
        Get.snackbar("Error", "User not authenticated");
        return;
      }

      Map<String, dynamic> dataMap = {'full_name': newName};

      if (selectedCoverImage.value != null) {
        dataMap['coverPicture'] = await dio.MultipartFile.fromFile(
          selectedCoverImage.value!.path,
          filename: 'cover.jpg',
        );
      }

      if (selectedProfileImage.value != null) {
        dataMap['profile_picture'] = await dio.MultipartFile.fromFile(
          selectedProfileImage.value!.path,
          filename: 'profile.jpg',
        );
      }

      final response = await _dio.patch(
        'user/update-user',
        data: dio.FormData.fromMap(dataMap),
        options: dio.Options(
          headers: {
            'Cookie': 'accessToken=$token',
            'ngrok-skip-browser-warning': 'true',
          },
        ),
      );

      debugPrint("🔄 Update response: ${response.data}");

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Profile Updated!");

        selectedProfileImage.value = null;
        selectedCoverImage.value = null;

        await refreshAllProfileData();

        Get.back();
      }
    } catch (e) {
      debugPrint("❌ Profile update error: $e");
      Get.snackbar("Error", "Update failed");
    } finally {
      isUpdating.value = false;
    }
  }

  Future<void> deleteSelectedSubmissions() async {
    try {
      isLoading.value = true;
      String? token = await StorageService.getToken();

      for (String id in selectedIds) {
        await _dio.delete(
          'location/$id',
          options: dio.Options(
            headers: {
              'Cookie': 'accessToken=$token',
              'ngrok-skip-browser-warning': 'true',
            },
          ),
        );
      }

      mySubmissions.removeWhere((item) => selectedIds.contains(item['_id']));

      clearSelection();
      await refreshAllProfileData();

      Get.snackbar("Success", "Selected submissions deleted successfully.");
    } catch (e) {
      print("Bulk Delete Error: $e");
      Get.snackbar("Error", "Failed to delete some items.");
    } finally {
      isLoading.value = false;
    }
  }

  void toggleSelectAll() {
    if (isAllSelected) {
      selectedIds.clear();
    } else {
      selectedIds.assignAll(
        mySubmissions.map((e) => e['_id'].toString()).toList(),
      );
    }
  }

  void toggleSelection(String id) {
    if (selectedIds.contains(id)) {
      selectedIds.remove(id);
    } else {
      selectedIds.add(id);
    }
  }

  void clearSelection() {
    selectedIds.clear();
  }
}
