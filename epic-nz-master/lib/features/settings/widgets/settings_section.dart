import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/controller/theme_controller.dart';
import '../../../routes/app_routes.dart';
import 'settings_tile.dart';
import '../../../core/theme/app_colors.dart';
import '../controller/settings_controller.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final settingsController = Get.put(SettingsController());

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        SettingsTile(
          icon: Icons.language,
          title: 'Language',
          trailing: const Text('English'),
          onTap: () {},
        ),

        Obx(
          () => SettingsTile(
            icon: Icons.dark_mode,
            title: 'Theme',
            trailing: Switch(
              value: themeController.isDark,
              activeThumbColor: AppColors.green,
              onChanged: themeController.toggleTheme,
            ),
          ),
        ),

        SettingsTile(
          icon: Icons.favorite_outline,
          title: 'Preferences',
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Get.toNamed(AppRoutes.preferences);
          },
        ),

        Obx(
          () => SettingsTile(
            icon: Icons.map,
            title: 'Map',
            trailing: Text(settingsController.mapViewLabel),
            onTap: () {
              _showMapViewDialog(context, settingsController, isDark);
            },
          ),
        ),

        SettingsTile(
          icon: Icons.mail_outline,
          title: 'Write Feedback',
          onTap: () {
            Get.toNamed(AppRoutes.sendFeedback);
          },
        ),
      ],
    );
  }

  void _showMapViewDialog(
    BuildContext context,
    SettingsController controller,
    bool isDark,
  ) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.35),
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : Colors.white.withValues(alpha: 0.75),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.25),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Choose Map View",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 16),

                    _mapOption(
                      title: "Default",
                      selected:
                          controller.mapView.value == MapViewType.defaultView,
                      onTap: () {
                        controller.setMapView(MapViewType.defaultView);
                        Get.back();
                      },
                    ),

                    _mapOption(
                      title: "Satellite",
                      selected:
                          controller.mapView.value == MapViewType.satellite,
                      onTap: () {
                        controller.setMapView(MapViewType.satellite);
                        Get.back();
                      },
                    ),

                    _mapOption(
                      title: "Terrain",
                      selected: controller.mapView.value == MapViewType.terrain,
                      onTap: () {
                        controller.setMapView(MapViewType.terrain);
                        Get.back();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _mapOption({
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(title),
      trailing: selected
          ? const Icon(Icons.check_circle, color: AppColors.green)
          : const Icon(Icons.circle_outlined),
      onTap: onTap,
    );
  }
}
