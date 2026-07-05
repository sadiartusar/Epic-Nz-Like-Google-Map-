import 'package:epic_nz/bindings/dependency_injection.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:app_links/app_links.dart';

import 'features/home/weather/model/weather_model.dart';
import 'firebase_options.dart';
import 'app.dart';
import 'core/service/notification_service.dart';
import 'routes/app_routes.dart';

final AppLinks _appLinks = AppLinks();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  debugPrint("🔔 Background message received: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  debugPrint("🚀 Boot started");

  await Hive.initFlutter();
  Hive.registerAdapter(WeatherModelAdapter());

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token');

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  Stripe.publishableKey =
      'pk_test_51OJrbOL8KvISqLF2oY50i4nAdRP6tiMYoYZkNH8BQkTupb3etsof3ayetHCRaMYIRtxHRUmv5eRO9XqzsQw6Vsv7007GC23KaD';

  Stripe.merchantIdentifier = 'merchant.com.epicnz';
  await Stripe.instance.applySettings();

  MapboxOptions.setAccessToken(
    'pk.eyJ1IjoiZXBpY256IiwiYSI6ImNta3V3ZW1lYjAwZHMzZnM4b3dpdnU4Y3MifQ.Ta0mlo_uy59ZbLLbkcQNcQ',
  );

  DependencyInjection.init();

  await NotificationService().init();

  final String initialRoute = (token != null && token.isNotEmpty)
      ? '/main'
      : '/onboarding';

  runApp(EpicNzApp(initialRoute: initialRoute));

  _initDeepLinks();
}

void _initDeepLinks() {
  debugPrint("🔗 Initializing App Links...");

  _appLinks.uriLinkStream.listen(
    (Uri uri) {
      _handleDeepLink(uri);
    },
    onError: (error) {
      debugPrint("❌ App Link Error: $error");
    },
  );

  _appLinks.getInitialAppLink().then((Uri? uri) {
    if (uri != null) {
      _handleDeepLink(uri);
    }
  });
}

void _handleDeepLink(Uri uri) {
  debugPrint("🔗 Deep link received: $uri");

  // https://epicnz.com/spot/abc123

  if (uri.pathSegments.contains('spot')) {
    final spotId = uri.pathSegments.last;

    debugPrint("📍 Opening Spot ID: $spotId");

    Get.toNamed(AppRoutes.spotDetail, arguments: {'spotId': spotId});
  }
}
