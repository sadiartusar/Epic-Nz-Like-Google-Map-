import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart' as dio;
import 'package:epic_nz/core/base_url/api_constants.dart';
import 'package:epic_nz/core/service/storage_service.dart';
import 'package:epic_nz/features/map/widgets/place_details_sheet.dart';
import 'package:epic_nz/features/my_submission/controller/submission_controller.dart';
import 'package:epic_nz/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
import 'dart:ui' as ui;

import '../../preferences/controller/preferences_controller.dart';
import '../../settings/controller/settings_controller.dart';

class MapController extends GetxController {
  mapbox.MapboxMap? mapboxMap;
  mapbox.PointAnnotationManager? placeMarkerManager;
  mapbox.CircleAnnotationManager? tapMarkerManager;

  mapbox.CircleAnnotation? _pinOuter;
  mapbox.CircleAnnotation? _pinInner;

  mapbox.PolylineAnnotationManager? routeLineManager;

  late Box _mapCacheBox;

  final dio.Dio _dio =
      dio.Dio(
          dio.BaseOptions(
            baseUrl: ApiConstants.baseUrl,
            headers: {'ngrok-skip-browser-warning': 'true'},
          ),
        )
        ..interceptors.add(
          dio.InterceptorsWrapper(
            onRequest: (options, handler) async {
              final token = await StorageService.getToken();

              if (token != null && token.isNotEmpty) {
                options.headers['Cookie'] = 'accessToken=$token';
              }

              return handler.next(options);
            },
          ),
        );

  final apiPlaces = <Map<String, dynamic>>[].obs;
  final nearYouPlaces = <Map<String, dynamic>>[].obs;

  final isLoading = false.obs;
  final selectedFilter = 'All'.obs;
  final searchQuery = ''.obs;
  final currentIndex = 0.obs;

  final Rxn<Map<String, dynamic>> selectedPlace = Rxn();

  Position? userPosition;
  mapbox.Point? userPoint;
  final selectedLocation = Rxn<mapbox.Point>();

  final Map<String, Uint8List> _markerImageCache = {};

  final Map<String, String> _resolvedAddresses = {};

  final stt.SpeechToText _speech = stt.SpeechToText();
  final isListening = false.obs;

  Timer? _filterDebounce;
  final Map<String, Uint8List> _premiumMarkerCache = {};

  final PreferencesController prefs = Get.find<PreferencesController>();
  final SettingsController settings = Get.find<SettingsController>();

  @override
  void onInit() {
    super.onInit();
    _initCache();

    ever(settings.mapView, (_) {
      _applyMapStyle();
    });
  }

  @override
  void onClose() {
    _filterDebounce?.cancel();
    super.onClose();
  }

  List<Map<String, dynamic>> get filteredPlaces {
    List<Map<String, dynamic>> list = apiPlaces.toList();

    if (selectedFilter.value != 'All') {
      String key = selectedFilter.value;

      if (key == "Hikes") key = "Hike";
      if (key == "Epic") key = "Epic Photo Spot";
      if (key == "Camping") key = "Campground";
      if (key == "Photos") key = "Photo Spot";

      list = list.where((p) => (p['category'] ?? '') == key).toList();
    }

    final q = searchQuery.value.trim().toLowerCase();
    if (q.isNotEmpty) {
      list = list.where((p) {
        final name = (p['name'] ?? '').toString().toLowerCase();
        final cat = (p['category'] ?? '').toString().toLowerCase();
        return name.contains(q) || cat.contains(q);
      }).toList();
    }

    return list;
  }

  Future<void> _initCache() async {
    _mapCacheBox = await Hive.openBox('map_cache');

    if (_mapCacheBox.containsKey('approved_locations')) {
      final rawList = _mapCacheBox.get('approved_locations') as List;

      final cached = rawList
          .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e as Map))
          .toList();

