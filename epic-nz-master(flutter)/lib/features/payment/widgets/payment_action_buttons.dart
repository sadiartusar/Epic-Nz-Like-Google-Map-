import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import 'confirm_payment_bottom_sheet.dart';

class PaymentActionButtons extends StatelessWidget {
  final bool isSuccess;

  const PaymentActionButtons({super.key, required this.isSuccess});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PrimaryButton(
          text: isSuccess ? 'Back to Home' : 'Retry Payment',
          onTap: () {
            if (isSuccess) {
              Get.offAllNamed('/main');
            } else {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const ConfirmPaymentBottomSheet(),
              );
            }
          },
        ),

        const SizedBox(height: 16),

        if (isSuccess)
          TextButton.icon(
            onPressed: () {
              // TODO: download receipt
            },
            icon: const Icon(Icons.download_rounded),
            label: const Text('Download Receipt'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.green,
              textStyle: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

        if (!isSuccess) ...[
          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                Get.offAllNamed('/payment-method');
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.green,
                side: const BorderSide(color: AppColors.green),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(
                'Change Payment Method',
                style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          ),

          const SizedBox(height: 10),

          TextButton(
            onPressed: () {
              Get.toNamed('/help-support');
            },
            child: Text(
              'Contact Support',
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondaryLight,
              ),
            ),
          ),

          const SizedBox(height: 8),

          TextButton(
            onPressed: () {
              Get.offAllNamed('/main');
            },
            child: Text(
              'Cancel & Go Home',
              style: AppTextStyles.body.copyWith(
                color: AppColors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
