import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../routes/app_routes.dart';
import '../../subscription/data/subscription_controller.dart';

class ExplorerPassCard extends StatelessWidget {
  const ExplorerPassCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SubscriptionController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      final bool hasPlan = controller.hasActivePlan.value;
      final bool isTrial = controller.isTrialActive.value;

      final String planTitle = isTrial
          ? 'Adventure Pro (Trial)'
          : controller.displayPlanName.value.isNotEmpty
          ? controller.displayPlanName.value
          : 'Explorer Pass';

      String subtitleText;
      Color statusColor;

      if (isTrial) {
        subtitleText =
            'Free Trial • ${controller.trialDaysLeft.value} days left';
        statusColor = AppColors.green;
      } else if (hasPlan && controller.subscriptionEndDate.value != null) {
        final end = controller.subscriptionEndDate.value!;
        subtitleText = 'Expires on ${end.day}/${end.month}/${end.year}';
        statusColor = AppColors.green;
      } else {
        subtitleText = 'No Active Subscription';
        statusColor = Colors.orange;
      }

      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: statusColor.withValues(alpha: 0.45)),
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
                Text(
                  planTitle,
                  style: AppTextStyles.h2.copyWith(
                    color: isDark ? Colors.white : AppColors.textPrimaryLight,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 6),
                CircleAvatar(radius: 4, backgroundColor: statusColor),
                const Spacer(),
                Icon(Icons.diamond_outlined, color: statusColor),
              ],
            ),

            const SizedBox(height: 10),

            Text(
              subtitleText,
              style: AppTextStyles.body.copyWith(
                color: isDark ? Colors.white70 : AppColors.textSecondaryLight,
                fontSize: 14,
              ),
            ),

            const Divider(height: 28),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: hasPlan
                        ? () => Get.toNamed(AppRoutes.myPlan)
                        : null,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.green,
                      side: const BorderSide(color: AppColors.green),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'My Plan',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.toNamed('/subscription');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      hasPlan ? 'Manage Plan' : 'Get Premium',
                      style: TextStyle(fontSize: 16),
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
}
