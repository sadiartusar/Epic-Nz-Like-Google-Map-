import 'package:cached_network_image/cached_network_image.dart';
import 'package:epic_nz/features/home/weather/weather_controller/weather_controller.dart';
import 'package:epic_nz/features/profile/profile_controller/profile_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../routes/app_routes.dart';
import '../../notification/notification_controller.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final weatherController = Get.find<WeatherController>();
    final profileController = Get.find<ProfileController>();

    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Obx(() {
              final picUrl = profileController.profilePic.value;

              return Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.green.withValues(alpha: 0.5),
                    width: 1.5,
                  ),
                ),
                child: CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.grey[300],

                  backgroundImage: picUrl.isNotEmpty
                      ? CachedNetworkImageProvider(picUrl)
                      : const AssetImage('assets/images/user.png')
                            as ImageProvider,
                ),
              );
            }),

            const SizedBox(width: 12),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  final name = profileController.fullName.value;
                  return Text(
                    name == "Loading..." || name.isEmpty ? "User" : name,
                    style: AppTextStyles.h1.copyWith(
                      color: textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }),

                const SizedBox(height: 2),

                Obx(() {
                  if (weatherController.isLoading.value) {
                    return Text(
                      "Locating...",
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.grey,
                      ),
                    );
                  }

                  final location =
                      weatherController.weather.value?.location ?? "Auckland";

                  return Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 20,
                        color: AppColors.green,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        location,
                        style: AppTextStyles.micro.copyWith(
                          fontSize: 14,
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),

            const Spacer(),

            GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.notification),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(CupertinoIcons.bell_solid, color: textColor, size: 28),
                  Obx(() {
                    if (!Get.isRegistered<NotificationController>()) {
                      return const SizedBox();
                    }
                    final count =
                        Get.find<NotificationController>().unreadCount.value;
                    if (count == 0) return const SizedBox();

                    return Positioned(
                      right: -4,
                      top: -4,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Center(
                          child: Text(
                            count > 9 ? "9+" : "$count",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
