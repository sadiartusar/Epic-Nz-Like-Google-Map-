import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../core/service/storage_service.dart';
import '../../routes/app_routes.dart';
import 'notification_api.dart';

class NotificationController extends GetxController {
  final NotificationApi api = NotificationApi();

  final notifications = <Map<String, dynamic>>[].obs;

  final groupedNotifications = <String, List<Map<String, dynamic>>>{}.obs;

  final unreadCount = 0.obs;

  final isLoading = false.obs;
  final page = 1.obs;
  final hasMore = true.obs;
  String? adminId;

  @override
  void onInit() {
    super.onInit();
    fetch();
  }

  Future<void> fetch({bool loadMore = false}) async {
    try {
      final token = await StorageService.getToken();

      if (token == null || token.isEmpty) {
        debugPrint("🚫 No token, skipping notification fetch");
        return;
      }

      if (!loadMore) {
        page.value = 1;
        notifications.clear();
        hasMore.value = true;
      }

      isLoading.value = true;

      final res = await api.getMyNotifications(page: page.value);

      final rawData = res['data'];

      List list = [];

      if (rawData is List) {
        list = rawData;
      } else if (rawData is Map && rawData['result'] is List) {
        list = rawData['result'];
      }

      final List<Map<String, dynamic>> parsed = list
          .map((e) => Map<String, dynamic>.from(e))
          .toList();

      notifications.addAll(parsed);

      _groupByDate();
      _updateUnreadCount();

      final meta = res['meta'];
      hasMore.value = page.value < (meta?['totalPage'] ?? 1);
      page.value++;
    } catch (e) {
      debugPrint("❌ Notification fetch error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void _groupByDate() {
    final Map<String, List<Map<String, dynamic>>> grouped = {};

    for (final n in notifications) {
      final date = DateTime.parse(n['createdAt']);
      final key = _dateLabel(date);

      grouped.putIfAbsent(key, () => []);
      grouped[key]!.add(n);
    }

    groupedNotifications.value = grouped;
  }

  void _updateUnreadCount() {
    unreadCount.value = notifications.where((n) => n['isRead'] == false).length;
  }

  String _dateLabel(DateTime date) {
    final now = DateTime.now();

    if (_isSameDay(date, now)) return "Today";
    if (_isSameDay(date, now.subtract(const Duration(days: 1)))) {
      return "Yesterday";
    }

    return DateFormat("dd MMM yyyy").format(date);
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Future<void> markRead(String id) async {
    await api.markAsRead(id);

    final index = notifications.indexWhere((n) => n['_id'] == id);
    if (index != -1 && notifications[index]['isRead'] == false) {
      notifications[index]['isRead'] = true;
      notifications.refresh();
      _groupByDate();
      _updateUnreadCount();
    }
  }

  Future<void> markAllRead() async {
    if (unreadCount.value == 0) return;

    isLoading.value = true;
    await api.markAllRead();

    for (final n in notifications) {
      n['isRead'] = true;
    }

    notifications.refresh();
    _groupByDate();
    _updateUnreadCount();
    isLoading.value = false;
  }

  Future<void> fetchAdminId() async {
    try {
      final res = await api.getAdmins();
      if (res['data'] != null && (res['data'] as List).isNotEmpty) {
        adminId = res['data'][0]['_id'];
        debugPrint("✅ Resolved AdminId for Notification: $adminId");
      }
    } catch (e) {
      debugPrint("❌ Error fetching admin list: $e");
    }
  }

  void handleNotificationTap(Map<String, dynamic> n) {
    if (n['isRead'] == false) {
      markRead(n['_id']);
    }

    final Map<String, dynamic>? data = n['data'] != null
        ? Map<String, dynamic>.from(n['data'])
        : null;

    if (data == null) return;

    final String? deepLink = data['deepLink'];
    if (deepLink == null) return;

    if (deepLink.startsWith('/location/')) {
      final String? locationId = data['locationId'];

      if (locationId != null) {
        Get.toNamed(
          AppRoutes.spotDetail,
          arguments: {'locationId': locationId},
        );
      }
      return;
    }

    if (deepLink.startsWith('/chat/')) {
      String? targetAdminId = adminId ?? data['senderId'];

      Get.toNamed(AppRoutes.supportChat, arguments: {'adminId': targetAdminId});
    }
  }

  bool get isEmpty => notifications.isEmpty && !isLoading.value;
}
