import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class CollectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String items;
  final String? imageUrl;
  final IconData? icon;
  final bool isAdd;

  const CollectionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.items,
    this.imageUrl,
    this.icon,
    this.isAdd = false,
  });

  @override
  Widget build(BuildContext context) {
    // final isDark = Theme.of(context).brightness == Brightness.dark;
    // final Color textColor = isDark ? Colors.white : Colors.black87;
    // final Color secondaryTextColor = isDark ? Colors.white70 : Colors.black54;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: isAdd ? Border.all(color: AppColors.green) : null,
      ),
      child: Stack(
        children: [
          if (!isAdd && imageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Opacity(
                opacity: 0.3,
                child: Image.network(
                  imageUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),

          if (!isAdd)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.7),
                    Colors.transparent,
                  ],
                ),
              ),
            ),

          Center(
            child: isAdd
                ? const Icon(Icons.add, color: AppColors.green, size: 36)
                : Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icon, color: Colors.white),

                        const SizedBox(height: 10),

                        Text(
                          title,
                          style: AppTextStyles.h1.copyWith(color: Colors.white),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 4),

                        Flexible(
                          child: Text(
                            subtitle,
                            style: AppTextStyles.h1.copyWith(
                              color: Colors.white70,
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          items,
                          style: AppTextStyles.label.copyWith(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
