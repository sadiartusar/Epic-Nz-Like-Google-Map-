import 'package:flutter/material.dart';
import '../widgets/offline_map_controls.dart';
import '../widgets/offline_map_header.dart';
import '../widgets/offline_map_search_bar.dart';
import '../widgets/offline_premium_banner.dart';

class OfflineMapViewScreen extends StatelessWidget {
  const OfflineMapViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.black,
            child: const Center(
              child: Text(
                'OFFLINE MAP',
                style: TextStyle(color: Colors.white38),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: const [
                OfflineMapHeader(),
                SizedBox(height: 12),
                OfflineMapSearchBar(),
                SizedBox(height: 12),
                OfflinePremiumBanner(),
              ],
            ),
          ),

          const Positioned(right: 16, bottom: 120, child: OfflineMapControls()),
        ],
      ),
    );
  }
}
