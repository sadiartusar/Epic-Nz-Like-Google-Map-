import 'package:flutter/material.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/theme/app_text_styles.dart';

class OfflineMapHeader extends StatelessWidget {
  const OfflineMapHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const AppBackButton(),
          const SizedBox(width: 12),
          Text(
            'Offline Maps',
            style: AppTextStyles.h1.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
