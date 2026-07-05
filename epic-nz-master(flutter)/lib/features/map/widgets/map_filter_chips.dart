import 'dart:ui';
import 'package:epic_nz/features/map/map_controller/map_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';

class MapFilterChips extends StatefulWidget {
  const MapFilterChips({super.key});

  @override
  State<MapFilterChips> createState() => _MapFilterChipsState();
}

class _MapFilterChipsState extends State<MapFilterChips> {
  String selected = 'All';

  final filters = ['All', 'Epic Photo Spot', 'Hike', 'Freedom Camping', 'Campground'];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: filters.map((item) {
          final isSelected = selected == item;

          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () {
                setState(() => selected = item);
                Get.find<MapController>().updateCategory(item);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      color: isSelected
                          ? AppColors.green.withValues(alpha: 0.85)
                          : (isDark
                                ? Colors.white.withValues(alpha: 0.08)
                                : Colors.white.withValues(alpha: 0.75)),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.green
                            : AppColors.green.withValues(alpha: 0.35),
                        width: 1,
                      ),
                      boxShadow: isDark
                          ? []
                          : [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.12),
                                blurRadius: 18,
                                offset: const Offset(0, 8),
                              ),
                            ],
                    ),
                    child: Text(
                      item,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? Colors.white
                            : (isDark
                                  ? Colors.white.withValues(alpha: 0.85)
                                  : Colors.black),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
