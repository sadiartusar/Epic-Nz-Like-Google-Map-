import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class ProfileSettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool showDivider;

  const ProfileSettingsTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.green.withValues(alpha: 0.15),
                  child: Icon(icon, color: AppColors.green, size: 20),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.h1.copyWith(
                      color: isDark ? Colors.white : AppColors.textPrimaryLight,
                    ),
                  ),
                ),

                Icon(
                  Icons.chevron_right,
                  color: isDark ? Colors.white54 : AppColors.grey,
                ),
              ],
            ),
          ),

          if (showDivider)
            Padding(
              padding: const EdgeInsets.only(left: 64),
              child: Divider(
                height: 1,
                thickness: 0.6,
                color: isDark ? Colors.white12 : AppColors.greyLight,
              ),
            ),
        ],
      ),
    );
  }
}
