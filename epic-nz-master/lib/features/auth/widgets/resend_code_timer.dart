import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../auth_controller/auth_controller.dart';

class ResendCodeTimer extends StatelessWidget {
  const ResendCodeTimer({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      final seconds = authController.resendSeconds.value;
      final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
      final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');

      return GestureDetector(
        onTap: authController.canResend.value ? authController.resendOtp : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.timer_outlined, size: 18, color: AppColors.green),
            const SizedBox(width: 6),
            Text(
              authController.canResend.value
                  ? "Resend Code"
                  : "Resend Code In $minutes:$remainingSeconds",
              style: TextStyle(
                color: authController.canResend.value
                    ? AppColors.green
                    : (isDark
                          ? Colors.white.withValues(alpha: 0.7)
                          : AppColors.textSecondaryLight),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    });
  }
}