      apiPlaces.assignAll(cached);
      _updateNearbyPlaces();
    }

    fetchApprovedLocations();
  }

  void _refreshMarkers() {
    _filterDebounce?.cancel();
    _filterDebounce = Timer(const Duration(milliseconds: 250), () async {
      if (mapboxMap == null || placeMarkerManager == null) return;
      await _drawPlaceMarkers(filteredPlaces);
      _updateNearbyPlaces();
    });
  }

  Future<void> _applyMapStyle() async {
    if (mapboxMap == null) return;

    try {
      switch (settings.mapView.value) {
        case MapViewType.satellite:
          await mapboxMap!.loadStyleURI(mapbox.MapboxStyles.SATELLITE_STREETS);
          break;

        case MapViewType.terrain:
          await mapboxMap!.loadStyleURI(mapbox.MapboxStyles.OUTDOORS);
          break;

        case MapViewType.defaultView:
          await mapboxMap!.loadStyleURI(mapbox.MapboxStyles.MAPBOX_STREETS);
          break;
      }
    } catch (e) {
      debugPrint("🗺 Map style error: $e");
    }
  }

  Future<void> onMapCreated(mapbox.MapboxMap map) async {
    mapboxMap = map;

    try {
      await _applyMapStyle();

      mapboxMap?.location.updateSettings(
        mapbox.LocationComponentSettings(enabled: true),
      );

      placeMarkerManager = await mapboxMap!.annotations
          .createPointAnnotationManager();

      tapMarkerManager = await mapboxMap!.annotations
          .createCircleAnnotationManager();

      await _moveCameraToCurrentLocation();

      Future.delayed(const Duration(milliseconds: 500), () async {
        if (isClosed) return;
        if (apiPlaces.isNotEmpty) {
          try {
            await _drawPlaceMarkers(filteredPlaces);
          } catch (e) {
            debugPrint("⚠ Marker draw delayed error ignored: $e");
          }
        }
      });
    } catch (e) {
      debugPrint("🗺 Map init error: $e");
    }
  }

  Future<void> clearRoute() async {
    try {
      if (routeLineManager != null) {
        await routeLineManager!.deleteAll();
      }
    } catch (e) {
      debugPrint("Clear route error: $e");
    }
  }

  Future<Uint8List?> _downloadImage(String url) async {
    if (_markerImageCache.containsKey(url)) {
      return _markerImageCache[url];
    }

    try {
      final res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        _markerImageCache[url] = res.bodyBytes;
        return res.bodyBytes;
      }
    } catch (_) {}
    return null;
  }

  String markerLabelFromCategory(String raw) {
    final v = raw.trim();

    switch (v) {
      case "Epic Photo Spot":
        return "✨ Epic";
      case "Hike":
        return "🥾 Hike";
      case "Campground":
        return "🏕 Camp";
      case "Freedom Camping":
        return "📸 Freedom";
      default:
        if (v.isEmpty) return "Spot";
        if (v.length > 12) return "${v.substring(0, 12)}…";
        return v;
    }
  }

  Future<Uint8List> _makeCircularImage(Uint8List bytes) async {
    final codec = await ui.instantiateImageCodec(
      bytes,
      targetWidth: 96,
      targetHeight: 96,
    );
    final frame = await codec.getNextFrame();
    final ui.Image image = frame.image;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint()..isAntiAlias = true;

    final size = 96.0;
    final radius = size / 2;

    canvas.clipPath(
      Path()..addOval(
        Rect.fromCircle(center: Offset(radius, radius), radius: radius),
      ),
    );

    canvas.drawImage(image, Offset.zero, paint);

    final picture = recorder.endRecording();
    final img = await picture.toImage(96, 96);
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);

    return byteData!.buffer.asUint8List();
  }

  Future<void> _moveCameraToCurrentLocation() async {
    if (!prefs.locationEnabled.value) {
      debugPrint("🚫 Location access disabled by user");
      return;
    }

    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        debugPrint("❌ Location service disabled at OS level");
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        debugPrint("❌ Location permission denied");
        return;
      }

      userPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      userPoint = mapbox.Point(
        coordinates: mapbox.Position(
          userPosition!.longitude,
          userPosition!.latitude,
        ),
      );

      _updateNearbyPlaces();

      await mapboxMap?.setCamera(
        mapbox.CameraOptions(center: userPoint, zoom: 13),
      );
    } catch (e) {
      debugPrint("📍 Location error: $e");
    }
  }

  Future<void> fetchApprovedLocations() async {
    try {
      final token = await StorageService.getToken();

      if (token == null || token.isEmpty) {
        debugPrint("🚫 No token, skipping map fetch");
        return;
      }

      isLoading.value = true;

      final response = await _dio.get('location/all');

      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
          response.data['data']['result'],
        );

        final approved = data.where((e) => e['status'] == 'APPROVED').toList();

        apiPlaces.value = approved;

        await _mapCacheBox.put('approved_locations', approved);

        _updateNearbyPlaces();

        if (mapboxMap != null) {
          await _drawPlaceMarkers(filteredPlaces);
        }
      }
    } catch (e) {
      debugPrint("🗺 Map fetch error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _drawPlaceMarkers(List<Map<String, dynamic>> places) async {
    if (placeMarkerManager == null || mapboxMap == null || isClosed) return;

    await placeMarkerManager!.deleteAll();

    for (final place in places) {
      final coords = place['coordinates']?['coordinates'];
      if (coords == null || coords.length < 2) continue;

      final double lng = (coords[0] as num).toDouble();
      final double lat = (coords[1] as num).toDouble();

      final List images = place['imageUrl'] ?? [];
      if (images.isEmpty) continue;

      final String imageUrl = images.first.toString();
      final rawBytes = await _downloadImage(imageUrl);
      if (rawBytes == null) continue;

      final rawCat = (place['category'] ?? '').toString();
      final label = markerLabelFromCategory(rawCat);
      final pillColor = _pillColorForCategory(rawCat);

      final markerKey = "${place['_id']}|$label|$imageUrl";

      Uint8List markerPng;
      if (_premiumMarkerCache.containsKey(markerKey)) {
        markerPng = _premiumMarkerCache[markerKey]!;
      } else {
        markerPng = await _buildPremiumMarkerPng(
          photoBytes: rawBytes,
          label: label,
          pillColor: pillColor,
        );
        _premiumMarkerCache[markerKey] = markerPng;
      }

      final String imageId = "premium_${place['_id']}";

      // try {
      //   await mapboxMap!.style.addStyleImage(
      //     imageId,
      //     1.0,
      //     mapbox.MbxImage(width: 220, height: 150, data: markerPng),
      //     false,
      //     [],
      //     [],
      //     null,
      //   );
      // } catch (_) {}

      try {
        await mapboxMap!.style.addStyleImage(
          imageId,
          1.0,
          mapbox.MbxImage(
            width: 150,
            height: 110,
            data: markerPng,
          ),
          false,
          [],
          [],
          null,
        );
      } catch (_) {}


      await placeMarkerManager!.create(
        mapbox.PointAnnotationOptions(
          geometry: mapbox.Point(coordinates: mapbox.Position(lng, lat)),
          iconImage: imageId,
          iconSize: 0.9,
        ),
      );
    }
  }

  void onMarkerTap(Map<String, dynamic> place) {
    selectedPlace.value = place;

    final coords = place['coordinates']['coordinates'];
    final lng = (coords[0] as num).toDouble();
    final lat = (coords[1] as num).toDouble();

    mapboxMap?.setCamera(
      mapbox.CameraOptions(
        center: mapbox.Point(coordinates: mapbox.Position(lng, lat)),
        zoom: 15,
      ),
    );

    Get.bottomSheet(
      const PlaceDetailsSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  // Future<void> handleTap(mapbox.MapContentGestureContext context) async {
  //   final point = context.point;
  //   if (tapMarkerManager == null) return;
  //
  //   selectedLocation.value = point;
  //
  //   if (_pinOuter != null) await tapMarkerManager!.delete(_pinOuter!);
  //   if (_pinInner != null) await tapMarkerManager!.delete(_pinInner!);
  //
  //   _pinOuter = await tapMarkerManager!.create(
  //     mapbox.CircleAnnotationOptions(
  //       geometry: point,
  //       circleRadius: 12,
  //       circleColor: Colors.white.value,
  //     ),
  //   );
  //
  //   _pinInner = await tapMarkerManager!.create(
  //     mapbox.CircleAnnotationOptions(
  //       geometry: point,
  //       circleRadius: 7,
  //       circleColor: Colors.red.value,
  //     ),
  //   );
  // }

  Future<void> handleTap(mapbox.MapContentGestureContext context) async {
    try {
      if (mapboxMap == null) return;

      if (tapMarkerManager == null) {
        tapMarkerManager = await mapboxMap!.annotations.createCircleAnnotationManager();
      }

      final point = context.point;
      selectedLocation.value = point;

      await tapMarkerManager?.deleteAll();

      _pinOuter = await tapMarkerManager?.create(
        mapbox.CircleAnnotationOptions(
          geometry: point,
          circleRadius: 10,
          circleColor: Colors.white.value,
          circleStrokeWidth: 2,
          circleStrokeColor: Colors.black.value,
        ),
      );

      _pinInner = await tapMarkerManager?.create(
        mapbox.CircleAnnotationOptions(
          geometry: point,
          circleRadius: 5,
          circleColor: Colors.red.value,
        ),
      );
    } catch (e) {
      debugPrint("📍 Map Tap Error: $e");
      tapMarkerManager = await mapboxMap?.annotations.createCircleAnnotationManager();
    }
  }

  Future<void> goToMyLocation() async {
    if (!prefs.locationEnabled.value) {
      Get.snackbar(
        "Location Disabled",
        "Turn on location access from Preferences",
      );
      return;
    }

    await _moveCameraToCurrentLocation();
  }

  Future<String> resolveAddressFromCoordinates(double lat, double lng) async {
    final key = "$lat,$lng";
    if (_resolvedAddresses.containsKey(key)) {
      return _resolvedAddresses[key]!;
    }

    try {
      final placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isEmpty) return "Unknown Location";

      final p = placemarks.first;
      final parts = <String>[
        if (p.name != null && p.name!.isNotEmpty) p.name!,
        if (p.locality != null && p.locality!.isNotEmpty) p.locality!,
        if (p.administrativeArea != null && p.administrativeArea!.isNotEmpty)
          p.administrativeArea!,
        if (p.country != null && p.country!.isNotEmpty) p.country!,
      ];

      final address = parts.isEmpty ? "Unknown Location" : parts.join(', ');
      _resolvedAddresses[key] = address;
      return address;
    } catch (_) {
      return "Unknown Location";
    }
  }

  String calculateDistance(double lat, double lng) {
    if (!prefs.locationEnabled.value || userPosition == null) {
      return "---";
    }

    final meters = Geolocator.distanceBetween(
      userPosition!.latitude,
      userPosition!.longitude,
      lat,
      lng,
    );

    return meters < 1000
        ? "${meters.toInt()}m"
        : "${(meters / 1000).toStringAsFixed(1)}km";
  }

  void goToContribute() {
    if (selectedLocation.value == null) {
      Get.snackbar("Error", "Please tap on map first");
      return;
    }

    Get.delete<SubmissionController>(force: true);
    final sub = Get.put(SubmissionController(), permanent: true);

    sub.lat.value = selectedLocation.value!.coordinates.lat.toDouble();
    sub.lng.value = selectedLocation.value!.coordinates.lng.toDouble();

    Get.toNamed(AppRoutes.mySubmission);
  }

  void goToContributeCurrentLocation() {
    if (userPosition == null) {
      Get.snackbar("Error", "Current location not found. Please wait or check GPS.");
      return;
    }

    Get.delete<SubmissionController>(force: true);
    final sub = Get.put(SubmissionController(), permanent: true);

    sub.lat.value = userPosition!.latitude;
    sub.lng.value = userPosition!.longitude;

    Get.toNamed(AppRoutes.mySubmission);
  }

  Future<void> startVoiceSearch() async {
    final status = await Permission.microphone.request();
    if (!status.isGranted) return;

    final ok = await _speech.initialize();
    if (!ok) return;

    isListening.value = true;
    _speech.listen(
      onResult: (val) {
        searchQuery.value = val.recognizedWords;
        if (val.finalResult) isListening.value = false;
      },
    );
  }

  void stopListening() {
    _speech.stop();
    isListening.value = false;
  }

  Future<void> openNavigation(double lat, double lng) async {
    if (userPosition == null) return;

    final originLat = userPosition!.latitude;
    final originLng = userPosition!.longitude;

    final uri = Uri.parse(
      "https://www.mapbox.com/directions/"
      "?origin=$originLat,$originLng"
      "&destination=$lat,$lng"
      "&profile=driving",
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar("Navigation error", "Mapbox navigation app not available");
    }
  }

  String getTravelDuration(double lat, double lng, bool isWalking) {
    if (userPosition == null) return "---";

    final meters = Geolocator.distanceBetween(
      userPosition!.latitude,
      userPosition!.longitude,
      lat,
      lng,
    );

    final km = meters / 1000;
    final speed = isWalking ? 5.0 : 50.0;

    final minutes = ((km / speed) * 60).round();

    if (minutes < 60) {
      return "$minutes min";
    }

    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;

    return "${hours}h ${remainingMinutes}m";
  }

  Future<void> zoomIn() async {
    final state = await mapboxMap?.getCameraState();
    if (state == null) return;
    mapboxMap?.setCamera(mapbox.CameraOptions(zoom: state.zoom + 1));
  }

  Future<void> zoomOut() async {
    final state = await mapboxMap?.getCameraState();
    if (state == null) return;
    mapboxMap?.setCamera(mapbox.CameraOptions(zoom: state.zoom - 1));
  }

  Future<void> drawRouteTo(double destLat, double destLng) async {
    if (userPosition == null || mapboxMap == null) return;

    final origin = "${userPosition!.longitude},${userPosition!.latitude}";
    final destination = "$destLng,$destLat";

    final url =
        "https://api.mapbox.com/directions/v5/mapbox/driving/"
        "$origin;$destination"
        "?geometries=geojson"
        "&overview=full"
        "&access_token=${ApiConstants.mapboxToken}";

    try {
      final response = await dio.Dio().get(url);
      final geometry = response.data['routes'][0]['geometry']['coordinates'];

      final points = geometry
          .map<mapbox.Position>((c) => mapbox.Position(c[0], c[1]))
          .toList();

      routeLineManager ??= await mapboxMap!.annotations
          .createPolylineAnnotationManager();

      await routeLineManager!.deleteAll();

      await routeLineManager!.create(
        mapbox.PolylineAnnotationOptions(
          geometry: mapbox.LineString(coordinates: points),
          lineColor: Colors.red.value,
          lineWidth: 5,
        ),
      );

      mapboxMap!.setCamera(
        mapbox.CameraOptions(
          center: mapbox.Point(coordinates: mapbox.Position(destLng, destLat)),
          zoom: 14,
        ),
      );
    } catch (e) {
      debugPrint("Route error: $e");
    }
  }

  void _updateNearbyPlaces() {
    if (!prefs.locationEnabled.value || userPosition == null) {
      nearYouPlaces.clear();
      return;
    }

    nearYouPlaces.value = apiPlaces.where((place) {
      final coords = place['coordinates']['coordinates'];
      final lat = (coords[1] as num).toDouble();
      final lng = (coords[0] as num).toDouble();

      final meters = Geolocator.distanceBetween(
        userPosition!.latitude,
        userPosition!.longitude,
        lat,
        lng,
      );

      return meters <= 20000;
    }).toList();
  }

  void updateSearch(String val) {
    searchQuery.value = val;
    _refreshMarkers();
  }

  void updateCategory(String val) {
    selectedFilter.value = val;
    _refreshMarkers();
  }

  void changeTab(int index) => currentIndex.value = index;

  // Future<Uint8List> _buildPremiumMarkerPng({
  //   required Uint8List photoBytes,
  //   required String label,
  //   required Color pillColor,
  // }) async {
  //   const int w = 100;
  //   const int h = 70;
  //
  //   final codec = await ui.instantiateImageCodec(
  //     photoBytes,
  //     targetWidth: 70,
  //     targetHeight: 70,
  //   );
  //   final frame = await codec.getNextFrame();
  //   final ui.Image photo = frame.image;
  //
  //   final recorder = ui.PictureRecorder();
  //   final canvas = Canvas(recorder);
  //   final paint = Paint()..isAntiAlias = true;
  //
  //   final pillRect = RRect.fromRectAndRadius(
  //     const Rect.fromLTWH(18, 8, w - 28.0, 44),
  //     const Radius.circular(18),
  //   );
  //
  //   paint.color = pillColor.withValues(alpha: 0.95);
  //   canvas.drawRRect(pillRect, paint);
  //
  //   paint
  //     ..style = PaintingStyle.stroke
  //     ..strokeWidth = 2
  //     ..color = Colors.white.withValues(alpha: 0.85);
  //   canvas.drawRRect(pillRect, paint);
  //   paint.style = PaintingStyle.fill;
  //
  //   final pb =
  //       ui.ParagraphBuilder(
  //           ui.ParagraphStyle(
  //             textAlign: TextAlign.center,
  //             fontSize: 16,
  //             maxLines: 1,
  //             ellipsis: '…',
  //           ),
  //         )
  //         ..pushStyle(
  //           ui.TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
  //         )
  //         ..addText(label);
  //
  //   final paragraph = pb.build()
  //     ..layout(const ui.ParagraphConstraints(width: w - 36.0));
  //   canvas.drawParagraph(paragraph, const Offset(18, 18));
  //
  //   const double imgSize = 90;
  //   const double imgX = (w - imgSize) / 2;
  //   const double imgY = 58;
  //
  //   paint.color = Colors.black.withValues(alpha: 0.25);
  //   canvas.drawRRect(
  //     RRect.fromRectAndRadius(
  //       Rect.fromLTWH(imgX + 2, imgY + 6, imgSize, imgSize),
  //       const Radius.circular(18),
  //     ),
  //     paint,
  //   );
  //
  //   paint.color = Colors.white;
  //   canvas.drawRRect(
  //     RRect.fromRectAndRadius(
  //       Rect.fromLTWH(imgX, imgY, imgSize, imgSize),
  //       const Radius.circular(18),
  //     ),
  //     paint,
  //   );
  //
  //   final inner = RRect.fromRectAndRadius(
  //     Rect.fromLTWH(imgX + 5, imgY + 5, imgSize - 10, imgSize - 10),
  //     const Radius.circular(14),
  //   );
  //
  //   canvas.save();
  //   canvas.clipRRect(inner);
  //
  //   final src = Rect.fromLTWH(
  //     0,
  //     0,
  //     photo.width.toDouble(),
  //     photo.height.toDouble(),
  //   );
  //   final dst = Rect.fromLTWH(imgX + 5, imgY + 5, imgSize - 10, imgSize - 10);
  //   canvas.drawImageRect(photo, src, dst, Paint()..isAntiAlias = true);
  //
  //   canvas.restore();
  //
  //   final path = Path();
  //   final tailTop = imgY + imgSize;
  //   path.moveTo(w / 2 - 12, tailTop + 6);
  //   path.lineTo(w / 2 + 12, tailTop + 6);
  //   path.lineTo(w / 2, tailTop + 26);
  //   path.close();
  //
  //   paint.color = Colors.white;
  //   canvas.drawPath(path, paint);
  //
  //   final picture = recorder.endRecording();
  //   final img = await picture.toImage(w, h);
  //   final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
  //   return byteData!.buffer.asUint8List();
  // }

  Future<Uint8List> _buildPremiumMarkerPng({
    required Uint8List photoBytes,
    required String label,
    required Color pillColor,
  }) async {
    const int w = 150;
    const int h = 110;

    final codec = await ui.instantiateImageCodec(
      photoBytes,
      targetWidth: 50,
      targetHeight: 50,
    );
    final frame = await codec.getNextFrame();
    final ui.Image photo = frame.image;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint()..isAntiAlias = true;


    final pillRect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(10, 5, w - 20.0, 32),
      const Radius.circular(12),
    );

    paint.color = pillColor.withValues(alpha: 0.95);
    canvas.drawRRect(pillRect, paint);

    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = Colors.white.withValues(alpha: 0.85);
    canvas.drawRRect(pillRect, paint);
    paint.style = PaintingStyle.fill;

    final pb = ui.ParagraphBuilder(
      ui.ParagraphStyle(
        textAlign: TextAlign.center,
        fontSize: 12,
        maxLines: 1,
        ellipsis: '…',
      ),
    )
      ..pushStyle(
        ui.TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
      )
      ..addText(label);

    final paragraph = pb.build()
      ..layout(const ui.ParagraphConstraints(width: w - 24.0));
    canvas.drawParagraph(paragraph, const Offset(12, 12));

    const double imgSize = 65;
    const double imgX = (w - imgSize) / 2;
    const double imgY = 42;

    paint.color = Colors.black.withValues(alpha: 0.2);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(imgX + 1, imgY + 3, imgSize, imgSize),
        const Radius.circular(12),
      ),
      paint,
    );

    paint.color = Colors.white;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(imgX, imgY, imgSize, imgSize),
        const Radius.circular(12),
      ),
      paint,
    );

    final inner = RRect.fromRectAndRadius(
      Rect.fromLTWH(imgX + 3, imgY + 3, imgSize - 6, imgSize - 6),
      const Radius.circular(10),
    );

    canvas.save();
    canvas.clipRRect(inner);

    final src = Rect.fromLTWH(0, 0, photo.width.toDouble(), photo.height.toDouble());
    final dst = Rect.fromLTWH(imgX + 3, imgY + 3, imgSize - 6, imgSize - 6);
    canvas.drawImageRect(photo, src, dst, Paint()..isAntiAlias = true);

    canvas.restore();

    final path = Path();
    final tailTop = imgY + imgSize;
    path.moveTo(w / 2 - 8, tailTop + 2);
    path.lineTo(w / 2 + 8, tailTop + 2);
    path.lineTo(w / 2, tailTop + 15);
    path.close();

    paint.color = Colors.white;
    canvas.drawPath(path, paint);

    final picture = recorder.endRecording();
    final img = await picture.toImage(w, h);
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  Color _pillColorForCategory(String raw) {
    final v = raw.trim();
    if (v == "Epic Photo Spot") return const Color(0xFF6C63FF);
    if (v == "Hike") return const Color(0xFF2D9CDB);
    if (v == "Campground") return const Color(0xFF2DBD7F);
    if (v == "Photo Spot") return const Color(0xFFF2994A);
    return const Color(0xFF2DBD7F);
  }
}
