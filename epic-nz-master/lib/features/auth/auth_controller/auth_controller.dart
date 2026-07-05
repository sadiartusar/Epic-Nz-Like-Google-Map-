import 'dart:async';
import 'dart:convert';

import 'package:epic_nz/bindings/dependency_injection.dart';
import 'package:epic_nz/core/base_url/api_constants.dart';
import 'package:epic_nz/core/service/storage_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import '../../../core/service/notification_service.dart';
import '../../../routes/app_routes.dart';
import '../../home/weather/weather_controller/weather_controller.dart';
import '../../profile/profile_controller/profile_controller.dart';

class AuthController extends GetxController {
  final dio.Dio _dio = dio.Dio(
    dio.BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 15),
    ),
  );

  var email = ''.obs;
  var fullName = ''.obs;
  var password = ''.obs;
  var otp = ''.obs;
  var isLoading = false.obs;
  var isForgotPasswordMode = false.obs;

  var resendSeconds = 120.obs;
  var canResend = false.obs;
  Timer? _resendTimer;

  void startResendTimer() {
    resendSeconds.value = 120;
    canResend.value = false;

    _resendTimer?.cancel();

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendSeconds.value > 0) {
        resendSeconds.value--;
      } else {
        canResend.value = true;
        timer.cancel();
      }
    });
  }

  Future<void> resendOtp() async {
    if (!canResend.value) return;

    try {
      await _dio.post('otp/resend-otp', data: {'email': email.value});

      Get.snackbar("Success", "OTP Resent");
      startResendTimer();
    } catch (e) {
      Get.snackbar("Error", "Failed to resend OTP");
    }
  }

  @override
  void onClose() {
    _resendTimer?.cancel();
    super.onClose();
  }

  Future<void> register() async {
    try {
      isLoading.value = true;
      isForgotPasswordMode.value = false;

      final response = await _dio.post(
        'user/register',
        data: {
          'full_name': fullName.value,
          'email': email.value,
          'password': password.value.isEmpty
              ? 'temporary_password'
              : password.value,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        String token = response.data['data']['accessToken'];
        String userId = response.data['data']['createUser']['_id'];

        await StorageService.saveToken(token);
        await StorageService.saveUserId(userId);

        Get.toNamed(AppRoutes.verification);
      }
    } on dio.DioException catch (e) {
      Get.snackbar(
        'Error',
        e.response?.data['message'] ?? 'Registration failed',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Map<String, dynamic> parseJwt(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) {
        throw Exception('Invalid token');
      }

      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final resp = utf8.decode(base64Url.decode(normalized));
      return jsonDecode(resp);
    } catch (e) {
      throw Exception("JWT decode failed");
    }
  }

  Future<void> login(String loginEmail, String loginPassword) async {
    try {
      isLoading.value = true;

      final response = await _dio.post(
        'auth/login',
        data: {'email': loginEmail, 'password': loginPassword},
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        final token = data['accessToken'];

        final decoded = parseJwt(token);
        final userId = decoded['userId'];

        await StorageService.saveToken(token);
        await StorageService.saveUserId(userId);

        await NotificationService().syncToken();

        Get.deleteAll(force: true);
        DependencyInjection.init();

        Get.offAllNamed(AppRoutes.main);

        Future.delayed(const Duration(milliseconds: 300), () {
          if (Get.isRegistered<ProfileController>()) {
            Get.find<ProfileController>().fetchProfile();
          }

          if (Get.isRegistered<WeatherController>()) {
            Get.find<WeatherController>().fetchWeather();
          }
        });
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Future<void> _ensureAndSyncFcmToken() async {
  //   try {
  //     final fcmToken = await FirebaseMessaging.instance.getToken();
  //
  //     if (fcmToken == null || fcmToken.isEmpty) {
  //       debugPrint("⚠️ FCM token not ready yet.");
  //       return;
  //     }
  //
  //     await NotificationService().syncToken();
  //   } catch (e) {
  //     debugPrint("❌ FCM ensure error: $e");
  //   }
  // }

  Future<void> _ensureAndSyncFcmToken() async {
    try {
      await Future.delayed(const Duration(milliseconds: 1000));

      String? token = await StorageService.getToken();
      debugPrint("🔍 Current Login Token for Sync: ${token?.substring(0, 10)}...");

      if (token != null && token.isNotEmpty) {
        await NotificationService().syncToken();
      } else {
        debugPrint("⚠️ Access Token is still null in storage!");
      }
    } catch (e) {
      debugPrint("❌ FCM ensure error: $e");
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      isLoading.value = true;

      final String authUrl =
          '${ApiConstants.baseUrl}auth/google?redirect=epicnz://callback';

      final result = await FlutterWebAuth2.authenticate(
        url: authUrl,
        callbackUrlScheme: "epicnz",
      );

      final uri = Uri.parse(result);

      final token = uri.queryParameters['token'];
      final userId = uri.queryParameters['userId'];

      if (token == null || token.isEmpty) {
        throw Exception("Google token not received");
      }

      await StorageService.saveToken(token);

      if (userId != null && userId.isNotEmpty) {
        await StorageService.saveUserId(userId);
      }

      //await NotificationService().syncToken();
      await _ensureAndSyncFcmToken();

      Get.deleteAll(force: true);
      DependencyInjection.init();

      Get.offAllNamed(AppRoutes.main);

      Future.delayed(const Duration(milliseconds: 300), () {
        if (Get.isRegistered<ProfileController>()) {
          Get.find<ProfileController>().fetchProfile();
        }

        if (Get.isRegistered<WeatherController>()) {
          Get.find<WeatherController>().fetchWeather();
        }
      });
    } catch (e) {
      Get.snackbar('Error', 'Google Login failed');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginWithApple() async {
    try {
      isLoading.value = true;

      final String authUrl =
          '${ApiConstants.baseUrl}auth/apple?redirect=epicnz://callback';

      final result = await FlutterWebAuth2.authenticate(
        url: authUrl,
        callbackUrlScheme: "epicnz",
      );

      final uri = Uri.parse(result);

      final token = uri.queryParameters['token'];
      final userId = uri.queryParameters['userId'];

      if (token == null || token.isEmpty) {
        throw Exception("Apple token not received");
      }

      await StorageService.saveToken(token);

      if (userId != null && userId.isNotEmpty) {
        await StorageService.saveUserId(userId);
      }

      //await NotificationService().syncToken();
      await _ensureAndSyncFcmToken();

      Get.deleteAll(force: true);
      DependencyInjection.init();

      Get.offAllNamed(AppRoutes.main);

      Future.delayed(const Duration(milliseconds: 300), () {
        if (Get.isRegistered<ProfileController>()) {
          Get.find<ProfileController>().fetchProfile();
        }

        if (Get.isRegistered<WeatherController>()) {
          Get.find<WeatherController>().fetchWeather();
        }
      });
    } catch (e) {
      Get.snackbar('Error', 'Apple Login failed');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOtp() async {
    try {
      isLoading.value = true;

      final response = await _dio.post(
        'otp/verify-otp',
        data: {'email': email.value, 'otp': otp.value.trim()},
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'OTP Verified successfully');
        Get.toNamed(AppRoutes.setPassword);
      }
    } on dio.DioException catch (e) {
      Get.snackbar('Error', e.response?.data['message'] ?? 'Invalid OTP');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyForgotPasswordOtp() async {
    try {
      isLoading.value = true;
      final response = await _dio.post(
        'otp/forgot-password-verify-otp',
        data: {'email': email.value, 'otp': otp.value},
      );
      if (response.statusCode == 200) {
        Get.snackbar('Success', 'OTP Verified! Reset your password.');
        Get.toNamed(AppRoutes.setPassword);
      }
    } on dio.DioException catch (e) {
      Get.snackbar('Error', e.response?.data['message'] ?? 'Invalid OTP');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updatePassword(String nPassword, String cPassword) async {
    try {
      isLoading.value = true;
      String? token = await StorageService.getToken();
      final response = await _dio.post(
        'auth/set-password',
        data: {
          'email': email.value,
          'newPassword': nPassword,
          'confirmPassword': cPassword,
        },
        options: dio.Options(headers: {'Cookie': 'accessToken=$token'}),
      );
      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Password set successfully!');
        Get.offAllNamed(AppRoutes.login);
      }
    } on dio.DioException catch (e) {
      Get.snackbar(
        'Error',
        e.response?.data['message'] ?? "Failed to set password",
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> forgetPassword() async {
    try {
      isLoading.value = true;
      isForgotPasswordMode.value = true;
      final response = await _dio.post(
        'auth/forget-password',
        data: {'email': email.value},
      );
      if (response.statusCode == 200) {
        Get.toNamed(AppRoutes.verification);
      }
    } catch (e) {
      Get.snackbar('Error', 'User not found');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resetPassword(String passwordValue) async {
    try {
      isLoading.value = true;

      final response = await _dio.post(
        'auth/reset-password',
        data: {'email': email.value, 'newPassword': passwordValue},
      );

      print("Reset Password API Response: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Success', 'Password reset successfully!');
        Get.offAllNamed(AppRoutes.login);
      }
    } on dio.DioException catch (e) {
      print("SERVER ERROR: ${e.response?.data}");

      var msg = e.response?.data is Map
          ? e.response?.data['message']
          : "Reset failed. Please try again.";
      Get.snackbar('Error', msg);
    } catch (e) {
      print("Unexpected Error: $e");
      Get.snackbar('Error', 'Something went wrong');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getAndSaveUserData() async {
    try {
      String? token = await StorageService.getToken();

      final response = await _dio.get(
        'user/get_me',
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer $token',
            'ngrok-skip-browser-warning': 'true',
          },
        ),
      );

      if (response.statusCode == 200) {
        String userId = response.data['data']['_id'];
        await StorageService.saveUserId(userId);
      }
    } catch (e) {
      print("Error saving user data: $e");
    }
  }

  Future<void> logoutUser() async {
    try {
      isLoading.value = true;

      await StorageService.logout();
      Get.deleteAll(force: true);
      DependencyInjection.init();

      Get.offAllNamed(AppRoutes.login);
    } finally {
      isLoading.value = false;
    }
  }
}
