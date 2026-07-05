import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class ChatQuickActions extends StatelessWidget {
  const ChatQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: const [
        _QuickActionChip(icon: Icons.receipt_long, label: 'Order Status'),
        _QuickActionChip(icon: Icons.credit_card, label: 'Billing Help'),
        _QuickActionChip(icon: Icons.build, label: 'Technical Issue'),
      ],
    );
  }
}

class _QuickActionChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _QuickActionChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.green.withValues(alpha: 0.15) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.green.withValues(alpha: 0.4)),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.green),
          const SizedBox(width: 6),
          Text(label, style: AppTextStyles.micro),
        ],
      ),
    );
  }
}
