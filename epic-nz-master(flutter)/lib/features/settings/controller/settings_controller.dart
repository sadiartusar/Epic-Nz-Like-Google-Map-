import 'package:get/get.dart';

enum MapViewType { defaultView, satellite, terrain }

class SettingsController extends GetxController {
  final mapView = MapViewType.defaultView.obs;

  String get mapViewLabel {
    switch (mapView.value) {
      case MapViewType.satellite:
        return "Satellite";
      case MapViewType.terrain:
        return "Terrain";
      case MapViewType.defaultView:
      default:
        return "Default";
    }
  }

  void setMapView(MapViewType view) {
    mapView.value = view;
  }
}
