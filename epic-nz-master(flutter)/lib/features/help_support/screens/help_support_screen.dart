import 'package:epic_nz/features/help_support/widgets/cancel_subscription_content.dart';
import 'package:epic_nz/features/help_support/widgets/find_invoice_content.dart';
import 'package:epic_nz/features/help_support/widgets/upgrade_plan_content.dart';
import 'package:flutter/material.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/theme/app_text_styles.dart';
import '../widgets/quick_help_grid.dart';
import '../widgets/faq_tile.dart';
import '../widgets/support_actions.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const AppBackButton(),
                  const SizedBox(width: 12),
                  Text('Help & Support', style: AppTextStyles.h1.copyWith(
                    fontSize: 18
                  )),
                ],
              ),

              const SizedBox(height: 20),

              const QuickHelpGrid(),

              const SizedBox(height: 28),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text('Top FAQs', style: AppTextStyles.h2)],
              ),

              const SizedBox(height: 12),

              const FaqTile(
                title: 'How Do I Upgrade My Plan?',
                expandedContent: UpgradePlanContent(),
              ),
              const FaqTile(
                title: 'Where Can I Find My Invoice?',
                expandedContent: FindInvoiceContent(),
              ),
              const FaqTile(
                title: 'How To Cancel Subscription',
                expandedContent: CancelSubscriptionContent(),
              ),

              const SizedBox(height: 32),

              const SupportActions(),
            ],
          ),
        ),
      ),
    );
  }
}
