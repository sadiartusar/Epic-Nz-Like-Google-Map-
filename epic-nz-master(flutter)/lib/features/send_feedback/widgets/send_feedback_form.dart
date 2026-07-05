import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/primary_button.dart';
import '../controller/feedback_controller.dart';

class SendFeedbackForm extends StatelessWidget {
  const SendFeedbackForm({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final feedbackController = Get.put(FeedbackController());

    final Color fieldBg = isDark
        ? AppColors.green.withValues(alpha: 0.18)
        : Colors.white;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),

          Text('Subject', style: AppTextStyles.h1.copyWith(
            fontSize: 18
          )),
          const SizedBox(height: 8),
          _inputField(
            controller: feedbackController.titleController,
            hint: 'Feedback',
            bg: fieldBg,
            radius: 32,
            isDark: isDark,
            maxLines: 1,
          ),

          const SizedBox(height: 20),

          Text('Message', style: AppTextStyles.h1.copyWith(
            fontSize: 18
          )),
          const SizedBox(height: 8),
          _inputField(
            controller: feedbackController.messageController,
            hint: 'Write your feedback here...',
            bg: fieldBg,
            radius: 12,
            isDark: isDark,
            maxLines: 5,
          ),

          const SizedBox(height: 32),

          Obx(
                () => PrimaryButton(
              text: feedbackController.isSubmitting.value
                  ? 'Submitting...'
                  : 'Submit Feedback',
              onTap: feedbackController.isSubmitting.value
                  ? () {}
                  : () => feedbackController.submitFeedback(),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required Color bg,
    required double radius,
    required bool isDark,
    int maxLines = 1,
  }) {
    final borderRadius = BorderRadius.circular(radius);

    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: isDark
            ? []
            : [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        cursorColor: AppColors.green,
        style: AppTextStyles.body.copyWith(
          color: isDark ? Colors.white : AppColors.textPrimaryLight,
          fontSize: 14
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTextStyles.body.copyWith(
            color: isDark
                ? Colors.white.withValues(alpha: 0.6)
                : AppColors.grey,
            fontSize: 16
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
            borderSide: const BorderSide(color: AppColors.green, width: 1.4),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 18,
            vertical: maxLines > 1 ? 16 : 14,
          ),
        ),
      ),
    );
  }
}
