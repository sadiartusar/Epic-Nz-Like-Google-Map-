import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class PreferenceNavTile extends StatelessWidget {
  final String title;
  final String value;

  const PreferenceNavTile({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.greenDarker : AppColors.greyLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.language, color: AppColors.green),

          const SizedBox(width: 12),

          Expanded(
            child: Text(title, style: AppTextStyles.h1.copyWith(fontSize: 18)),
          ),

          Text(
            value,
            style: AppTextStyles.body.copyWith(color: AppColors.grey,
            fontSize: 14),
          ),

          const SizedBox(width: 6),
          const Icon(Icons.chevron_right, color: AppColors.grey),
        ],
      ),
    );
  }
}
