import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class OnboardingIndicator extends StatelessWidget {
  final int currentIndex;

  const OnboardingIndicator({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        final isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 6,
          width: isActive ? 20 : 6,
          decoration: BoxDecoration(
            color: isActive ? AppColors.green : AppColors.white,
            borderRadius: BorderRadius.circular(12),
          ),
        );
      }),
    );
  }
}
