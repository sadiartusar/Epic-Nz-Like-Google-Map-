import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../auth_controller/auth_controller.dart';
import '../../../core/widgets/social_button.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../routes/app_routes.dart';

class AuthFooter extends StatelessWidget {
  const AuthFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // Row(
        //   children: [
        //     Expanded(
        //       child: SocialButton(
        //         text: 'Google',
        //         icon: Image.asset(AppAssets.googleIcon, height: 18),
        //         onTap: () {
        //           authController.loginWithGoogle();
        //         },
        //       ),
        //     ),
        //     const SizedBox(width: 12),
        //     Expanded(
        //       child: SocialButton(
        //         text: 'Apple',
        //         icon: Image.asset(AppAssets.appleIcon, height: 18),
        //         onTap: () {
        //           authController.loginWithApple();
        //         },
        //       ),
        //     ),
        //   ],
        // ),
        Row(
          children: [
            Expanded(
              child: SocialButton(
                text: 'Google',
                icon: Image.asset(AppAssets.googleIcon, height: 18),
                onTap: () {
                  Get.snackbar(
                    "Unavailable",
                    "This feature is currently unavailable due to domain configuration. Please continue with manual sign in.",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: isDark ? Colors.grey[900] : Colors.white,
                    colorText: isDark ? Colors.white : Colors.black87,
                    margin: const EdgeInsets.all(16),
                    borderRadius: 12,
                    duration: const Duration(seconds: 3),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SocialButton(
                text: 'Apple',
                icon: Image.asset(AppAssets.appleIcon, height: 18),
                onTap: () {
                  Get.snackbar(
                    "Unavailable",
                    "This feature is currently unavailable due to domain configuration. Please continue with manual sign in.",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: isDark ? Colors.grey[900] : Colors.white,
                    colorText: isDark ? Colors.white : Colors.black87,
                    margin: const EdgeInsets.all(16),
                    borderRadius: 12,
                    duration: const Duration(seconds: 3),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Don't Have An Account? ",
              style: AppTextStyles.body.copyWith(
                color: isDark ? Colors.white70 : AppColors.textSecondaryLight,
              ),
            ),
            GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.register),
              child: Text(
                'Sign Up',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
