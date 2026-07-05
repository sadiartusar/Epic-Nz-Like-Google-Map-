import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:geolocator/geolocator.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../routes/app_routes.dart';
import '../controller/preferences_controller.dart';
import '../widgets/preference_card.dart';
import '../widgets/preference_toggle_tile.dart';
import '../widgets/preference_nav_tile.dart';

class PreferencesScreen extends StatelessWidget {
  const PreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final PreferencesController controller = Get.find<PreferencesController>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppBackButton(),

              const SizedBox(height: 24),

              Text(
                'Tailor Your Trip',
                style: AppTextStyles.title2.copyWith(
                  color: isDark ? Colors.white : AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Select what you want to see on the map.\nWe’ll customize your feed.',
                style: AppTextStyles.body.copyWith(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.7)
                      : AppColors.textSecondaryLight,
                  fontSize: 16
                ),
              ),

              const SizedBox(height: 24),

              Obx(() {
                return GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    PreferenceCard(
                      title: 'Epic Spots',
                      imageUrl:
                          'https://images.unsplash.com/photo-1501785888041-af3ef285b470',
                      selected: controller.isSelected('Epic Photo Spot'),
                      onTap: () => controller.toggle('Epic Photo Spot'),
                    ),
                    PreferenceCard(
                      title: 'Hikes',
                      imageUrl:
                          'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee',
                      selected: controller.isSelected('Hike'),
                      onTap: () => controller.toggle('Hike'),
                    ),
                    PreferenceCard(
                      title: 'Campgrounds',
                      imageUrl:
                          'https://images.unsplash.com/photo-1504280390367-361c6d9f38f4',
                      selected: controller.isSelected('Campground'),
                      onTap: () => controller.toggle('Campground'),
                    ),
                    PreferenceCard(
                      title: 'Freedom Camping',
                      imageUrl:
                          'https://images.unsplash.com/photo-1507525428034-b723cf961d3e',
                      selected: controller.isSelected('Freedom Camping'),
                      onTap: () => controller.toggle('Freedom Camping'),
                    ),
                  ],
                );
              }),

              const SizedBox(height: 32),

              Text(
                'Preferences',
                style: AppTextStyles.h1.copyWith(
                  color: isDark ? Colors.white : AppColors.textPrimaryLight,
                  fontSize: 18
                ),
              ),
              const SizedBox(height: 16),

              PreferenceToggleTile(
                title: 'Push Notification',
                subtitle: 'Receive updates & messages',
                value: controller.notificationsEnabled,

                onDisabled: () {
                  showNotificationDisabledDialog(context);
                },

                onEnabled: () async {
                  await FirebaseMessaging.instance.requestPermission();
                },
              ),

              const SizedBox(height: 12),

              PreferenceToggleTile(
                title: 'Location Access',
                subtitle: 'Discover nearby spots',
                value: controller.locationEnabled,

                onDisabled: () {
                  showLocationDisabledDialog(context);
                },

                onEnabled: () async {
                  await Geolocator.requestPermission();
                },
              ),

              const SizedBox(height: 12),

              const PreferenceNavTile(
                title: 'App Language',
                value: 'English (NZ)',
              ),

              const SizedBox(height: 32),

              PrimaryButton(
                text: 'Save Changes',
                onTap: () {
                  Get.offAllNamed(AppRoutes.main);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showNotificationDisabledDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: isDark ? 0.4 : 0.2),
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : Colors.white.withValues(alpha: 0.65),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.15)
                        : Colors.white.withValues(alpha: 0.4),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.notifications_off_rounded,
                      size: 40,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),

                    const SizedBox(height: 12),

                    Text(
                      "Notifications Disabled",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "You won’t receive any updates until notifications are turned ON again.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.4,
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.75)
                            : Colors.black.withValues(alpha: 0.7),
                      ),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: isDark
                              ? Colors.white.withValues(alpha: 0.12)
                              : Colors.black.withValues(alpha: 0.06),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: Get.back,
                        child: Text(
                          "OK",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
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

  void showLocationDisabledDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.3),
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : Colors.white.withValues(alpha: 0.75),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.15)
                        : Colors.white.withValues(alpha: 0.4),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.location_off,
                      color: isDark ? Colors.white : Colors.black87,
                      size: 36,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Location Disabled",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Nearby places and weather info won’t be available.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.75)
                            : Colors.black.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: Get.back,
                      child: Text(
                        "OK",
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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
}
