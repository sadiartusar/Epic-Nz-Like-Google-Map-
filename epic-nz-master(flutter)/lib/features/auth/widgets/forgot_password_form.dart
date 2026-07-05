import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../auth_controller/auth_controller.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/theme/app_text_styles.dart';

class ForgotPasswordForm extends StatelessWidget {
  const ForgotPasswordForm({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Email Address', style: AppTextStyles.label),
        const SizedBox(height: 8),
        AppTextField(
          hint: 'example@gmail.com',
          onChanged: (val) => authController.email.value = val,
        ),
        const SizedBox(height: 32),
        Obx(
          () => PrimaryButton(
            text: authController.isLoading.value
                ? 'Sending...'
                : 'Reset Password',
            onTap: () {
              if (authController.email.value.isNotEmpty) {
                authController.forgetPassword();
              } else {
                Get.snackbar('Alert', 'Please enter your email address');
              }
            },
          ),
        ),
      ],
    );
  }
}
