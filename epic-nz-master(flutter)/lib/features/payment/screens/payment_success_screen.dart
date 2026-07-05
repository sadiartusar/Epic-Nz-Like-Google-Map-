import 'package:flutter/material.dart';

import '../widgets/payment_action_buttons.dart';
import '../widgets/payment_success_card.dart';
import '../widgets/payment_success_header.dart';

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: const [
              PaymentSuccessHeader(),
              SizedBox(height: 24),
              PaymentSuccessCard(),
              Spacer(),
              PaymentActionButtons(isSuccess: true),
            ],
          ),
        ),
      ),
    );
  }
}
