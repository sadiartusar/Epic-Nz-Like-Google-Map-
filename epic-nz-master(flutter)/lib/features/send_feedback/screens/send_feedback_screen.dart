import 'package:flutter/material.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_back_button.dart';
import '../widgets/send_feedback_form.dart';

class SendFeedbackScreen extends StatelessWidget {
  const SendFeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const AppBackButton(),
                  const Spacer(),
                  Text(
                    'Send Feedback',
                    style: AppTextStyles.h2.copyWith(fontSize: 18),
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),

            const Expanded(child: SendFeedbackForm()),
          ],
        ),
      ),
    );
  }
}
