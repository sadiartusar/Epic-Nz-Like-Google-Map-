import 'package:get/get.dart';

class MainController extends GetxController {
  final selectedIndex = 0.obs;

  void goToMap() {
    selectedIndex.value = 1;
  }

  void goToHome() {
    selectedIndex.value = 0;
  }
}
