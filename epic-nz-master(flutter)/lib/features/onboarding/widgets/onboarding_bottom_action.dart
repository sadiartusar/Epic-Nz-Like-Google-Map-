import 'package:flutter/material.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/theme/app_text_styles.dart';

class OnboardingBottomAction extends StatelessWidget {
  final int currentIndex;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  const OnboardingBottomAction({
    super.key,
    required this.currentIndex,
    required this.onNext,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    final isLast = currentIndex == 2;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: isLast
          ? SizedBox(
        width: double.infinity,
        child: PrimaryButton(text: 'Start Your Journey →', onTap: onNext),
      )
          : Row(
        children: [
          TextButton(
            onPressed: onSkip,
            child: Text(
              'Skip',
              style: AppTextStyles.label.copyWith(color: Colors.white),
            ),
          ),

          const Spacer(),

          SizedBox(
            width: 140,
            child: PrimaryButton(text: 'Next', onTap: onNext),
          ),
        ],
      ),
    );
  }
}
