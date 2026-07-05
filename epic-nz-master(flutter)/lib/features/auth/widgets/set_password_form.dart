import 'package:epic_nz/features/auth/auth_controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_colors.dart';
import 'password_strength_indicator.dart';

class SetPasswordForm extends StatefulWidget {
  const SetPasswordForm({super.key});

  @override
  State<SetPasswordForm> createState() => _SetPasswordFormState();
}

class _SetPasswordFormState extends State<SetPasswordForm> {
  final authController = Get.find<AuthController>();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  int _strength = 0;

  int _calculateStrength(String value) {
    int score = 0;
    if (value.length >= 8) score++;
    if (RegExp(r'\d').hasMatch(value)) score++;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) score++;
    if (RegExp(r'(?=.*[a-z])(?=.*[A-Z])').hasMatch(value)) score++;
    return score;
  }

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() {
      setState(() {
        _strength = _calculateStrength(_passwordController.text);
      });
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('New Password', style: AppTextStyles.label),
        const SizedBox(height: 8),
        AppTextField(
          hint: 'Enter New Password',
          obscure: _obscureNewPassword,
          controller: _passwordController,
          suffix: IconButton(
            icon: Icon(
              _obscureNewPassword ? Icons.visibility_off : Icons.visibility,
              color: AppColors.grey,
            ),
            onPressed: () =>
                setState(() => _obscureNewPassword = !_obscureNewPassword),
          ),
        ),

        const SizedBox(height: 16),
        PasswordStrengthIndicator(strength: _strength),
        const SizedBox(height: 16),
        Text(
          'Must Contain At Least 8 Characters, One Number And One Special Character.',
          style: AppTextStyles.body.copyWith(
            color: AppColors.textSecondaryLight,
          ),
        ),

        const SizedBox(height: 24),
        Text('Confirm Password', style: AppTextStyles.label),
        const SizedBox(height: 8),

        AppTextField(
          hint: 'Re-Enter Password',
          controller: _confirmPasswordController,
          obscure: _obscureConfirmPassword,
          suffix: IconButton(
            icon: Icon(
              _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
              color: AppColors.grey,
            ),
            onPressed: () => setState(
              () => _obscureConfirmPassword = !_obscureConfirmPassword,
            ),
          ),
        ),

        const SizedBox(height: 32),

        Obx(
          () => PrimaryButton(
            text: authController.isLoading.value ? 'Processing...' : 'Confirm',
            onTap: () {
              if (_passwordController.text != _confirmPasswordController.text) {
                Get.snackbar('Error', 'Passwords do not match');
                return;
              }
              if (_strength >= 3) {
                if (authController.isForgotPasswordMode.value) {
                  authController.resetPassword(_passwordController.text);
                } else {
                  authController.updatePassword(
                    _passwordController.text,
                    _confirmPasswordController.text,
                  );
                }
              } else {
                Get.snackbar('Error', 'Password is too weak');
              }
            },
          ),
        ),
      ],
    );
  }
}
