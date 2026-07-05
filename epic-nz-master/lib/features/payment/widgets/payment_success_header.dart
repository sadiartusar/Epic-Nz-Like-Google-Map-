import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class PaymentSuccessHeader extends StatelessWidget {
  const PaymentSuccessHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 90,
          width: 90,
          decoration: BoxDecoration(
            color: AppColors.green.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, color: AppColors.green, size: 42),
        ),
        const SizedBox(height: 20),
        Text('Payment Confirmed!', style: AppTextStyles.h1),
        const SizedBox(height: 8),
        Text(
          'Your Adventure Pro plan is now active\nand ready to use.',
          textAlign: TextAlign.center,
          style: AppTextStyles.body.copyWith(color: AppColors.grey),
        ),
      ],
    );
  }
}
