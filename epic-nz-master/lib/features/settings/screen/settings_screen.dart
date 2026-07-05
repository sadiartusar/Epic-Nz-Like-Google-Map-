import 'package:epic_nz/features/auth/auth_controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/controller/theme_controller.dart';
import '../../../core/widgets/app_back_button.dart';
import '../widgets/explorer_pass_card.dart';
import '../widgets/settings_section.dart';
import '../../../core/theme/app_text_styles.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    Get.put(ThemeController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const AppBackButton(),
                  const SizedBox(width: 16),
                  Text(
                    'Settings',
                    style: AppTextStyles.h1.copyWith(
                      color: isDark ? Colors.white : null,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              const ExplorerPassCard(),

              const SizedBox(height: 24),

              const SettingsSection(),

              const SizedBox(height: 32),

              SizedBox(
                height: 56,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.defaultDialog(
                      title: "Log Out",
                      middleText: "Are you sure you want to log out?",
                      textConfirm: "Yes",
                      textCancel: "No",
                      confirmTextColor: Colors.white,
                      cancelTextColor: Colors.black,
                      buttonColor: Colors.redAccent,
                      onConfirm: () {
                        Get.back();
                        authController.logoutUser();
                      },
                      onCancel: () {},

                      cancel: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          elevation: 0,
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () => Get.back(),
                        child: Text(
                          "No",
                          style: AppTextStyles.label.copyWith(
                            color: Colors.black,
                            
                          ),
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Log Out',
                    style: AppTextStyles.label.copyWith(color: Colors.white,
                    fontSize: 16),
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
