import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../map/map_controller/map_controller.dart';
import '../../../routes/app_routes.dart';

class NearbySpotsCarousel extends StatefulWidget {
  const NearbySpotsCarousel({super.key});

  @override
  State<NearbySpotsCarousel> createState() => _NearbySpotsCarouselState();
}

class _NearbySpotsCarouselState extends State<NearbySpotsCarousel> {
  final PageController _pageController = PageController(viewportFraction: 0.9);
  Timer? _timer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!_pageController.hasClients) return;

      final controller = Get.find<MapController>();
      if (controller.nearYouPlaces.isEmpty) return;

      _currentIndex = (_currentIndex + 1) % controller.nearYouPlaces.length;

      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mapController = Get.find<MapController>();

    return SizedBox(
      height: 220,
      child: Obx(() {
        if (mapController.nearYouPlaces.isEmpty) {
          return const SizedBox();
        }

        return PageView.builder(
          controller: _pageController,
          itemCount: mapController.nearYouPlaces.length,
          itemBuilder: (context, index) {
            final spot = mapController.nearYouPlaces[index];
            final image = (spot['imageUrl'] as List?)?.isNotEmpty == true
                ? spot['imageUrl'][0]
                : 'https://placehold.jp/600x400.png';

            return GestureDetector(
              onTap: () {
                Get.toNamed(AppRoutes.spotDetail, arguments: spot);
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(26),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(image),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(26),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.75),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 20,
                      right: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            spot['name'] ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            spot['category'] ?? '',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
