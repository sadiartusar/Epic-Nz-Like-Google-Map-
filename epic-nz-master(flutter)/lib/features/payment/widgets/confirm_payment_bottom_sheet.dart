import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/primary_button.dart';
import '../screens/payment_failed_screen.dart';
import '../screens/payment_success_screen.dart';

class ConfirmPaymentBottomSheet extends StatelessWidget {
  const ConfirmPaymentBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color fieldBg = isDark
        ? AppColors.green.withValues(alpha: 0.18)
        : Colors.white;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF16231E) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                height: 4,
                width: 44,
                decoration: BoxDecoration(
                  color: AppColors.grey.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),

            const SizedBox(height: 24),

            Text('Card Number', style: AppTextStyles.label),
            const SizedBox(height: 8),
            _inputField(
              hint: '0000 0000 0000 0000',
              bg: fieldBg,
              radius: 32,
              isDark: isDark,
              suffix: const Icon(Icons.credit_card, color: AppColors.green),
            ),

            const SizedBox(height: 16),

            Text('Account Holder Name', style: AppTextStyles.label),
            const SizedBox(height: 8),
            _inputField(
              hint: 'Jhon Smith',
              bg: fieldBg,
              radius: 32,
              isDark: isDark,
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Expire date', style: AppTextStyles.label),
                      const SizedBox(height: 8),
                      _inputField(
                        hint: 'dd/mm',
                        bg: fieldBg,
                        radius: 24,
                        isDark: isDark,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('CVV', style: AppTextStyles.label),
                      const SizedBox(height: 8),
                      _inputField(
                        hint: '000',
                        bg: fieldBg,
                        radius: 24,
                        isDark: isDark,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            PrimaryButton(
              text: 'Confirm Payment',
              onTap: () {
                Get.back();

                final bool isPaymentSuccess =
                    false; //  change to false to test failure

                if (isPaymentSuccess) {
                  Get.to(() => const PaymentSuccessScreen());
                } else {
                  Get.to(() => const PaymentFailedScreen());
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputField({
    required String hint,
    required Color bg,
    required double radius,
    required bool isDark,
    Widget? suffix,
  }) {
    final borderRadius = BorderRadius.circular(radius);

    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
      ),
      child: TextField(
        cursorColor: AppColors.green,
        style: AppTextStyles.body.copyWith(
          color: isDark ? Colors.white : AppColors.textPrimaryLight,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTextStyles.body.copyWith(
            color: isDark
                ? Colors.white.withValues(alpha: 0.6)
                : AppColors.grey,
          ),

          filled: true,
          fillColor: bg,
          suffixIcon: suffix,

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

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}
