import 'dart:ui';

import 'package:epic_nz/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'subscription_service.dart';

class SubscriptionController extends GetxController {
  final SubscriptionService service = SubscriptionService();

  final RxBool hasActivePlan = false.obs;
  final RxBool loading = false.obs;

  final RxString planType = "YEARLY".obs;

  final RxString currentPlan = "".obs;

  final RxBool isTrialActive = false.obs;
  final RxInt trialDaysLeft = 0.obs;

  final RxBool historyLoading = false.obs;
  final RxList<Map<String, dynamic>> purchaseHistory =
      <Map<String, dynamic>>[].obs;

  final Rx<DateTime?> subscriptionEndDate = Rx<DateTime?>(null);
  final RxString displayPlanName = "".obs;

  @override
  void onInit() {
    super.onInit();
    loadPurchaseHistory();
    loadSubscription();
  }

  Future<void> loadSubscription() async {
    try {
      final data = await service.fetchPurchaseHistory();

      if (data.isEmpty) {
        hasActivePlan.value = false;
        currentPlan.value = "";
        isTrialActive.value = false;
        trialDaysLeft.value = 0;
        return;
      }

      final latest = data.first;

      currentPlan.value = (latest['plan_type'] ?? latest['plan'] ?? "")
          .toString();

      displayPlanName.value = currentPlan.value == 'YEARLY'
          ? 'Adventure Pro (Yearly)'
          : currentPlan.value == 'MONTHLY'
          ? 'Adventure Pro (Monthly)'
          : 'Free Trial';

      subscriptionEndDate.value = latest['end_date'] != null
          ? DateTime.parse(latest['end_date'])
          : null;

      final status = latest['status'];
      final startDate = DateTime.parse(latest['start_date']);

      print("--- Subscription Debug Log ---");
      print("Backend Status: $status");
      print("Backend Start Date String: $startDate");

      final trialEnd = startDate.add(const Duration(days: 30));
      final now = DateTime.now();

print("Parsed Start Date (Local): $startDate");
print("Trial End Date: $trialEnd");
print("Current Phone Time: $now");
print("Is Before Trial End? ${now.isBefore(trialEnd)}");
print("-------------------------------");

      if (status == "PENDING" && now.isBefore(trialEnd)) {
        isTrialActive.value = true;
        trialDaysLeft.value = trialEnd.difference(now).inDays;
        hasActivePlan.value = true;
      } else {
        isTrialActive.value = false;
        trialDaysLeft.value = 0;
        hasActivePlan.value = status == "ACTIVE";
      }
    } catch (_) {
      hasActivePlan.value = false;
      isTrialActive.value = false;
      trialDaysLeft.value = 0;
      currentPlan.value = "";
    }
  }

  Future<void> subscribe() async {
    try {
      if (planType.value.isEmpty) {
        _showDialog(
          title: 'Plan not selected',
          message: 'Please select a subscription plan.',
        );
        return;
      }

      loading.value = true;

      final intent = await service.createPaymentIntent(planType.value);

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: intent['clientSecret'],
          merchantDisplayName: 'Epic NZ',
          customerId: intent['customerId'],
          style: ThemeMode.system,
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      await loadPurchaseHistory();
      await loadSubscription();

      _showDialog(
        title: 'Payment successful',
        message: 'Your subscription is now active 🎉',
        success: true,
      );
    } on StripeException catch (e) {
      _showDialog(
        title: 'Payment cancelled',
        message: e.error.message ?? 'The payment process was cancelled.',
      );
    } catch (_) {
      _showDialog(
        title: 'Payment failed',
        message:
            'Something went wrong while processing your payment. Please try again.',
      );
    } finally {
      loading.value = false;
    }
  }

  Future<void> upgradePlan() async {
    try {
      if (planType.value == currentPlan.value) {
        _showDialog(
          title: 'Already on this plan',
          message: 'You are already subscribed to the ${planType.value} plan.',
        );
        return;
      }

      loading.value = true;

      final res = await service.upgradePlan(planType.value);

      final String? status = res['status'];
      final String? clientSecret = res['clientSecret'];

      if (status == 'PENDING' && clientSecret != null) {
        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: clientSecret,
            merchantDisplayName: 'Epic NZ',
            style: ThemeMode.system,
          ),
        );

        await Stripe.instance.presentPaymentSheet();
      }

      await loadPurchaseHistory();
      await loadSubscription();

      _showDialog(
        title: 'Upgrade successful',
        message: 'Your plan has been upgraded to ${planType.value} 🎉',
        success: true,
      );
    } on StripeException catch (e) {
      _showDialog(
        title: 'Payment cancelled',
        message: e.error.message ?? 'Payment was cancelled',
      );
    } catch (e) {
      _showDialog(
        title: 'Upgrade failed',
        message: e.toString().replaceAll('Exception:', '').trim(),
      );
    } finally {
      loading.value = false;
    }
  }

  Future<void> turnOffAutoRenew() async {
    try {
      loading.value = true;

      await service.autoRenewOff();

      await loadPurchaseHistory();
      await loadSubscription();

      _showDialog(
        title: 'Auto-renew disabled',
        message:
            'Your subscription will remain active until the end of the current billing cycle.',
        success: true,
      );
    } catch (e) {
      _showDialog(
        title: 'Action failed',
        message: e.toString().replaceAll('Exception:', '').trim(),
      );
    } finally {
      loading.value = false;
    }
  }

  Future<void> loadPurchaseHistory() async {
    try {
      historyLoading.value = true;
      purchaseHistory.value = await service.fetchPurchaseHistory();
    } finally {
      historyLoading.value = false;
    }
  }

  bool get isPremium => hasActivePlan.value;

  void _showDialog({
    required String title,
    required String message,
    bool success = false,
  }) {
    final isDark = Get.isDarkMode;

    Get.dialog(
      Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              width: Get.width * 0.82,
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
              decoration: BoxDecoration(
                color: (isDark ? Colors.black : Colors.white).withValues(
                  alpha: 0.65,
                ),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: (success ? AppColors.green : Colors.grey).withValues(
                    alpha: 0.4,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 30,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 54,
                    width: 54,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (success ? AppColors.green : Colors.orange)
                          .withValues(alpha: 0.15),
                    ),
                    child: Icon(
                      success ? Icons.check_circle : Icons.info_outline,
                      size: 30,
                      color: success ? AppColors.green : Colors.orange,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      inherit: false,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                      decoration: TextDecoration.none,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      inherit: false,
                      fontSize: 14.5,
                      height: 1.4,
                      color: Colors.grey,
                      decoration: TextDecoration.none,
                    ),
                  ),

                  const SizedBox(height: 22),

                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      onPressed: () => Get.back(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.green,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26),
                        ),
                      ),
                      child: const Text(
                        'OK',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.35),
    );
  }
}
