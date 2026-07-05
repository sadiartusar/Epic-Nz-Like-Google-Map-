import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/theme/app_text_styles.dart';
import '../data/subscription_controller.dart';
import '../widgets/purchase_history_tile.dart';

class PurchaseHistoryScreen extends StatelessWidget {
  const PurchaseHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SubscriptionController controller =
        Get.find<SubscriptionController>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children:  [
                    AppBackButton(),
                    SizedBox(width: 12),
                    Text('Purchase History', style: AppTextStyles.h1.copyWith(
                      fontSize: 18
                    )),
                  ],
                ),

                const SizedBox(height: 24),

                if (controller.historyLoading.value)
                  const Center(child: CircularProgressIndicator()),

                if (!controller.historyLoading.value &&
                    controller.purchaseHistory.isEmpty)
                  const Expanded(
                    child: Center(child: Text('No purchase history found')),
                  ),

                if (!controller.historyLoading.value &&
                    controller.purchaseHistory.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                      itemCount: controller.purchaseHistory.length,
                      itemBuilder: (context, index) {
                        return PurchaseHistoryTile(
                          item: controller.purchaseHistory[index],
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
