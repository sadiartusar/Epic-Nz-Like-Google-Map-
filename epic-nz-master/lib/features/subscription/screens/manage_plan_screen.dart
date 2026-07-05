import 'package:flutter/material.dart';
import '../widgets/manage_plan_header.dart';
import '../widgets/subscription_options.dart';
import '../widgets/subscribe_button.dart';

class ManagePlanScreen extends StatelessWidget {
  const ManagePlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: const [
              ManagePlanHeader(),
              SizedBox(height: 28),
              SubscriptionOptions(),
              SizedBox(height: 40),
              SubscribeButton(),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
