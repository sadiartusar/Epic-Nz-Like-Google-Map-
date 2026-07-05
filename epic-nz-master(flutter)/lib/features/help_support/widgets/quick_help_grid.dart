import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class QuickHelpGrid extends StatelessWidget {
  const QuickHelpGrid({super.key});

  void _openHelpSheet(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String message,
      }) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final steps = message
        .split("\n")
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.55),
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.42,
          minChildSize: 0.28,
          maxChildSize: 0.75,
          builder: (context, scrollController) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(22)),
                border: Border.all(
                  color: cs.outlineVariant.withValues(alpha: 0.35),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 24,
                    offset: const Offset(0, -8),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  children: [
                    Container(
                      width: 44,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: cs.outlineVariant.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),

                    Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color:
                            AppColors.green.withValues(alpha: 0.16),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color:
                              AppColors.green.withValues(alpha: 0.35),
                            ),
                          ),
                          child: Icon(icon, color: AppColors.green),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(
                            Icons.close,
                            color: cs.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Expanded(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.green
                                .withValues(alpha: 0.18)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isDark
                                  ? AppColors.green
                                  .withValues(alpha: 0.35)
                                  : cs.outlineVariant
                                  .withValues(alpha: 0.25),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Quick steps",
                                style: theme.textTheme.labelLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: cs.onSurface.withValues(alpha: 0.75),
                                ),
                              ),
                              const SizedBox(height: 10),

                              ...List.generate(steps.length, (i) {
                                return Padding(
                                  padding:
                                  const EdgeInsets.only(bottom: 10),
                                  child: Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 26,
                                        height: 26,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: AppColors.green
                                              .withValues(alpha: 0.25),
                                          borderRadius:
                                          BorderRadius.circular(9),
                                        ),
                                        child: Text(
                                          "${i + 1}",
                                          style: theme.textTheme.labelMedium
                                              ?.copyWith(
                                            fontWeight: FontWeight.w800,
                                            color: AppColors.green,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          steps[i],
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                            height: 1.45,
                                            color: cs.onSurface
                                                .withValues(alpha: 0.78),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.green,
                          foregroundColor: Colors.white,
                          padding:
                          const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Got it"),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickHelpItem(
            icon: Icons.lock_reset,
            label: 'Reset\nPassword',
            onTap: () => _openHelpSheet(
              context,
              icon: Icons.lock_reset,
              title: "Reset Password",
              message:
              "Go to Login screen\nTap “Forgot password”\nEnter your email\nCheck inbox for OTP",
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickHelpItem(
            icon: Icons.credit_card,
            label: 'Billing\n& Plans',
            onTap: () => _openHelpSheet(
              context,
              icon: Icons.credit_card,
              title: "Billing & Plans",
              message:
              "Open Settings\nGo to Subscription\nChoose Monthly or Yearly\nConfirm payment",
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickHelpItem(
            icon: Icons.cancel,
            label: 'Cancel\nSub',
            onTap: () => _openHelpSheet(
              context,
              icon: Icons.cancel,
              title: "Cancel Subscription",
              message:
              "Open Settings\nGo to Subscription\nTap Cancel\nConfirm cancellation",
            ),
          ),
        ),
      ],
    );
  }
}

class _QuickHelpItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickHelpItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.green.withValues(alpha: 0.15)
              : Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: isDark
              ? []
              : [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.green),
            const SizedBox(height: 8),
            Text(label, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
