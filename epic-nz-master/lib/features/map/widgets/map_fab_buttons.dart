import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../map_controller/map_controller.dart';

class MapFabButtons extends StatelessWidget {
  const MapFabButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MapController>();

    return Positioned(
      right: 14,
      bottom: 285,
      child: Column(
        children: [
          _fab(icon: Icons.add, onTap: () => controller.zoomIn()),
          const SizedBox(height: 10),

          _fab(icon: Icons.remove, onTap: () => controller.zoomOut()),
          const SizedBox(height: 14),

          _fab(
            icon: Icons.my_location,
            filled: true,
            onTap: () => controller.goToMyLocation(),
          ),
        ],
      ),
    );
  }

  Widget _fab({
    required IconData icon,
    required VoidCallback onTap,
    bool filled = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 42,
        width: 42,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: filled ? AppColors.green : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 20,
          color: filled ? Colors.white : AppColors.green,
        ),
      ),
    );
  }
}
