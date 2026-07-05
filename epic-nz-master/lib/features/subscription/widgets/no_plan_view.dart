import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/primary_button.dart';

class NoPlanView extends StatelessWidget {
  const NoPlanView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        const SizedBox(height: 80),

        Container(
          height: 96,
          width: 96,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.red.withValues(alpha: isDark ? 0.25 : 0.12),
            boxShadow: [
              BoxShadow(
                color: Colors.red.withValues(alpha: isDark ? 0.35 : 0.25),
                blurRadius: 32,
                spreadRadius: 6,
              ),
            ],
          ),
          child: const Center(
            child: Icon(Icons.lock_outline, size: 44, color: Colors.red),
          ),
        ),

        const SizedBox(height: 20),

        Text(
          'No Active Subscription',
          style: AppTextStyles.h1,
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 8),

        Text(
          'Unlock offline maps, hidden spots\nand premium features.',
          textAlign: TextAlign.center,
          style: AppTextStyles.body,
        ),

        const SizedBox(height: 28),

        PrimaryButton(
          text: 'Explore Plans',
          onTap: () {
            Get.toNamed('/subscription');
          },
        ),
      ],
    );
  }
}
