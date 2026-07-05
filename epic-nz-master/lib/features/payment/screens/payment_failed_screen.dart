import 'package:flutter/material.dart';

import '../widgets/payment_action_buttons.dart';
import '../widgets/payment_failed_card.dart';
import '../widgets/payment_failed_header.dart';

class PaymentFailedScreen extends StatelessWidget {
  const PaymentFailedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: const [
              PaymentFailedHeader(),
              SizedBox(height: 24),
              PaymentFailedCard(),
              Spacer(),
              PaymentActionButtons(isSuccess: false),
            ],
          ),
        ),
      ),
    );
  }
}
