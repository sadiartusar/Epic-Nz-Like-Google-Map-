import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.white,
          borderRadius: BorderRadius.circular(18),

          boxShadow: isDark
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.green.withValues(alpha: 0.15),
              child: Icon(icon, color: AppColors.green),
            ),

            const SizedBox(width: 14),

            Text(
              title,
              style: AppTextStyles.body.copyWith(
                color: isDark ? Colors.white : AppColors.textPrimaryLight,
                fontSize: 16,
              ),
            ),

            const Spacer(),

            trailing ??
                Icon(
                  Icons.chevron_right,
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.7)
                      : AppColors.textSecondaryLight,
                ),
          ],
        ),
      ),
    );
  }
}
