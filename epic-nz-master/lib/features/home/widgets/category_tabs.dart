import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class CategoryTabs extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategoryChanged;

  const CategoryTabs({
    super.key,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final List<Map<String, dynamic>> categories = [
      {'label': 'All', 'value': 'All', 'color': Colors.grey},
      {
        'label': 'Epic Spots',
        'value': 'Epic Photo Spot',
        'color': Colors.purple,
      },
      {'label': 'Hikes', 'value': 'Hike', 'color': Colors.lightBlue},
      {'label': 'Camping', 'value': 'Campground', 'color': Colors.indigoAccent},
      {'label': 'Freedom', 'value': 'Freedom Camping', 'color': Colors.green},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: categories.map((cat) {
          final bool isSelected = selectedCategory == cat['value'];

          return GestureDetector(
            onTap: () => onCategoryChanged(cat['value']),
            child: Container(
              margin: const EdgeInsets.only(right: 12, bottom: 8, top: 8),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected
                    ? (isDark ? Colors.white : Colors.black)
                    : (isDark ? Colors.white10 : Colors.white),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isSelected
                      ? Colors.transparent
                      : (isDark ? Colors.white10 : AppColors.greyLight),
                ),
                boxShadow: [
                  if (isSelected || !isDark)
                    BoxShadow(
                      color: isDark
                          ? Colors.black.withValues(alpha: 0.4)
                          : Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                ],
              ),
              child: Row(
                children: [
                  if (cat['label'] != 'All') ...[
                    CircleAvatar(radius: 4, backgroundColor: cat['color']),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    cat['label'],
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? (isDark ? Colors.black : Colors.white)
                          : (isDark ? Colors.white : Colors.black54),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
