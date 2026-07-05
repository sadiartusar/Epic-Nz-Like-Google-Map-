import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_back_button.dart';
import '../notification_controller.dart';

class NotificationHeader extends StatelessWidget {
  const NotificationHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotificationController>();

    return Row(
      children: [
        const AppBackButton(),

        const Spacer(),

        Text('Notification', style: AppTextStyles.h1.copyWith(
          fontSize: 18
        )),

        const Spacer(),

        GestureDetector(
          onTap: controller.markAllRead,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.green),
            ),
            child: const Row(
              children: [
                Text(
                  'Mark All Read',
                  style: TextStyle(
                    color: AppColors.green,
                    fontWeight: FontWeight.w600,
                    fontSize: 12
                  ),
                ),
                SizedBox(width: 6),
                Icon(Icons.check, size: 16, color: AppColors.green),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
