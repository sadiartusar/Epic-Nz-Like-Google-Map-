import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../notification_controller.dart';
import '../widgets/notification_header.dart';
import '../widgets/notification_tile.dart';
import '../../preferences/controller/preferences_controller.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({super.key});

  final NotificationController controller = Get.put(NotificationController());

  final PreferencesController prefs = Get.find<PreferencesController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          if (!prefs.notificationsEnabled.value) {
            return _NotificationsOffView(
              onEnable: () {
                prefs.setNotification(true);
              },
            );
          }

          if (controller.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.greenActive),
            );
          }

          return RefreshIndicator(
            color: AppColors.greenDark,
            onRefresh: () => controller.fetch(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const NotificationHeader(),
                  const SizedBox(height: 24),

                  if (controller.notifications.isEmpty)
                    _EmptyState()
                  else
                    ...controller.groupedNotifications.entries.map(
                      (entry) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Text(
                              entry.key,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),

                          ...entry.value.map(
                            (n) => GestureDetector(
                              onTap: () async {
                                if (n['isRead'] == false) {
                                  await controller.markRead(n['_id']);
                                }

                                final Map<String, dynamic>? data =
                                    n['data'] != null
                                    ? Map<String, dynamic>.from(n['data'])
                                    : null;

                                if (data == null) return;

                                final String? deepLink = data['deepLink'];

                                if (deepLink != null &&
                                    deepLink.startsWith('/location/')) {
                                  final String? locationId = data['locationId'];

                                  if (locationId != null) {
                                    Get.toNamed(
                                      AppRoutes.spotDetail,
                                      arguments: {'locationId': locationId},
                                    );
                                  }
                                  return;
                                }

                                if (deepLink != null &&
                                    deepLink.startsWith('/chat/')) {
                                  final String? chatId = data['chatId'];

                                  if (chatId != null) {
                                    Get.toNamed(
                                      AppRoutes.supportChat,
                                      arguments: {'adminId': chatId},
                                    );
                                  }
                                }
                              },
                              child: NotificationTile(
                                title: n['title'] ?? '',
                                message: n['body'] ?? '',
                                time: _timeAgo(n['createdAt']),
                                isUnread: n['isRead'] == false,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  String _timeAgo(String isoDate) {
    final date = DateTime.parse(isoDate);
    final diff = DateTime.now().difference(date);

    if (diff.inMinutes < 60) {
      return "${diff.inMinutes}m ago";
    } else if (diff.inHours < 24) {
      return "${diff.inHours}h ago";
    } else {
      return "${diff.inDays}d ago";
    }
  }
}

class _NotificationsOffView extends StatelessWidget {
  final VoidCallback onEnable;

  const _NotificationsOffView({required this.onEnable});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              CupertinoIcons.bell_slash,
              size: 80,
              color: AppColors.greyLight,
            ),
            const SizedBox(height: 20),
            const Text(
              "Notifications are turned off",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              "Turn on notifications to get updates about approvals, messages, and activity.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 28),
            glassActionButton(
              onPressed: onEnable,
              icon: CupertinoIcons.bell,
              label: "Turn On Notifications",
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 120),
      child: Center(
        child: Column(
          children: [
            Icon(
              CupertinoIcons.bell_solid,
              size: 80,
              color: AppColors.greyLight,
            ),
            SizedBox(height: 12),
            Text(
              "You're all caught up",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget glassActionButton({
  required VoidCallback onPressed,
  required IconData icon,
  required String label,
}) {
  final isDark = Theme.of(Get.context!).brightness == Brightness.dark;

  return ClipRRect(
    borderRadius: BorderRadius.circular(14),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
      child: Container(
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.12)
              : Colors.black.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.25)
                : Colors.black.withValues(alpha: 0.15),
          ),
        ),
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, color: Colors.white),
          label: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),
    ),
  );
}
