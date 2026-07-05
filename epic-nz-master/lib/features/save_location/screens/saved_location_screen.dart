import 'package:epic_nz/core/theme/app_colors.dart';
import 'package:epic_nz/features/save_location/controller/bookmark_controller.dart';
import 'package:epic_nz/features/save_location/model/location_model.dart';
import 'package:epic_nz/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SavedLocationScreen extends StatefulWidget {
  const SavedLocationScreen({super.key});

  @override
  State<SavedLocationScreen> createState() => _SavedLocationScreenState();
}

class _SavedLocationScreenState extends State<SavedLocationScreen> {
  String _selectedFilter = "All";

  @override
  void initState() {
    super.initState();
    if (Get.arguments != null && Get.arguments is String) {
      _selectedFilter = Get.arguments;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bookmarkController = Get.find<BookmarkController>();
      bookmarkController.fetchSavedLocations();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final BookmarkController controller = Get.find<BookmarkController>();

    final Color bgColor = isDark ? Colors.black : const Color(0xFFF8F9FA);
    final Color appBarColor = isDark ? Colors.black : Colors.white;
    final Color titleColor = isDark ? Colors.white : Colors.black;
    final Color cardColor = isDark
        ? AppColors.greenDarker.withValues(alpha: 0.35)
        : Colors.white;
    final Color subTitleColor = isDark ? Colors.white54 : Colors.black54;
    final Color chipUnselectedColor = isDark
        ? const Color(0xFF1E1E1E)
        : Colors.grey[200]!;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Saved Location",
          style: TextStyle(
            color: titleColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildFilterChip("All", isDark, chipUnselectedColor),
                _buildFilterChip(
                  "Epic Spots",
                  isDark,
                  chipUnselectedColor,
                  dotColor: Colors.purpleAccent,
                ),
                _buildFilterChip(
                  "Hikes",
                  isDark,
                  chipUnselectedColor,
                  dotColor: Colors.lightBlueAccent,
                ),
                _buildFilterChip(
                  "Campgrounds",
                  isDark,
                  chipUnselectedColor,
                  dotColor: Colors.indigoAccent,
                ),
                _buildFilterChip(
                  "Freedom Camping",
                  isDark,
                  chipUnselectedColor,
                  dotColor: Colors.lightGreenAccent,
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.green),
                );
              }

              final filteredList = controller.savedLocations.where((item) {
                if (_selectedFilter == "All") return true;

                String cat = item.category.toLowerCase().trim();

                if (_selectedFilter == "Epic Spots") {
                  return cat == "epic photo spot" || cat == "epic";
                }
                if (_selectedFilter == "Hikes") {
                  return cat == "hike";
                }
                if (_selectedFilter == "Campgrounds") {
                  return cat == "campground";
                }
                if (_selectedFilter == "Freedom Camping") {
                  return cat == "freedom camping";
                }

                return false;
              }).toList();

              if (filteredList.isEmpty) {
                return Center(
                  child: Text(
                    "No saved locations found in $_selectedFilter",
                    style: TextStyle(color: subTitleColor),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 0,
                  bottom: 100,
                ),
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  final spot = filteredList[index];
                  return _buildLocationCard(
                    spot: spot,
                    isDark: isDark,
                    cardColor: cardColor,
                    titleColor: titleColor,
                    subTitleColor: subTitleColor,
                    onRemove: () => controller.toggleBookmark(spot),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationCard({
    required LocationModel spot,
    required bool isDark,
    required Color cardColor,
    required Color titleColor,
    required Color subTitleColor,
    required VoidCallback onRemove,
  }) {
    Color categoryColor = spot.category == "Epic Photo Spot"
        ? Colors.purpleAccent
        : Colors.blueAccent;
    if (spot.category == "Campground") categoryColor = Colors.indigoAccent;

    IconData infoIcon = spot.category == "Epic Photo Spot"
        ? Icons.auto_awesome
        : Icons.hiking;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: categoryColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        spot.category.split(' ')[0],
                        style: TextStyle(
                          color: categoryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Icon(infoIcon, color: Colors.orangeAccent, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      spot.weatherOrRating,
                      style: TextStyle(color: subTitleColor, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  spot.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  spot.location,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: subTitleColor, fontSize: 16),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(
                      Icons.near_me_outlined,
                      color: Colors.grey,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      spot.distance,
                      style: TextStyle(color: subTitleColor, fontSize: 16),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(
                          AppRoutes.spotDetail,
                          arguments: {
                            '_id': spot.id,
                            'name': spot.title,
                            'imageUrl': [spot.image],
                            'address': spot.location,
                            'category': spot.category,
                            'ratings': [],
                            'coordinates': {
                              'coordinates': [0.0, 0.0],
                            },
                          },
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.green,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Text(
                          "View",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.network(
                  spot.image,
                  width: 95,
                  height: 95,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: onRemove,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      color: Colors.black38,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.bookmark,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    String label,
    bool isDark,
    Color unselectedBg, {
    Color? dotColor,
  }) {
    bool isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = label),
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? Colors.white : Colors.black)
              : unselectedBg,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          children: [
            if (dotColor != null)
              Container(
                height: 8,
                width: 8,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
            if (dotColor != null) const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? (isDark ? Colors.black : Colors.white)
                    : (isDark ? Colors.white : Colors.black87),
                fontWeight: FontWeight.w500,
                fontSize: 16
              ),
            ),
          ],
        ),
      ),
    );
  }
}
