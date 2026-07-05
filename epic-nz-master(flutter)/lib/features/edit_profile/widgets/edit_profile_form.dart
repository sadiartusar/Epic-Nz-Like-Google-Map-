import 'package:epic_nz/features/profile/profile_controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/primary_button.dart';

class EditProfileForm extends StatefulWidget {
  const EditProfileForm({super.key});

  @override
  State<EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  final controller = Get.find<ProfileController>();
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: controller.fullName.value);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color fieldBg = isDark
        ? AppColors.green.withValues(alpha: 0.12)
        : Colors.grey[100]!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Full Name', style: AppTextStyles.label.copyWith(
            fontSize: 16
          )),
          const SizedBox(height: 8),
          _inputField(
            controller: _nameController,
            hint: 'Enter your full name',
            bg: fieldBg,
            radius: 32,
            isDark: isDark,
          ),
          const SizedBox(height: 20),

          Text(
            'Email Address (Registered)',
            style: AppTextStyles.label.copyWith(color: Colors.grey,
            fontSize: 16),
          ),
          const SizedBox(height: 8),

          Obx(
            () => _inputField(
              controller: TextEditingController(text: controller.email.value),
              hint: 'Email Address',
              bg: isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.grey[200]!,
              radius: 32,
              isDark: isDark,
              readOnly: true,
            ),
          ),

          const SizedBox(height: 40),

          Obx(
            () => PrimaryButton(
              text: controller.isUpdating.value
                  ? 'Updating...'
                  : 'Save & Change',
              onTap: controller.isUpdating.value
                  ? null
                  : () {
                      if (_nameController.text.trim().isEmpty) {
                        Get.snackbar(
                          "Error",
                          "Name cannot be empty",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.redAccent,
                          colorText: Colors.white,
                        );
                        return;
                      }
                      controller.updateProfile(_nameController.text.trim());
                    },
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required Color bg,
    required double radius,
    required bool isDark,
    bool readOnly = false,
  }) {
    final borderRadius = BorderRadius.circular(radius);

    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: isDark || readOnly
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        cursorColor: AppColors.green,
        style: AppTextStyles.body.copyWith(
          color: isDark ? Colors.white : AppColors.textPrimaryLight,
          fontSize: 14
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTextStyles.body.copyWith(
            color: isDark
                ? Colors.white.withValues(alpha: 0.4)
                : AppColors.grey,
            fontSize: 14
          ),
          filled: true,
          fillColor: bg,
          border: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(
              color: readOnly ? Colors.transparent : AppColors.green,
              width: 1.2,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}
