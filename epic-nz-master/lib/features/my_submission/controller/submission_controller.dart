import 'package:dio/dio.dart' as dio;
import 'package:epic_nz/core/base_url/api_constants.dart';
import 'package:epic_nz/core/service/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/widgets/error_snackbar.dart';
import '../../../core/widgets/success_snackbar.dart';

class SubmissionController extends GetxController {
  final dio.Dio _epicDio = dio.Dio(
    dio.BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
    ),
  );

  // final dio.Dio _aiDio = dio.Dio(
  //   dio.BaseOptions(
  //      baseUrl: 'http://10.123.64.63:5000/api/v1/ai-submission', 
  //     connectTimeout: const Duration(seconds: 120),
  //     receiveTimeout: const Duration(seconds: 120),
  //   ),
  // );

  final dio.Dio _aiDio = dio.Dio(
    dio.BaseOptions(
      // ১. শেষে অবশ্যই একটা স্ল্যাশ (/) দিবেন
      // baseUrl: 'http://10.123.64.63:5000/api/v1/ai-submission/', 
      baseUrl: '${ApiConstants.baseUrl}ai-submission/', 
      connectTimeout: const Duration(seconds: 120),
      receiveTimeout: const Duration(seconds: 120),
    ),
  );

  Future<bool> generateCaptionFromAI() async {
    if (selectedImages.isEmpty) return false;

    try {
      isGenerating.value = true;
      // ২. এখানে স্ল্যাশ (/) দিবেন না, সরাসরি রুটের নাম লিখবেন
      const String uploadUrl = 'generate-caption'; 
      print("🚀 AI API Call: ${_aiDio.options.baseUrl}$uploadUrl");

      final dio.FormData formData = dio.FormData.fromMap({
        'images': [
          for (final path in selectedImages)
            await dio.MultipartFile.fromFile(
              path, 
              filename: path.split('/').last
            ),
        ],
      });

      final response = await _aiDio.post(
        uploadUrl, // এখানে স্ল্যাশ ছাড়া নাম
        data: formData,
        onSendProgress: (sent, total) {
          print("📤 Uploading: ${(sent / total * 100).toStringAsFixed(0)}%");
        },
      );

      print("✅ AI Success: ${response.data}");
      if (response.statusCode == 200 && response.data['valid'] == true) {
        nameController.text = response.data['title'] ?? '';
        descController.text = response.data['description'] ?? '';
        return true;
      }
      return false;
    } catch (e) {
      print("❌ AI Generation Error: $e");
      return false;
    } finally {
      isGenerating.value = false;
    }
  }

  final RxList<String> selectedImages = <String>[].obs;

  final RxDouble lat = 0.0.obs;
  final RxDouble lng = 0.0.obs;

  final RxList<Map<String, dynamic>> selectedTags =
      <Map<String, dynamic>>[].obs;

  final RxString weatherType = ''.obs;
  final RxString animalClearance = ''.obs;
  final RxString networkQuality = ''.obs;

  final RxBool isLoading = false.obs;
  final RxBool isGenerating = false.obs;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  final RxDouble submitProgress = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      lat.value = Get.arguments['lat'] ?? 0.0;
      lng.value = Get.arguments['lng'] ?? 0.0;
    }
  }

  // Future<void> takePhoto() async {
  //   if (selectedImages.length >= 5) {
  //     Get.showSnackbar(
  //       ErrorSnackbar(message: "You can upload a maximum of 5 photos"),
  //     );
  //     return;
  //   }

  //   final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
  //   if (photo != null) {
  //     selectedImages.add(photo.path);
  //   }
  // }

  // Future<void> pickFromGallery() async {
  //   if (selectedImages.length >= 5) {
  //     Get.showSnackbar(
  //       ErrorSnackbar(message: "You can upload a maximum of 5 photos"),
  //     );
  //     return;
  //   }

  //   final List<XFile> images = await _picker.pickMultiImage();
  //   if (images.isEmpty) return;

  //   final int remainingSlots = 5 - selectedImages.length;

  //   for (final img in images.take(remainingSlots)) {
  //     selectedImages.add(img.path);
  //   }

  //   if (images.length > remainingSlots) {
  //     Get.showSnackbar(ErrorSnackbar(message: "Only 5 images are allowed"));
  //   }
  // }

  // takePhoto আপডেট করুন
  Future<void> takePhoto() async {
    if (selectedImages.length >= 5) return;
    
    // maxWidth এবং imageQuality যোগ করুন
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1024, // ছবি বড় হলেও ১০২৪ পিক্সেল হয়ে যাবে
      imageQuality: 70, // কোয়ালিটি ৭০% এ নামিয়ে আনবে
    );
    if (photo != null) {
      selectedImages.add(photo.path);
    }
  }

  // pickFromGallery আপডেট করুন
  Future<void> pickFromGallery() async {
    if (selectedImages.length >= 5) return;
    
    // maxWidth এবং imageQuality যোগ করুন
    final List<XFile> images = await _picker.pickMultiImage(
      maxWidth: 1024, 
      imageQuality: 70,
    );
    if (images.isEmpty) return;

    final int remainingSlots = 5 - selectedImages.length;
    for (final img in images.take(remainingSlots)) {
      selectedImages.add(img.path);
    }
  }

  void toggleTag(Map<String, dynamic> tag) {
    if (selectedTags.any((e) => e['label'] == tag['label'])) {
      selectedTags.removeWhere((e) => e['label'] == tag['label']);
    } else {
      selectedTags
        ..clear()
        ..add(tag);
    }
  }

  bool isTagSelected(String label) {
    return selectedTags.any((e) => e['label'] == label);
  }

  void setWeather(String value) {
    weatherType.value = value;
  }

  void setAnimal(String value) {
    animalClearance.value = value;
  }

  void setNetwork(String value) {
    networkQuality.value = value;
  }

  // Future<bool> generateCaptionFromAI() async {
  //   if (selectedImages.isEmpty) {
  //     Get.showSnackbar(
  //       ErrorSnackbar(message: "Please select at least one image"),
  //     );
  //     return false;
  //   }

  //   try {
  //     isGenerating.value = true;

  //     final dio.FormData formData = dio.FormData.fromMap({
  //       'platform': 'instagram',
  //       'tone': 'formal',
  //       'imageCount': selectedImages.length.toString(),

  //       'context': '',
  //       'userTitle': nameController.text.trim(),
  //       'userDescription': descController.text.trim(),

  //       'images': [
  //         for (final path in selectedImages)
  //           await dio.MultipartFile.fromFile(path),
  //       ],
  //     });

  //     final response = await _aiDio.post('/generate-caption', data: formData);

  //     if (response.statusCode == 200 && response.data['valid'] == true) {
  //       nameController.text = response.data['title'] ?? '';
  //       descController.text = response.data['description'] ?? '';

  //       Get.showSnackbar(
  //         SuccessSnackbar(message: "AI details generated successfully"),
  //       );
  //       return true;
  //     } else {
  //       Get.showSnackbar(
  //         ErrorSnackbar(message: "AI could not generate details"),
  //       );
  //       return false;
  //     }
  //   } catch (e) {
  //     Get.showSnackbar(ErrorSnackbar(message: "AI generation failed"));
  //     return false;
  //   } finally {
  //     isGenerating.value = false;
  //   }
  // }

  //  Future<bool> generateCaptionFromAI() async {
  //   if (selectedImages.isEmpty) return false;

  //   try {
  //     isGenerating.value = true;
  //     print("🚀 AI API Call: ${_aiDio.options.baseUrl}/generate-caption");

  //     // FormData তৈরি করার সময় filename মাস্ট দিবেন
  //     final dio.FormData formData = dio.FormData.fromMap({
  //       'images': [
  //         for (final path in selectedImages)
  //           await dio.MultipartFile.fromFile(
  //             path, 
  //             filename: path.split('/').last // এটি সার্ভারকে বুঝতে সাহায্য করে এটা একটা ফাইল
  //           ),
  //       ],
  //     });

  //     final response = await _aiDio.post(
  //       '/generate-caption', 
  //       data: formData,
  //       // আপলোড কতটুকু হচ্ছে তা দেখার জন্য এটি যোগ করুন
  //       onSendProgress: (sent, total) {
  //         double progress = (sent / total);
  //         print("📤 Uploading AI images: ${(progress * 100).toStringAsFixed(0)}%");
  //       },
  //     );

  //     print("✅ Response Data: ${response.data}");

  //     if (response.statusCode == 200 && response.data['valid'] == true) {
  //       nameController.text = response.data['title'] ?? '';
  //       descController.text = response.data['description'] ?? '';
  //       return true;
  //     }
  //     return false;
  //   } catch (e) {
  //     print("❌ AI Generation Error: $e");
  //     if (e is dio.DioException) {
  //       print("Detailed Error: ${e.response?.data}");
  //     }
  //     return false;
  //   } finally {
  //     isGenerating.value = false;
  //   }
  // }

  String _normalizeEnum(String value) {
    if (value.isEmpty) return value;
    return value
        .split(' ')
        .map(
          (e) => e.isNotEmpty
              ? e[0].toUpperCase() + e.substring(1).toLowerCase()
              : e,
        )
        .join(' ');
  }

  Future<void> submitLocation() async {
    if (nameController.text.trim().isEmpty ||
        descController.text.trim().isEmpty) {
      Get.showSnackbar(
        ErrorSnackbar(message: "Title and description are required"),
      );
      return;
    }

    try {
      isLoading.value = true;
      submitProgress.value = 0.0;

      Future.doWhile(() async {
        await Future.delayed(const Duration(milliseconds: 120));
        if (submitProgress.value >= 0.9) return false;
        submitProgress.value += 0.05;
        return isLoading.value;
      });

      final String? token = await StorageService.getToken();

      final String category = selectedTags.isNotEmpty
          ? selectedTags.first['label']
          : 'Hike';

      final dio.FormData formData = dio.FormData.fromMap({
        'latitude': lat.value.toString(),
        'longitude': lng.value.toString(),
        'category': category,
        'name': nameController.text.trim(),
        'description': descController.text.trim(),
        'watererType': _normalizeEnum(weatherType.value),
        'animalClearance': _normalizeEnum(animalClearance.value),
        'networkQuality': _normalizeEnum(networkQuality.value),
        'image': [
          for (final path in selectedImages)
            await dio.MultipartFile.fromFile(path),
        ],
      });

      final response = await _epicDio.post(
        'location/submit',
        data: formData,
        options: dio.Options(
          headers: {
            'Cookie': 'accessToken=$token',
            'ngrok-skip-browser-warning': 'true',
          },
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        submitProgress.value = 1.0;

        Get.showSnackbar(
          SuccessSnackbar(
            message:
                response.data['message'] ?? "Location submitted successfully",
          ),
        );

        Get.offAllNamed('/submission-received');
      } else {
        Get.showSnackbar(
          ErrorSnackbar(
            message: response.data['message'] ?? "Submission failed",
          ),
        );
      }
    } catch (e) {
      debugPrint("SUBMISSION ERROR: $e");
      Get.showSnackbar(ErrorSnackbar(message: "Submission failed"));
    } finally {
      isLoading.value = false;
      submitProgress.value = 0.0;
    }
  }

  Future<String> getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isEmpty) return "Unknown Location";

      final place = placemarks.first;

      final parts = [
        place.name,
        place.locality,
        place.administrativeArea,
        place.country,
      ].where((e) => e != null && e.isNotEmpty).toList();

      return parts.join(', ');
    } catch (e) {
      debugPrint("GEOCODING ERROR: $e");
      return "Unknown Location";
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    descController.dispose();
    super.onClose();
  }
}
