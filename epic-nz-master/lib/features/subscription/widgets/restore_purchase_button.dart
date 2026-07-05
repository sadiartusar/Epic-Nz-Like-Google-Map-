import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class RestorePurchaseButton extends StatelessWidget {
  const RestorePurchaseButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      child: Text(
        'Restore Purchase',
        style: AppTextStyles.body.copyWith(
          color: AppColors.green,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
