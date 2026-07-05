import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class SubscriptionManageTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool danger;
  final VoidCallback? onTap;

  const SubscriptionManageTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.danger = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.green.withValues(alpha: 0.14) : Colors.white,
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
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),

        leading: CircleAvatar(
          backgroundColor: danger
              ? Colors.red.withValues(alpha: 0.15)
              : AppColors.green.withValues(alpha: 0.18),
          child: Icon(icon, color: danger ? Colors.red : AppColors.green),
        ),

        title: Text(
          title,
          style: AppTextStyles.body.copyWith(
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : AppColors.textPrimaryLight,
          ),
        ),

        subtitle: Text(
          subtitle,
          style: AppTextStyles.micro.copyWith(
            color: isDark
                ? Colors.white.withValues(alpha: 0.7)
                : AppColors.textSecondaryLight,
          ),
        ),

        trailing: Icon(
          Icons.chevron_right,
          color: isDark
              ? Colors.white.withValues(alpha: 0.7)
              : AppColors.textSecondaryLight,
        ),
      ),
    );
  }
}
