import 'package:epic_nz/core/theme/app_colors.dart';
import 'package:epic_nz/core/theme/app_text_styles.dart';
import 'package:epic_nz/features/profile/profile_controller/profile_controller.dart';
import 'package:epic_nz/features/profile/widgets/collection_card.dart';
import 'package:epic_nz/features/profile/widgets/profile_header.dart';
import 'package:epic_nz/features/profile/widgets/profile_settings_tile.dart';
import 'package:epic_nz/features/profile/widgets/profile_stats_card.dart';
import 'package:epic_nz/features/profile/widgets/submission_tile.dart';
import 'package:epic_nz/routes/app_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../subscription/screens/purchase_history_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => controller.refreshAllProfileData(),
          color: AppColors.green,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ProfileHeader(),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: ProfileStatsCard(),
                ),
                const SizedBox(height: 28),

                _sectionTitle(
                  context,
                  title: 'My Submissions',
                  action: 'See All',
                  onActionTap: () => Get.to(() => const AllSubmissionsScreen()),
                ),
                const SizedBox(height: 12),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.greyLight,
                          backgroundColor: Colors.black,
                        ),
                      );
                    }
                    if (controller.mySubmissions.isEmpty) {
                      return const Text("No submissions yet.");
                    }

                    return Column(
                      children: controller.mySubmissions.take(2).map((item) {
                        return SubmissionTile(data: item);
                      }).toList(),
                    );
                  }),
                ),

                const SizedBox(height: 28),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Saved Collections',
                    style: AppTextStyles.h1.copyWith(
                      color: isDark ? Colors.white : AppColors.textPrimaryLight,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Obx(
                    () => GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      shrinkWrap: true,
                      childAspectRatio: 1.0,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        GestureDetector(
                          onTap: () => Get.toNamed(
                            AppRoutes.savedLocation,
                            arguments: "Epic Spots",
                          ),

                          child: CollectionCard(
                            title: 'Epic Spots',
                            subtitle:
                                '${controller.epicSavedCount.value}',
                            items: 'items',
                            imageUrl:
                                'https://images.unsplash.com/photo-1501785888041-af3ef285b470',
                            icon: Icons.auto_awesome,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Get.toNamed(
                            AppRoutes.savedLocation,
                            arguments: "Hikes",
                          ),

                          child: CollectionCard(
                            title: 'Hikes',
                            subtitle:
                                '${controller.hikeSavedCount.value}',
                            items: 'items',
                            imageUrl:
                                'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee',
                            icon: Icons.hiking,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Get.toNamed(
                            AppRoutes.savedLocation,
                            arguments: "Freedom Camping",
                          ),
                          child: CollectionCard(
                            title: 'Freedom Camping',
                            subtitle:
                                '${controller.campingSavedCount.value}',
                            items: 'items',
                            imageUrl:
                                'https://plus.unsplash.com/premium_photo-1661929257183-4b5850e31d5e',
                            icon: Icons.fireplace,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Get.toNamed(
                            AppRoutes.savedLocation,
                            arguments: "Campgrounds",
                          ),
                          child: CollectionCard(
                            title: 'Campground',
                            subtitle:
                                '${controller.campGroundSavedCount.value}',
                            items: 'items',
                            imageUrl:
                                'https://images.unsplash.com/photo-1504280390367-361c6d9f38f4',
                            icon: Icons.terrain,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.greenDarker.withValues(alpha: 0.35)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: isDark
                          ? []
                          : [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.06),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                    ),
                    child: Column(
                      children: [
                        ProfileSettingsTile(
                          icon: Icons.settings,
                          title: 'Settings',
                          onTap: () => Get.toNamed('/settings'),
                        ),
                        ProfileSettingsTile(
                          icon: Icons.notifications,
                          title: 'Notification',
                          onTap: () => Get.toNamed(AppRoutes.notification),
                        ),
                        ProfileSettingsTile(
                          icon: Icons.monetization_on_sharp,
                          title: 'Purchase History',
                          onTap: () {
                            Get.to(() => const PurchaseHistoryScreen());
                          },
                        ),
                        ProfileSettingsTile(
                          icon: Icons.help_outline,
                          title: 'Help & Support',
                          onTap: () => Get.toNamed(AppRoutes.helpSupport),
                          showDivider: false,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(
    BuildContext context, {
    required String title,
    String? action,
    VoidCallback? onActionTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Text(title, style: AppTextStyles.h1),
          const Spacer(),
          if (action != null)
            GestureDetector(
              onTap: onActionTap,
              child: Text(
                action,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.green,
                  fontWeight: FontWeight.w600,
                  fontSize: 16
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class AllSubmissionsScreen extends StatelessWidget {
  const AllSubmissionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final controller = Get.find<ProfileController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black12 : Colors.white,
        title: Obx(
          () => Text(
            controller.selectedIds.isEmpty
                ? "My Submissions"
                : "${controller.selectedIds.length} Selected",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          Obx(() {
            if (controller.selectedIds.isEmpty) return const SizedBox();
            return Row(
              children: [
                IconButton(
                  icon: Icon(
                    controller.isAllSelected
                        ? CupertinoIcons.checkmark_circle_fill
                        : CupertinoIcons.circle,
                    color: AppColors.green,
                    size: 24,
                  ),
                  onPressed: () => controller.toggleSelectAll(),
                ),

                IconButton(
                  icon: const Icon(
                    CupertinoIcons.trash,
                    color: Colors.redAccent,
                    size: 22,
                  ),
                  onPressed: () => _showDeleteDialog(controller),
                ),
              ],
            );
          }),
        ],
      ),
      body: Obx(
        () => ListView.builder(
          padding: const EdgeInsets.all(24),
          itemCount: controller.mySubmissions.length,
          itemBuilder: (context, index) {
            final data = controller.mySubmissions[index];
            return Obx(() {
              final isSelected = controller.selectedIds.contains(data['_id']);
              return GestureDetector(
                onLongPress: () => controller.toggleSelection(data['_id']),
                onTap: () {
                  if (controller.selectedIds.isNotEmpty) {
                    controller.toggleSelection(data['_id']);
                  }
                },
                child: SubmissionTile(data: data, isSelected: isSelected),
              );
            });
          },
        ),
      ),
    );
  }

  void _showDeleteDialog(ProfileController controller) {
    Get.defaultDialog(
      title: "Delete?",
      middleText: "Delete ${controller.selectedIds.length} selected items?",
      textConfirm: "Delete",
      confirmTextColor: Colors.white,
      buttonColor: Colors.redAccent,
      onConfirm: () {
        Get.back();
        controller.deleteSelectedSubmissions();
      },
    );
  }
}
