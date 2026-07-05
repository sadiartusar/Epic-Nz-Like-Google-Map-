import 'package:epic_nz/features/auth/auth_controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_colors.dart';
import '../../../routes/app_routes.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthController authController = Get.find<AuthController>();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Email Address', style: AppTextStyles.label),
        const SizedBox(height: 8),
        AppTextField(
          hint: 'example@gmail.com',
          controller: _emailController,
        ),
        const SizedBox(height: 20),
        const Text('Password', style: AppTextStyles.label),
        const SizedBox(height: 8),
        AppTextField(
          hint: '••••••••',
          controller: _passwordController,
          obscure: _obscurePassword,
          suffix: IconButton(
            splashRadius: 20,
            icon: Icon(
              _obscurePassword ? Icons.visibility_off : Icons.visibility,
              color: AppColors.grey,
            ),
            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
          ),
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () => Get.toNamed(AppRoutes.forgotPassword),
            child: Text(
              'Forgot Password?',
              style: AppTextStyles.label.copyWith(
                color: isDark ? Colors.white : AppColors.textSecondaryLight,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Obx(() {
          final bool loading = authController.isLoading.value;
          return PrimaryButton(
            text: loading ? 'Loading...' : 'Login',
            onTap: loading ? null : () {
              final email = _emailController.text.trim();
              final pass = _passwordController.text.trim();
              if (email.isEmpty || pass.isEmpty) {
                Get.snackbar('Alert', 'Please enter email and password');
                return;
              }
              authController.login(email, pass);
            },
          );
        }),
      ],
    );
  }
}