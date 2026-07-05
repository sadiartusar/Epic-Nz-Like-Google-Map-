import 'package:flutter/material.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_colors.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const AuthHeader({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),

        Text(
          title,
          style: AppTextStyles.title2.copyWith(
            color: isDark ? Colors.white : AppColors.textPrimaryLight,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          subtitle,
          style: AppTextStyles.body.copyWith(
            color: isDark
                ? Colors.white.withValues(alpha: 0.7)
                : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }
}
