import 'package:flutter/material.dart';
import '../../../core/theme/app_text_styles.dart';

class NotificationSectionTitle extends StatelessWidget {
  final String title;

  const NotificationSectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
    );
  }
}
