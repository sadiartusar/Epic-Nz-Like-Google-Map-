import 'package:flutter/material.dart';

class CancelSubscriptionContent extends StatelessWidget {
  const CancelSubscriptionContent({super.key});
  @override
  Widget build(BuildContext context) {
    return const Text(
      "You can cancel your subscription from manage plan.",
      style: TextStyle(color: Colors.grey, fontSize: 13, height: 1.5),
    );
  }
}