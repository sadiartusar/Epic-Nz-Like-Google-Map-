import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class HelpSearchBar extends StatelessWidget {
  const HelpSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderRadius = BorderRadius.circular(28);

    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,

        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.10),
                  blurRadius: 22,
                  offset: const Offset(0, 12),
                ),
              ],
      ),
      child: TextField(
        style: AppTextStyles.body.copyWith(
          color: isDark ? Colors.white : AppColors.textPrimaryLight,
        ),
        cursorColor: AppColors.green,
        decoration: InputDecoration(
          hintText: 'Search',
          hintStyle: AppTextStyles.body.copyWith(
            color: isDark
                ? Colors.white.withValues(alpha: 0.6)
                : AppColors.grey,
          ),

          prefixIcon: Icon(
            Icons.search,
            color: isDark ? Colors.white70 : AppColors.grey,
          ),

          filled: true,
          fillColor: isDark
              ? AppColors.green.withValues(alpha: 0.18)
              : Colors.white,

          border: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: const BorderSide(color: AppColors.green, width: 1.3),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide.none,
          ),

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}
