import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';

class PreferencesController extends GetxController {
  final selectedKeys = <String>{}.obs;

  final notificationsEnabled = true.obs;

  final locationEnabled = true.obs;

  bool isSelected(String key) => selectedKeys.contains(key);

  void toggle(String key) {
    if (selectedKeys.contains(key)) {
      selectedKeys.remove(key);
    } else {
      selectedKeys.add(key);
    }
  }

  bool isCategoryEnabled(String category) {
    if (selectedKeys.isEmpty) return true;
    return selectedKeys.contains(category);
  }

  void setNotification(bool value) {
    notificationsEnabled.value = value;
  }

  Future<void> enableLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      locationEnabled.value = false;
      return;
    }

    locationEnabled.value = true;
  }

  void disableLocation() {
    locationEnabled.value = false;
  }
}
