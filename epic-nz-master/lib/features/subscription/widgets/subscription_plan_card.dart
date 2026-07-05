import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class SubscriptionPlanCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String price;
  final String period;
  final String? oldPrice;
  final String? badge;
  final String footerText;
  final bool selected;
  final VoidCallback onTap;

  const SubscriptionPlanCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.period,
    required this.footerText,
    required this.selected,
    required this.onTap,
    this.oldPrice,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.green.withValues(alpha: isDark ? 0.18 : 0.12)
              : (isDark ? Colors.white.withValues(alpha: 0.06) : Colors.white),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.green : Colors.transparent,
            width: 1.5,
          ),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 18,
                  width: 18,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.green, width: 1.5),
                  ),
                  child: selected
                      ? Center(
                          child: Container(
                            height: 10,
                            width: 10,
                            decoration: const BoxDecoration(
                              color: AppColors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                        )
                      : null,
                ),
                const Spacer(),
                if (badge != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.green,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      badge!,
                      style: AppTextStyles.micro.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 12),

            Text(
              title,
              style: AppTextStyles.h2.copyWith(
                color: isDark ? Colors.white : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: AppTextStyles.micro.copyWith(color: AppColors.grey),
            ),

            const SizedBox(height: 16),

            if (oldPrice != null)
              Text(
                oldPrice!,
                style: AppTextStyles.micro.copyWith(
                  decoration: TextDecoration.lineThrough,
                  color: AppColors.grey,
                ),
              ),

            Wrap(
              crossAxisAlignment: WrapCrossAlignment.end,
              spacing: 4,
              children: [
                Text(
                  price,
                  style: AppTextStyles.title2.copyWith(
                    color: AppColors.green,
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                  ),
                ),
                Text(
                  period,
                  style: AppTextStyles.micro.copyWith(color: AppColors.grey),
                ),
              ],
            ),

            const SizedBox(height: 14),
            const Divider(height: 1),

            const SizedBox(height: 12),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.calendar_month,
                  size: 16,
                  color: AppColors.green,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    footerText,
                    style: AppTextStyles.micro.copyWith(color: AppColors.green),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
