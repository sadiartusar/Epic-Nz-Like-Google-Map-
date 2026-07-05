import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_assets.dart';
import '../../../routes/app_routes.dart';
import '../widgets/onboarding_page.dart';
import '../widgets/onboarding_indicator.dart';
import '../widgets/onboarding_bottom_action.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  void _handleNext() {
    final isLast = _currentIndex == 2;

    if (isLast) {
      Get.offAllNamed(AppRoutes.login);
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (i) => setState(() => _currentIndex = i),
            children: const [
              OnboardingPage(
                tag: 'Lake Pearson',
                title: "Uncover The\nEpic.",
                subtitle:
                'Your journey begins with a single tap, and the stories you’ll tell begin with the adventures waiting just ahead.',
                imagePath: AppAssets.onboarding1,
              ),
              OnboardingPage(
                title: 'Plan.\nDo.\nDone.',
                subtitle:
                'Your journey begins with a single tap, adventures waiting just ahead.',
                imagePath: AppAssets.onboarding2,
              ),
              OnboardingPage(
                title: 'Journey Beyond\nLimits.',
                subtitle:
                'Seamless navigation and real-time insight for your unlimited adventure.',
                imagePath: AppAssets.onboarding3,
              ),
            ],
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 32,
            child: Column(
              children: [
                OnboardingIndicator(currentIndex: _currentIndex),
                const SizedBox(height: 20),
                OnboardingBottomAction(
                  currentIndex: _currentIndex,
                  onNext: _handleNext,
                  onSkip: () {
                    Get.offAllNamed(AppRoutes.login);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
