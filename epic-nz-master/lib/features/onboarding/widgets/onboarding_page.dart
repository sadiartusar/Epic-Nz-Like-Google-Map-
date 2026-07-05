import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_assets.dart';

class OnboardingPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final String? tag;

  const OnboardingPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        RepaintBoundary(
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            cacheWidth: 600,
            filterQuality: FilterQuality.low,
          ),
        ),

        Container(color: Colors.black.withValues(alpha: 0.35)),

        Positioned(
          top: MediaQuery.of(context).padding.top + 56,
          left: 0,
          right: 0,
          child: Center(
            child: Image.asset(
              AppAssets.appLogo,
              height: 180,
              fit: BoxFit.contain,
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(flex: 4),

              if (tag != null) ...[
                Row(
                  children: [
                    Container(height: 2, width: 20, color: AppColors.green),
                    const SizedBox(width: 8),
                    Text(
                      tag!,
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
              ],

              Text(
                title,
                style: AppTextStyles.title2.copyWith(color: Colors.white),
              ),

              const SizedBox(height: 16),

              Text(
                subtitle,
                style: AppTextStyles.body.copyWith(
                  fontSize: 14,
                  height: 1.6,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),

              const Spacer(flex: 5),
            ],
          ),
        ),
      ],
    );
  }
}
