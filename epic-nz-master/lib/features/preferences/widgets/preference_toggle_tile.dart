import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class PreferenceToggleTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final RxBool value;
  final VoidCallback onDisabled;
  final VoidCallback onEnabled;

  const PreferenceToggleTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onDisabled,
    required this.onEnabled,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.greenDarker : AppColors.greyLight,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Icon(Icons.settings, color: AppColors.green),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.h1.copyWith(
                    fontSize: 18
                  ),
                  ),
                  Text(
                    subtitle,
                    style: AppTextStyles.micro.copyWith(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.6)
                          : AppColors.textSecondaryLight,
                      fontSize: 14
                    ),
                  ),
                ],
              ),
            ),

            Switch(
              value: value.value,
              activeThumbColor: AppColors.green,
              onChanged: (v) {
                value.value = v;
                v ? onEnabled() : onDisabled();
              },
            ),
          ],
        ),
      );
    });
  }
}
