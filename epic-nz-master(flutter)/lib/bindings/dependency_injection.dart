import 'package:epic_nz/features/help_support/contact_controller/contact_controller.dart';
import 'package:epic_nz/features/help_support/contact_controller/support_chat_controller.dart';
import 'package:epic_nz/features/home/screens/main_controller.dart';
import 'package:epic_nz/features/profile/profile_controller/profile_controller.dart';
import 'package:epic_nz/features/settings/controller/settings_controller.dart';
import 'package:epic_nz/features/subscription/data/subscription_controller.dart';
import 'package:get/get.dart';
import '../../core/controller/theme_controller.dart';
import '../../features/auth/auth_controller/auth_controller.dart';
import '../../features/home/home%20_controller/home_controller.dart';
import '../../features/home/weather/weather_controller/weather_controller.dart';
import '../../features/map/map_controller/map_controller.dart';
import '../../features/save_location/controller/bookmark_controller.dart';
import '../features/notification/notification_controller.dart';
import '../features/preferences/controller/preferences_controller.dart';

class DependencyInjection {
  static void init() {
    Get.put(ThemeController(), permanent: true);

    Get.put(PreferencesController(), permanent: true);

    Get.put(SettingsController(), permanent: true);

    Get.put(AuthController(), permanent: true);

    Get.put(WeatherController(), permanent: true);

    Get.put(MapController(), permanent: true);

    Get.put(HomeController(), permanent: true);

    Get.put(SubscriptionController(), permanent: true);

    Get.put(BookmarkController(), permanent: true);

    Get.put(NotificationController(), permanent: true);

    Get.put(MainController(), permanent: true);

    Get.put(ContactController(), permanent: true);
    Get.put(SupportChatController(), permanent: true);

    Get.put(ProfileController(), permanent: true);
  }
}
