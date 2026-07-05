import 'package:flutter/material.dart';
import 'payment_method_tile.dart';

class PaymentMethodSection extends StatefulWidget {
  const PaymentMethodSection({super.key});

  @override
  State<PaymentMethodSection> createState() => _PaymentMethodSectionState();
}

class _PaymentMethodSectionState extends State<PaymentMethodSection> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PaymentMethodTile(
          leading: Image.asset('assets/payments/google_pay.png', height: 26),
          title: 'Google Pay',
          selected: selectedIndex == 0,
          onTap: () => setState(() => selectedIndex = 0),
        ),

        PaymentMethodTile(
          leading: Image.asset('assets/payments/apple_pay.png', height: 26),
          title: 'Apple Pay',
          selected: selectedIndex == 1,
          onTap: () => setState(() => selectedIndex = 1),
        ),

        PaymentMethodTile(
          leading: Row(
            children: [
              Image.asset('assets/payments/visa_pay.png', height: 22),
              const SizedBox(width: 6),
              Image.asset('assets/payments/master_card_pay.png', height: 22),
            ],
          ),
          title: '0000 0000 0000 0000',
          selected: selectedIndex == 2,
          onTap: () => setState(() => selectedIndex = 2),
        ),
      ],
    );
  }
}
