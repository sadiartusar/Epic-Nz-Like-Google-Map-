import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:epic_nz/features/subscription/widgets/subscription_plan_card.dart';
import '../data/subscription_controller.dart';

class SubscriptionOptions extends StatefulWidget {
  const SubscriptionOptions({super.key});

  @override
  State<SubscriptionOptions> createState() => _SubscriptionOptionsState();
}

class _SubscriptionOptionsState extends State<SubscriptionOptions> {
  bool yearlySelected = true;

  late final SubscriptionController subscriptionController;

  @override
  void initState() {
    super.initState();
    subscriptionController = Get.find<SubscriptionController>();

    subscriptionController.planType.value = "YEARLY";
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SubscriptionPlanCard(
            title: 'Monthly Plan',
            subtitle: 'Flexible commitment',
            price: '\$20',
            period: '/month',
            footerText: "Billed monthly after your 1-month free trial.",
            selected: !yearlySelected,
            onTap: () {
              setState(() => yearlySelected = false);
              subscriptionController.planType.value = "MONTHLY";
            },
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: SubscriptionPlanCard(
            title: 'Annual Plan',
            subtitle: 'Best value',
            price: '\$199',
            oldPrice: '\$240',
            period: '/year',
            badge: 'SAVE MORE',
            footerText: "1-month free, then billed annually.",
            selected: yearlySelected,
            onTap: () {
              setState(() => yearlySelected = true);
              subscriptionController.planType.value = "YEARLY";
            },
          ),
        ),
      ],
    );
  }
}
