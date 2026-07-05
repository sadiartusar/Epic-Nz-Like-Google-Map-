import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class SystemStatusChip extends StatelessWidget {
  const SystemStatusChip({super.key});

  @override
  Widget build(BuildContext context) {
    return Chip(
      backgroundColor: AppColors.green.withValues(alpha: 0.15),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),

      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),

      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, color: AppColors.green, size: 16),
          const SizedBox(width: 6),
          Text(
            'All System Operational',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.green,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
