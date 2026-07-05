import 'package:dio/dio.dart' as dio;
import 'package:epic_nz/core/base_url/api_constants.dart';
import 'package:epic_nz/core/service/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FeedbackController extends GetxController {
  final dio.Dio _dio = dio.Dio(
    dio.BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      validateStatus: (code) => code != null && code >= 200 && code < 300,
    ),
  );

  final titleController = TextEditingController();
  final messageController = TextEditingController();

  final isSubmitting = false.obs;

  @override
  void onClose() {
    titleController.dispose();
    messageController.dispose();
    super.onClose();
  }

  Future<void> submitFeedback() async {
    final title = titleController.text.trim();
    final message = messageController.text.trim();

    if (title.length < 3) {
      Get.snackbar("Error", "Title must be at least 3 characters");
      return;
    }
    if (message.length < 5) {
      Get.snackbar("Error", "Message must be at least 5 characters");
      return;
    }

    try {
      isSubmitting.value = true;

      final token = await StorageService.getToken();

      final response = await _dio.post(
        'feedback',
        data: {'title': title, 'message': message},
        options: dio.Options(headers: ApiConstants.headers(token)),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("Success", "Thank you for your feedback");

        titleController.clear();
        messageController.clear();

        FocusManager.instance.primaryFocus?.unfocus();
      } else {
        Get.snackbar("Failed", "Could not submit feedback");
      }
    } on dio.DioException catch (e) {
      final msg =
          (e.response?.data is Map && e.response?.data["message"] != null)
          ? e.response?.data["message"].toString()
          : "Failed to submit feedback";
      Get.snackbar("Error", msg!);
    } catch (_) {
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isSubmitting.value = false;
    }
  }
}
