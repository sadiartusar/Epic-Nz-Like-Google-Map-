import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../data/subscription_controller.dart';

class SubscriptionStatusChip extends StatelessWidget {
  const SubscriptionStatusChip({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SubscriptionController>();

    return Obx(() {
      String label;
      Color color;
      IconData icon;

      if (controller.isTrialActive.value) {
        label = 'Free Trial • ${controller.trialDaysLeft.value} days left';
        color = AppColors.green;
        icon = Icons.timer;
      } else if (controller.hasActivePlan.value) {
        label = 'Active Plan';
        color = AppColors.green;
        icon = Icons.verified;
      } else {
        label = 'Inactive';
        color = Colors.orange;
        icon = Icons.warning_amber_rounded;
      }

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(color: color, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      );
    });
  }
}
