import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_back_button.dart';

class ManagePlanHeader extends StatelessWidget {
  const ManagePlanHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Row(
          children: [
            const AppBackButton(),
            const Spacer(),
            // Text(
            //   'Restore Purchase',
            //   style: AppTextStyles.body.copyWith(
            //     color: AppColors.green,
            //     fontWeight: FontWeight.w600,
            //   ),
            // ),
          ],
        ),

        const SizedBox(height: 28),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.green.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.verified, size: 16, color: AppColors.green),
              SizedBox(width: 6),
              Text(
                '30-DAY FREE TRIAL',
                style: TextStyle(
                  color: AppColors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 28),

        Text(
          'Start your Adventure',
          textAlign: TextAlign.center,
          style: AppTextStyles.h1.copyWith(
            fontSize: 28,
            color: isDark ? Colors.white : AppColors.textPrimaryLight,
          ),
        ),

        const SizedBox(height: 12),

        Text(
          'Unlock offline maps, hidden photo spots, and live weather updates.',
          textAlign: TextAlign.center,
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
