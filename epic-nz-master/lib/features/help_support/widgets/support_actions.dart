import 'package:epic_nz/features/help_support/contact_controller/contact_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../routes/app_routes.dart';

class SupportActions extends StatelessWidget {
  const SupportActions({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final contact = Get.find<ContactController>();

    return Column(
      children: [
        InkWell(
          onTap: () => Get.toNamed(AppRoutes.supportChat),
          borderRadius: BorderRadius.circular(32),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.green,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: AppColors.green.withValues(alpha: 0.35),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.chat_bubble_outline, color: Colors.white),
                const SizedBox(width: 10),
                Text(
                  'Chat With Support',
                  style: AppTextStyles.body.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 8),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(radius: 3, backgroundColor: AppColors.green),
            const SizedBox(width: 6),
          ],
        ),

        const SizedBox(height: 20),

        Row(
          children: [
            Expanded(
              child: _outlinedAction(
                icon: Icons.email_outlined,
                label: 'Email Us',
                isDark: isDark,
                onTap: () => contact.openEmailApp(),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _outlinedAction(
                icon: Icons.call_outlined,
                label: 'Call Us',
                isDark: isDark,
                onTap: () => contact.openPhoneDialer(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _outlinedAction({
    required IconData icon,
    required String label,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(26),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          border: Border.all(
            color: isDark
                ? AppColors.green.withValues(alpha: 0.6)
                : AppColors.green,
          ),
          color: isDark
              ? AppColors.green.withValues(alpha: 0.08)
              : Colors.white,
          boxShadow: isDark
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.green),
            const SizedBox(height: 6),
            Text(
              label,
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
