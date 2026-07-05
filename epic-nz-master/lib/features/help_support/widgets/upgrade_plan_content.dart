import 'package:flutter/material.dart';

class UpgradePlanContent extends StatelessWidget {
  const UpgradePlanContent({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final base = Theme.of(context).textTheme.bodyMedium?.copyWith(
      color: cs.onSurface.withValues(alpha: 0.72),
      height: 1.5,
      fontSize: 13.5,
    );

    final strong = base?.copyWith(
      color: cs.onSurface.withValues(alpha: 0.72),
      fontWeight: FontWeight.w700,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            style: base,
            children: [
              const TextSpan(text: "You have a "),
              TextSpan(text: "30-day", style: strong),
              const TextSpan(text: " free trial."),
            ],
          ),
        ),
        const SizedBox(height: 10),

        _PlanRow(
          label: "Monthly",
          value: "\$20",
          suffix: "/month",
          labelStyle: base!,
          valueStyle: strong!,
        ),
        const SizedBox(height: 6),

        _PlanRow(
          label: "Yearly",
          value: "\$199",
          suffix: "/year",
          labelStyle: base,
          valueStyle: strong,
        ),

        const SizedBox(height: 10),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.6)),
          ),
          child: Text.rich(
            TextSpan(
              style: base,
              children: [
                const TextSpan(text: "Save "),
                TextSpan(text: "\$40", style: strong),
                const TextSpan(text: " when you subscribe yearly."),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PlanRow extends StatelessWidget {
  const _PlanRow({
    required this.label,
    required this.value,
    required this.suffix,
    required this.labelStyle,
    required this.valueStyle,
  });

  final String label;
  final String value;
  final String suffix;
  final TextStyle labelStyle;
  final TextStyle valueStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: labelStyle.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        Text(value, style: valueStyle),
        const SizedBox(width: 4),
        Text(suffix, style: labelStyle),
      ],
    );
  }
}
