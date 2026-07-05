import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class OfflineMapControls extends StatelessWidget {
  const OfflineMapControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _controlButton(Icons.add),
        const SizedBox(height: 10),
        _controlButton(Icons.remove),
        const SizedBox(height: 14),
        _controlButton(Icons.my_location, filled: true),
      ],
    );
  }

  Widget _controlButton(IconData icon, {bool filled = false}) {
    return Container(
      height: 44,
      width: 44,
      decoration: BoxDecoration(
        color: filled ? AppColors.green : Colors.black.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, color: filled ? Colors.white : Colors.white70),
    );
  }
}
