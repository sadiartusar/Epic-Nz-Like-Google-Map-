import 'package:flutter/material.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_colors.dart';

class AuthDivider extends StatelessWidget {
  const AuthDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Expanded(
          child: Divider(color: isDark ? Colors.white24 : AppColors.greyLight),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'Or Continue With',
            style: AppTextStyles.body.copyWith(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.7)
                  : AppColors.textSecondaryLight,
            ),
          ),
        ),
        Expanded(
          child: Divider(color: isDark ? Colors.white24 : AppColors.greyLight),
        ),
      ],
    );
  }
}
