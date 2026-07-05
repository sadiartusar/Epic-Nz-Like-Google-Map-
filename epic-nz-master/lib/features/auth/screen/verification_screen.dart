import 'package:epic_nz/features/auth/auth_controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/app_back_button.dart';
import '../widgets/otp_input_field.dart';
import '../widgets/resend_code_timer.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_colors.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authController = Get.find<AuthController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      authController.startResendTimer();
    });

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 12),

              const Align(
                alignment: Alignment.centerLeft,
                child: AppBackButton(),
              ),

              const SizedBox(height: 32),

              Text(
                'Verification Code',
                style: AppTextStyles.title2.copyWith(
                  color: isDark ? Colors.white : AppColors.textPrimaryLight,
                ),
              ),

              const SizedBox(height: 8),

              Obx(
                () => Text(
                  'We have sent a verification code to\n${authController.email.value}',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body.copyWith(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.7)
                        : AppColors.textSecondaryLight,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              OtpInputField(
                onChanged: (code) => authController.otp.value = code,
              ),
              const SizedBox(height: 32),
              Obx(
                () => PrimaryButton(
                  text: authController.isLoading.value
                      ? 'Verifying...'
                      : 'Verify Code',
                  onTap: () {
                    if (authController.otp.value.length == 6) {
                      if (authController.isForgotPasswordMode.value) {
                        authController.verifyForgotPasswordOtp();
                      } else {
                        authController.verifyOtp();
                      }
                    } else {
                      Get.snackbar("Error", "Please enter 6 digit OTP");
                    }
                  },
                ),
              ),

              const SizedBox(height: 24),

              const ResendCodeTimer(),

              const SizedBox(height: 40),

              GestureDetector(
                onTap: () {
                  authController.resendOtp();
                },
                child: RichText(
                  text: TextSpan(
                    style: AppTextStyles.body.copyWith(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.6)
                          : AppColors.textSecondaryLight,
                    ),
                    children: [
                      const TextSpan(text: "Didn't Receive Code? "),
                      TextSpan(
                        text: 'Resend',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
