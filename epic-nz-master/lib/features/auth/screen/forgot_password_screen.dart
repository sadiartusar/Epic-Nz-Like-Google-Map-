import 'package:flutter/material.dart';
import '../../../core/widgets/app_back_button.dart';
import '../widgets/forgot_password_icon.dart';
import '../widgets/forgot_password_form.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_colors.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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

              const SizedBox(height: 28),

              const ForgotPasswordIcon(),

              const SizedBox(height: 32),

              Text(
                'Forgot Password',
                style: AppTextStyles.title2.copyWith(
                  color: isDark ? Colors.white : AppColors.textPrimaryLight,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                'Enter your email or username associated with your account and we’ll send you a link to reset your password.',
                textAlign: TextAlign.center,
                style: AppTextStyles.body.copyWith(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.7)
                      : AppColors.textSecondaryLight,
                ),
              ),

              const SizedBox(height: 32),

              const ForgotPasswordForm(),
            ],
          ),
        ),
      ),
    );
  }
}
