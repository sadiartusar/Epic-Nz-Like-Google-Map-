import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/theme/app_text_styles.dart';
import '../data/subscription_controller.dart';
import '../widgets/active_plan_card.dart';
import '../widgets/no_plan_view.dart';
import '../widgets/subscription_manage_tile.dart';
import '../screens/purchase_history_screen.dart';

class MySubscriptionScreen extends StatelessWidget {
  const MySubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SubscriptionController controller = Get.put(SubscriptionController());

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    AppBackButton(),
                    SizedBox(width: 12),
                    Text('My Subscription', style: AppTextStyles.h1),
                  ],
                ),

                const SizedBox(height: 24),

                if (controller.hasActivePlan.value) ...[
                  const ActivePlanCard(),

                  const SizedBox(height: 32),
                  Text('MANAGE', style: AppTextStyles.micro),
                  const SizedBox(height: 12),

                  SubscriptionManageTile(
                    title: 'Upgrade Plan',
                    subtitle: 'Switch to a different plan',
                    icon: Icons.diamond_outlined,
                    onTap: controller.loading.value
                        ? null
                        : () {
                            showGlassConfirmDialog(
                              title: 'Upgrade Plan',
                              message:
                                  'Do you want to upgrade to ${controller.planType.value}?',
                              confirmText: 'Upgrade',
                              onConfirm: controller.upgradePlan,
                            );
                          },
                  ),

                  SubscriptionManageTile(
                    title: 'Purchase History',
                    subtitle: 'View past payments',
                    icon: Icons.receipt_long,
                    onTap: () {
                      Get.to(() => const PurchaseHistoryScreen());
                    },
                  ),

                  SubscriptionManageTile(
                    title: 'Turn Off Auto-Renew',
                    subtitle: 'Subscription will expire at period end',
                    icon: Icons.autorenew,
                    danger: true,
                    onTap: controller.loading.value
                        ? null
                        : () {
                            showGlassConfirmDialog(
                              title: 'Turn off auto-renew?',
                              message:
                                  'You will continue to have premium access until your current plan expires.',
                              confirmText: 'Turn Off',
                              danger: true,
                              onConfirm: controller.turnOffAutoRenew,
                            );
                          },
                  ),
                ] else ...[
                  const NoPlanView(),
                ],

                if (controller.loading.value)
                  const Padding(
                    padding: EdgeInsets.only(top: 24),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.greenDark,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void showGlassConfirmDialog({
  required String title,
  required String message,
  required VoidCallback onConfirm,
  String confirmText = 'Confirm',
  String cancelText = 'Cancel',
  bool danger = false,
}) {
  final isDark = Get.isDarkMode;

  Get.dialog(
    Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            width: Get.width * 0.82,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: (isDark ? Colors.black : Colors.white).withValues(
                alpha: 0.65,
              ),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: danger
                    ? Colors.red.withValues(alpha: 0.4)
                    : AppColors.green.withValues(alpha: 0.4),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 30,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  danger ? Icons.warning_amber_rounded : Icons.info_outline,
                  size: 40,
                  color: danger ? Colors.red : AppColors.green,
                ),

                const SizedBox(height: 16),

                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    inherit: false,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : Colors.black87,
                    decoration: TextDecoration.none,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    inherit: false,
                    fontSize: 14.5,
                    height: 1.4,
                    color: isDark ? Colors.white70 : Colors.black54,
                    decoration: TextDecoration.none,
                  ),
                ),

                const SizedBox(height: 22),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: isDark ? Colors.white : Colors.black26,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26),
                          ),
                        ),
                        child: Text(
                          cancelText,
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black54,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                          onConfirm();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: danger
                              ? Colors.red
                              : AppColors.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26),
                          ),
                        ),
                        child: Text(
                          confirmText,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
    barrierColor: Colors.black.withValues(alpha: 0.35),
    barrierDismissible: true,
  );
}
