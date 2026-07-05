import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../data/subscription_controller.dart';
import 'subscription_status_chip.dart';

class ActivePlanCard extends StatelessWidget {
  const ActivePlanCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SubscriptionController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      final plan = controller.currentPlan.value.isEmpty
          ? 'PLAN'
          : controller.currentPlan.value;

      final bool isYearly = plan == 'YEARLY';

      final price = isYearly ? '\$199' : '\$20';
      final period = isYearly ? '/year' : '/month';

      final autoRenewText = controller.isTrialActive.value
          ? 'Trial'
          : 'Auto-Renew';

      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.green),
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
            const SubscriptionStatusChip(),

            const SizedBox(height: 16),

            Text(
              plan == 'YEARLY'
                  ? 'Adventure Pro (Yearly)'
                  : 'Adventure Pro (Monthly)',
              style: AppTextStyles.h1.copyWith(
                color: isDark ? Colors.white : AppColors.textPrimaryLight,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              controller.isTrialActive.value
                  ? 'Enjoy all premium features during your free trial'
                  : 'Unlock offline maps & live weather',
              style: AppTextStyles.body.copyWith(
                color: isDark ? Colors.white70 : AppColors.textSecondaryLight,
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Text(
                  price,
                  style: AppTextStyles.title2.copyWith(color: AppColors.green),
                ),
                const SizedBox(width: 6),
                Text(period, style: AppTextStyles.body),
              ],
            ),

            const SizedBox(height: 16),

            _infoRow(
              Icons.calendar_month,
              controller.isTrialActive.value
                  ? 'Trial ends in ${controller.trialDaysLeft.value} days'
                  : 'Subscription active',
            ),

            const SizedBox(height: 8),

            _infoRow(
              Icons.credit_card,
              controller.isTrialActive.value
                  ? 'No payment method yet'
                  : 'Payment method on file',
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Status', style: AppTextStyles.body),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.green.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    controller.isTrialActive.value
                        ? 'Trial Active'
                        : '$autoRenewText On',
                    style: const TextStyle(
                      color: AppColors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.green),
        const SizedBox(width: 8),
        Text(text, style: AppTextStyles.body),
      ],
    );
  }
}
