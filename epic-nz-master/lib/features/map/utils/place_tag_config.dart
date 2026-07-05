import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/place_tag.dart';

class PlaceTagConfig {
  final String label;
  final IconData icon;
  final Color lightColor;
  final List<Color> darkGradient;

  const PlaceTagConfig({
    required this.label,
    required this.icon,
    required this.lightColor,
    required this.darkGradient,
  });
}

const Map<PlaceTag, PlaceTagConfig> placeTagConfig = {
  PlaceTag.photo: PlaceTagConfig(
    label: 'Photo Spot',
    icon: Icons.camera_alt,
    lightColor: AppColors.green,
    darkGradient: [Color(0xFF1E3A34), Color(0xFF0E1F1B)],
  ),
  PlaceTag.camping: PlaceTagConfig(
    label: 'Campground',
    icon: Icons.local_fire_department,
    lightColor: Color(0xFF5B6CFF),
    darkGradient: [Color(0xFF2A2E5D), Color(0xFF14162F)],
  ),
  PlaceTag.hikes: PlaceTagConfig(
    label: 'Hikes',
    icon: Icons.hiking,
    lightColor: Color(0xFF58B5E0),
    darkGradient: [Color(0xFF1D3E4C), Color(0xFF0C1E25)],
  ),
  PlaceTag.epic: PlaceTagConfig(
    label: 'Epic Now',
    icon: Icons.auto_awesome,
    lightColor: Color(0xFF9B59B6),
    darkGradient: [Color(0xFF3E1F4A), Color(0xFF1A0C20)],
  ),
};
