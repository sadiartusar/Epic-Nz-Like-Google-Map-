import 'package:cached_network_image/cached_network_image.dart';
import 'package:epic_nz/core/theme/app_colors.dart';
import 'package:epic_nz/core/theme/app_text_styles.dart';
import 'package:epic_nz/features/home/weather/weather_controller/weather_controller.dart';
import 'package:epic_nz/features/profile/profile_controller/profile_controller.dart';
import 'package:epic_nz/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();
    final weatherController = Get.put(WeatherController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final textColor = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;

    return Obx(() {
      String coverImg = controller.coverPic.value;
      String avatarImg = controller.profilePic.value;
      String name = controller.fullName.value;

      return SizedBox(
        height: 260,
        width: double.infinity,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            SizedBox(
              height: 200,
              width: double.infinity,
              child: coverImg.isNotEmpty
                  ? Image.network(
                      coverImg,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[900],
                        child: const Icon(
                          Icons.image_not_supported,
                          color: Colors.white24,
                        ),
                      ),
                    )
                  : Image.network(
                      'https://images.unsplash.com/photo-1501785888041-af3ef285b470',
                      fit: BoxFit.cover,
                    ),
            ),

            Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.1),
                    Colors.black.withValues(alpha: 0.5),
                  ],
                ),
              ),
            ),

            Positioned(
              left: 24,
              top: 155,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark ? AppColors.green : Colors.white,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: avatarImg.isNotEmpty
                      ? CachedNetworkImageProvider(avatarImg)
                      : const AssetImage('assets/images/profile.png')
                            as ImageProvider,
                ),
              ),
            ),

            Positioned(
              left: 24,
              right: 24,
              top: 200,
              child: Row(
                children: [
                  const SizedBox(width: 95),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name == "Loading..." ? "User" : name,
                          style: AppTextStyles.h1.copyWith(
                            color: isDark
                                ? Colors.white
                                : AppColors.textPrimaryLight,
                            fontSize: 22,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 16,
                              color: AppColors.green,
                            ),
                            const SizedBox(width: 4),
                            Obx(() {
                              if (weatherController.isLoading.value) {
                                return Text(
                                  "Locating...",
                                  style: AppTextStyles.h1.copyWith(
                                    color: textColor,
                                    fontSize: 16,
                                  ),
                                );
                              }
                              final data = weatherController.weather.value;
                              return Text(
                                data?.location ?? "Auckland",
                                style: AppTextStyles.h1.copyWith(
                                  color: textColor,
                                  fontSize: 16,
                                ),
                              );
                            }),
                          ],
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.toNamed(AppRoutes.editProfile),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.1)
                            : Colors.grey[100],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.edit_square,
                        size: 22,
                        color: isDark ? AppColors.green : Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
