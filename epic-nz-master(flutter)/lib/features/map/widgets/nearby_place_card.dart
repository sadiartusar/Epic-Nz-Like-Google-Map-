import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class NearbyPlaceCard extends StatelessWidget {
  final String tag;
  final String name;
  final String imageUrl;
  final String distance;
  final String rating;

  const NearbyPlaceCard({
    super.key,
    required this.tag,
    required this.name,
    required this.imageUrl,
    required this.distance,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.transparent,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              height: 110,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey[300],
                child: const Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.green,
                    ),
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[200],
                child: const Icon(
                  Icons.image_not_supported_outlined,
                  color: Colors.grey,
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _tagColor(tag).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '#$tag',
                    style: AppTextStyles.micro.copyWith(
                      fontWeight: FontWeight.w600,
                      color: _tagColor(tag),
                      fontSize: 12,
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : AppColors.textPrimaryLight,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 4),

                Row(
                  children: [
                    const Icon(Icons.place, size: 18, color: AppColors.green),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '$distance away',
                        style: AppTextStyles.micro.copyWith(
                          color: isDark
                              ? Colors.white70
                              : AppColors.textSecondaryLight,
                          fontSize: 14,
                        ),

                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    const Icon(Icons.star, size: 18, color: Colors.amber),
                    const SizedBox(width: 2),
                    Text(
                      rating,
                      style: AppTextStyles.micro.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _tagColor(String tag) {
    switch (tag) {
      case 'Epic Photo Spot':
      case 'Epic':
        return Colors.purple;
      case 'Hike':
      case 'Hikes':
        return Colors.blue;
      case 'Campground':
      case 'Camping':
        return Colors.indigo;
      case 'Freedom Camping':
      case 'Freedom':
        return Colors.orange;
      case 'Photos':
      case 'Photo Spots':
        return AppColors.green;
      default:
        return AppColors.green;
    }
  }
}
