import 'package:epic_nz/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class DetailAbout extends StatelessWidget {
  final String name;
  final String description;
  final String category;

  const DetailAbout({
    super.key,
    required this.name,
    required this.description,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "About",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 10),

        Text(
          description,
          style: TextStyle(
            fontSize: 16,
            color: isDark ? Colors.white70 : AppColors.grey,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
