import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class PurchaseHistoryTile extends StatelessWidget {
  final Map<String, dynamic> item;

  const PurchaseHistoryTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final String plan = (item['plan_type'] ?? item['plan'] ?? 'PLAN')
        .toString();
    final String status = item['status'] ?? 'UNKNOWN';
    final bool isSuccess = status == 'ACTIVE';

    final num amount = item['total_spent'] ?? 0;
    final DateTime date = DateTime.parse(item['createdAt']);

    final String transactionId = item['stripeSubscriptionId'] ?? '—';

    final String cardBrand = item['card_brand'] ?? 'Card';
    final String last4 = item['card_last4'] ?? '****';

    final bool autoRenew = item['auto_renew'] ?? false;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              color: isDark
                  ? Colors.white.withValues(alpha: 0.06)
                  : Colors.white.withValues(alpha: 0.65),
              border: Border.all(
                color: isSuccess
                    ? AppColors.green.withValues(alpha: 0.35)
                    : Colors.orange.withValues(alpha: 0.35),
              ),
              boxShadow: isDark
                  ? []
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 24,
                        offset: const Offset(0, 10),
                      ),
                    ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: isSuccess
                          ? AppColors.green
                          : Colors.orange,
                      child: Icon(
                        isSuccess
                            ? Icons.check_rounded
                            : Icons.timelapse_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "$plan Plan",
                            style: AppTextStyles.body.copyWith(
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? Colors.white
                                  : AppColors.textPrimaryLight,
                              fontSize: 14
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${date.day}/${date.month}/${date.year}",
                            style: AppTextStyles.micro.copyWith(
                              color: isDark
                                  ? Colors.white70
                                  : AppColors.textSecondaryLight,
                              fontSize: 14
                            ),
                          ),
                        ],
                      ),
                    ),

                    Text(
                      "\$$amount",
                      style: AppTextStyles.title2.copyWith(
                        color: AppColors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 30
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                Divider(
                  height: 1,
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.12)
                      : Colors.black.withValues(alpha: 0.08),
                ),
                const SizedBox(height: 14),

                _infoRow(
                  icon: Icons.receipt_long,
                  label: 'Transaction ID',
                  value: transactionId,
                  isDark: isDark,
                ),

                _infoRow(
                  icon: Icons.credit_card,
                  label: 'Payment Method',
                  value: "$cardBrand •••• $last4",
                  isDark: isDark,
                ),

                _infoRow(
                  icon: Icons.autorenew,
                  label: 'Auto Renew',
                  value: autoRenew ? 'Enabled' : 'Disabled',
                  valueColor: autoRenew ? AppColors.green : Colors.orange,
                  isDark: isDark,
                ),

                _infoRow(
                  icon: Icons.info_outline,
                  label: 'Status',
                  value: status,
                  valueColor: isSuccess ? AppColors.green : Colors.orange,
                  isDark: isDark,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Reusable info row
  Widget _infoRow({
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.green),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.micro.copyWith(
                color: isDark ? Colors.white70 : AppColors.textSecondaryLight,
                fontSize: 12
              ),
            ),
          ),
          Text(
            value,
            style: AppTextStyles.micro.copyWith(
              color:
                  valueColor ??
                  (isDark ? Colors.white : AppColors.textPrimaryLight),
              fontWeight: FontWeight.w600,
              fontSize: 10
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
