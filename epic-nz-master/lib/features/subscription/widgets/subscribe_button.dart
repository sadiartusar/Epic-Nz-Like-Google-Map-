import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/subscription_controller.dart';
import '../../../core/theme/app_colors.dart';

class SubscribeButton extends StatelessWidget {
  const SubscribeButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SubscriptionController>();

    return Obx(
      () => SizedBox(
        height: 54,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: controller.loading.value ? null : controller.subscribe,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: controller.loading.value
              ? const CircularProgressIndicator(color: Colors.white)
              : Text('Subscribe', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
