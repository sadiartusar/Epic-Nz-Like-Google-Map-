import 'package:flutter/material.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/theme/app_text_styles.dart';
import '../widgets/confirm_payment_bottom_sheet.dart';
import '../widgets/payment_method_section.dart';

class PaymentMethodScreen extends StatelessWidget {
  const PaymentMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const AppBackButton(),
                  const Spacer(),
                  Text('Confirm And Pay', style: AppTextStyles.h1),
                  const Spacer(flex: 2),
                ],
              ),
            ),

            const SizedBox(height: 32),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: PaymentMethodSection(),
            ),

            const Spacer(),

            Padding(
              padding: const EdgeInsets.all(24),
              child: PrimaryButton(
                text: 'Proceed',
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => const ConfirmPaymentBottomSheet(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
