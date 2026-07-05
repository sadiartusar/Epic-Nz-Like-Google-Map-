import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:epic_nz/features/home/weather/model/weather_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../../routes/app_routes.dart';

class DetailHeader extends StatefulWidget {
  final VoidCallback onBack;
  final List imageUrls;
  final String name;
  final String address;
  final WeatherModel? weather;

  const DetailHeader({
    super.key,
    required this.onBack,
    required this.imageUrls,
    required this.name,
    required this.address,
    this.weather,
  });

  @override
  State<DetailHeader> createState() => _DetailHeaderState();
}

class _DetailHeaderState extends State<DetailHeader> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    if (widget.imageUrls.length > 1) {
      _timer = Timer.periodic(const Duration(seconds: 4), (_) {
        if (!_pageController.hasClients) return;

        final next = (_currentIndex + 1) % widget.imageUrls.length;
        _pageController.animateToPage(
          next,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  Future<void> _sharePlace() async {
    debugPrint("🚀 Sharing spot");

    final String spotId = widget.name;

    final String shareUrl = "https://epicnz.com/spot/$spotId";

    final String shareText =
        '''
📍 ${widget.name}

📌 ${widget.address}

Open in Epic NZ:
$shareUrl
''';

    await Share.share(shareText, subject: widget.name);

    debugPrint("✅ Share sheet opened");
  }

  final AppLinks _appLinks = AppLinks();

  void _initDeepLinks() {
    _appLinks.uriLinkStream.listen((Uri uri) {
      debugPrint("🔗 Deep link received: $uri");

      if (uri.pathSegments.contains('spot')) {
        final spotId = uri.pathSegments.last;

        Get.toNamed(AppRoutes.spotDetail, arguments: {'spotId': spotId});
      }
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
    final List images = widget.imageUrls.isNotEmpty
        ? widget.imageUrls
        : ['https://placehold.jp/600x400.png'];

    return Stack(
      children: [
        SizedBox(
          height: 350,
          width: double.infinity,
          child: PageView.builder(
            controller: _pageController,
            itemCount: images.length,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            itemBuilder: (context, index) {
              return Image.network(
                images[index],
                fit: BoxFit.cover,
                width: double.infinity,
              );
            },
          ),
        ),

        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: widget.onBack,
                  child: const CircleAvatar(
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.arrow_back, color: Colors.white),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    debugPrint("🔥 Share button tapped");
                    _sharePlace();
                  },
                  child: const CircleAvatar(
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.share_rounded, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),

        if (images.length > 1)
          Positioned(
            bottom: 110,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                images.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 6,
                  width: _currentIndex == index ? 18 : 6,
                  decoration: BoxDecoration(
                    color: _currentIndex == index
                        ? Colors.white
                        : Colors.white54,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),

        Positioned(
          bottom: 25,
          left: 20,
          right: 20,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.greenAccent,
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            widget.address,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                              height: 1.25,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  children: [
                    Text(
                      widget.weather != null
                          ? "${widget.weather!.temperature.toStringAsFixed(0)}°C"
                          : "--°C",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.weather != null
                          ? "${widget.weather!.humidity}% 💧"
                          : "0% 💧",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
