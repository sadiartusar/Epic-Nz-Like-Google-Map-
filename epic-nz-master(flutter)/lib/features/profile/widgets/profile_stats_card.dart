import 'package:epic_nz/core/theme/app_colors.dart';
import 'package:epic_nz/core/theme/app_text_styles.dart';
import 'package:epic_nz/features/profile/profile_controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileStatsCard extends StatelessWidget {
  const ProfileStatsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.greenDark.withValues(alpha: 0.3)
            : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.green.withValues(alpha: 0.2)),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
      ),
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _statItem('Submissions', controller.totalSubmissions.value),
            _statItem('Saved', controller.totalSavedCount.value),
            _statItem(
              'Avg Ratings',
              controller.userAvgRating.value,
              suffix: const Icon(Icons.star, size: 16, color: Colors.amber),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statItem(String label, String value, {Widget? suffix}) {
    return Column(
      children: [
        Text(value, style: AppTextStyles.h1),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: AppTextStyles.h2),
            if (suffix != null) ...[const SizedBox(width: 4), suffix],
          ],
        ),
      ],
    );
  }
}
