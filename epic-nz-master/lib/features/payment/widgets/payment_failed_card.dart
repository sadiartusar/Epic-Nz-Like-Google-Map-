import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class PaymentFailedCard extends StatelessWidget {
  const PaymentFailedCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.red.withValues(alpha: 0.4)),
          ),
          child: Column(
            children: [
              _row('STATUS', 'Card Declined', isError: true),
              const Divider(),
              _row('Payment Method', '•••• 4242'),
              _row('Amount', '\$59.99'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.06)
                : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Your bank may have declined the transaction due to insufficient funds or security block.',
                  style: AppTextStyles.micro,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _row(String title, String value, {bool isError = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTextStyles.micro),
          Text(
            value,
            style: AppTextStyles.body.copyWith(
              color: isError ? Colors.red : null,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
