import 'package:cached_network_image/cached_network_image.dart';
import 'package:epic_nz/features/save_location/controller/bookmark_controller.dart';
import 'package:epic_nz/features/save_location/model/location_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonSpotCard extends StatelessWidget {
  final LocationModel spot;
  final VoidCallback onTap;
  final String category;

  const CommonSpotCard({
    super.key,
    required this.spot,
    required this.onTap,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final bookmarkController = Get.find<BookmarkController>();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 250,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          image: DecorationImage(
            image: CachedNetworkImageProvider(
              spot.image,
              maxHeight: 800,
              maxWidth: 800,
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.75),
                  ],
                ),
              ),
            ),

            Positioned(
              top: 15,
              right: 15,
              child: Obx(
                () => GestureDetector(
                  onTap: () => bookmarkController.toggleBookmark(spot),
                  child: Icon(
                    bookmarkController.isBookmarked(spot.id)
                        ? Icons.bookmark
                        : Icons.bookmark_outline,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ),

            Positioned(top: 18, left: 18, child: _categoryChip(category)),

            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    spot.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.white70,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          spot.location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _categoryChip(String category) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white24),
      ),
      child: Text(
        category,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
