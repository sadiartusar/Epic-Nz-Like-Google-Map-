import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../base_url/api_constants.dart';
import '../service/storage_service.dart';
import '../../features/notification/notification_controller.dart';
import '../../features/preferences/controller/preferences_controller.dart';
import '../../routes/app_routes.dart';
import 'package:dio/dio.dart' as dio;

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  final dio.Dio _dio = dio.Dio(
    dio.BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 15),
    ),
  );

  Future<void> init() async {
    final PreferencesController prefs = Get.find<PreferencesController>();

    if (!prefs.notificationsEnabled.value) {
      debugPrint("🚫 Notifications disabled by user");
      return;
    }

    await _initLocalNotifications();
    await _requestPermission();

    _listenForeground();
    _listenBackgroundTap();
    _listenTokenRefresh();
  }

  Future<void> _initLocalNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');

    const ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(android: android, iOS: ios);

    await _localNotifications.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: (response) {
        if (response.payload != null) {
          final Map<String, dynamic> data = jsonDecode(response.payload!);
          _handleNotificationTap(data);
        }
      },
    );

    if (Platform.isAndroid) {
      const channel = AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description: 'Used for important notifications',
        importance: Importance.max,
      );

      await _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(channel);
    }
  }

  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    debugPrint("🔔 Permission: ${settings.authorizationStatus}");
  }

  void _listenForeground() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      final prefs = Get.find<PreferencesController>();
      if (!prefs.notificationsEnabled.value) return;

      debugPrint("🔔 FCM (foreground)");
      debugPrint("📌 Title: ${message.notification?.title}");
      debugPrint("📌 Body: ${message.notification?.body}");
      debugPrint("📌 Data: ${message.data}");

      await _showLocalNotification(message);

      if (Get.isRegistered<NotificationController>()) {
        Get.find<NotificationController>().fetch();
      }
    });
  }

  void _listenBackgroundTap() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final prefs = Get.find<PreferencesController>();
      if (!prefs.notificationsEnabled.value) return;

      debugPrint("📲 App opened from notification");
      _handleNotificationTap(message.data);
    });
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;

    final title = notification?.title ?? message.data['title'];
    final body = notification?.body ?? message.data['body'];

    if (title == null || body == null) return;

    const androidDetails = AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);

    await _localNotifications.show(
      id: title.hashCode,
      title: title,
      body: body,
      notificationDetails: details,
      payload: message.data.isNotEmpty ? jsonEncode(message.data) : null,
    );
  }

  // Future<void> syncToken() async {
  //   //   try {
  //   //     final accessToken = await StorageService.getToken();
  //   //
  //   //     if (accessToken == null || accessToken.isEmpty) {
  //   //       debugPrint("⚠️ No access token. FCM sync skipped.");
  //   //       return;
  //   //     }
  //   //
  //   //     final fcmToken = await FirebaseMessaging.instance.getToken();
  //   //
  //   //     if (fcmToken == null || fcmToken.isEmpty) {
  //   //       debugPrint("⚠️ FCM token null. Skipped.");
  //   //       return;
  //   //     }
  //   //
  //   //     final prefs = await SharedPreferences.getInstance();
  //   //     final lastSyncedToken = prefs.getString('last_fcm_token');
  //   //
  //   //     if (lastSyncedToken == fcmToken) {
  //   //       debugPrint("ℹ️ FCM already synced.");
  //   //       return;
  //   //     }
  //   //
  //   //     final dio = Dio(
  //   //       BaseOptions(
  //   //         baseUrl: ApiConstants.baseUrl,
  //   //         headers: {'Authorization': 'Bearer $accessToken'},
  //   //       ),
  //   //     );
  //   //
  //   //     await dio.patch(
  //   //       "user/fcm-token",
  //   //       data: {
  //   //         "fcmTokens": [fcmToken],
  //   //       },
  //   //     );
  //   //
  //   //     await prefs.setString('last_fcm_token', fcmToken);
  //   //
  //   //     debugPrint("✅ FCM token synced successfully.");
  //   //   } catch (e) {
  //   //     debugPrint("❌ FCM sync error: $e");
  //   //   }
  //   // }

  Future<void> syncToken() async {
    try {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken == null || fcmToken.isEmpty) return;

      final accessToken = await StorageService.getToken();
      if (accessToken == null || accessToken.isEmpty) {
        debugPrint("⚠️ AccessToken missing. Cannot sync FCM.");
        return;
      }

      debugPrint("🚀 Syncing FCM with Dual Auth (Bearer + Cookie)");

      final response = await _dio.patch(
        "user/fcm-token",
        data: {
          "fcmTokens": [fcmToken],
        },
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer $accessToken',

            'Cookie': 'accessToken=$accessToken',

            'ngrok-skip-browser-warning': 'true',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('last_fcm_token', fcmToken);
        debugPrint("✅ FCM token synced successfully (Dual Auth)");
      }
    } catch (e) {
      if (e is dio.DioException) {
        debugPrint("❌ FCM sync error (${e.response?.statusCode}): ${e.response?.data}");
      } else {
        debugPrint("❌ FCM sync unexpected error: $e");
      }
    }
  }

  void _listenTokenRefresh() {
    FirebaseMessaging.instance.onTokenRefresh.listen((String newToken) {
      final prefs = Get.find<PreferencesController>();
      if (!prefs.notificationsEnabled.value) return;

      debugPrint("🔄 FCM token refreshed");
      _sendTokenToBackend(newToken);
    });
  }

  Future<void> _sendTokenToBackend(String token) async {
    try {
      final accessToken = await StorageService.getToken();
      if (accessToken == null) return;

      await _dio.patch(
        "user/fcm-token",
        data: {
          "fcmTokens": [token],
        },
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'ngrok-skip-browser-warning': 'true',
          },
        ),
      );
      debugPrint("✅ FCM token synced with backend");
    } catch (e) {
      debugPrint("❌ FCM token sync failed: $e");
    }
  }

  void _handleNotificationTap(Map<String, dynamic> data) {
    final deepLink = data['deepLink'];
    if (deepLink == null) return;

    if (deepLink.startsWith('/location/')) {
      final locationId = data['locationId'];
      if (locationId != null) {
        Get.toNamed(
          AppRoutes.spotDetail,
          arguments: {'locationId': locationId},
        );
      }
      return;
    }

    if (deepLink.startsWith('/chat/')) {
      Get.toNamed(
        AppRoutes.supportChat,
        arguments: {'adminId': data['senderId']},
      );
    }
  }
}
