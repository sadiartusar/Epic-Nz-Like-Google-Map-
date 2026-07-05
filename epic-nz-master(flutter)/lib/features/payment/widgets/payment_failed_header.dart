import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class PaymentFailedHeader extends StatelessWidget {
  const PaymentFailedHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Container(
          height: 90,
          width: 90,
          decoration: BoxDecoration(
            color: Colors.red.withValues(alpha: isDark ? 0.15 : 0.08),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.close, color: Colors.red, size: 42),
        ),
        const SizedBox(height: 20),
        Text('Payment Failed', style: AppTextStyles.h1),
        const SizedBox(height: 8),
        Text(
          "We couldn't process your payment for the\nAdventure Pro annual subscription.",
          textAlign: TextAlign.center,
          style: AppTextStyles.body.copyWith(color: AppColors.grey),
        ),
      ],
    );
  }
}
