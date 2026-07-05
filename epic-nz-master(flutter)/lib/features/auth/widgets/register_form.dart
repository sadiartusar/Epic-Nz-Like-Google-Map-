import 'package:epic_nz/features/auth/auth_controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/theme/app_text_styles.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.put(AuthController());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Full Name', style: AppTextStyles.label),
        const SizedBox(height: 8),
        AppTextField(
          hint: 'Luis Domenech',
          onChanged: (val) => authController.fullName.value = val,
        ),

        const SizedBox(height: 20),

        Text('Email Address', style: AppTextStyles.label),
        const SizedBox(height: 8),
        AppTextField(
          hint: 'example@gmail.com',
          onChanged: (val) => authController.email.value = val,
        ),

        const SizedBox(height: 28),

        Obx(
          () => PrimaryButton(
            text: authController.isLoading.value ? 'Loading...' : 'Register',
            onTap: () => authController.register(),
          ),
        ),
      ],
    );
  }
}
