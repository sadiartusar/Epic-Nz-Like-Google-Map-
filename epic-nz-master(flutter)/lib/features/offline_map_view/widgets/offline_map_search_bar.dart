import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class OfflineMapSearchBar extends StatelessWidget {
  const OfflineMapSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.35),
              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: const [
                Icon(Icons.search, color: Colors.white70),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Search spots, hikes, camping.',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                Icon(Icons.mic, color: AppColors.green),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
