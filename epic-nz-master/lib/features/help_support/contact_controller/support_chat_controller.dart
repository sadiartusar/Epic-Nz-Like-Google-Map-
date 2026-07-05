import 'package:epic_nz/core/base_url/api_constants.dart';
import 'package:epic_nz/core/service/socket_service.dart';
import 'package:epic_nz/core/service/storage_service.dart';
import 'package:epic_nz/features/help_support/model/chat_massage_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;

class SupportChatController extends GetxController {
  final dio.Dio _dio = dio.Dio(dio.BaseOptions(baseUrl: ApiConstants.baseUrl));
  final SocketChatService _socketService = SocketChatService();

  final messages = <ChatMessage>[].obs;
  final inputCtrl = TextEditingController();
  final scrollCtrl = ScrollController();

  final isConnected = false.obs;
  final isSending = false.obs;
  final isHistoryLoading = false.obs;

  String? userId;
  String? adminId;

  @override
  void onInit() {
    super.onInit();
    _boot();
  }

  Future<void> _boot() async {
    debugPrint("🚀 Boot started");

    userId = await StorageService.getUserId();
    debugPrint("👤 UserId from storage: $userId");

    if (userId == null) {
      debugPrint("❌ UserId is NULL");
      return;
    }

    await resolveAdminFromConversation();

    debugPrint("🧑‍💼 Resolved AdminId: $adminId");

    if (adminId == null) {
      debugPrint("❌ AdminId still NULL after resolve");
      return;
    }

    await fetchChatHistory();

    debugPrint("📨 Messages after history load: ${messages.length}");

    _socketService.connect(
      userId: userId!,
      onConnected: () {
        debugPrint("✅ Socket connected");
        isConnected.value = true;
      },
      onMessage: (data) {
        debugPrint("📩 Socket message received: $data");

        final incoming = ChatMessage.fromSocket(data);

        final exists = messages.any((m) => m.id == incoming.id);
        if (!exists) {
          messages.add(incoming);
          _scrollToBottom();
        }
      },
      onError: (err) => debugPrint("❌ Socket Error: $err"),
    );
  }

  // Future<void> resolveAdminFromConversation() async {
  //   try {
  //     debugPrint("📡 Calling chat/admin-messages");
  //
  //     final token = await StorageService.getToken();
  //     debugPrint("🔐 Token: $token");
  //
  //     final response = await _dio.get(
  //       "chat/admin-messages",
  //       options: dio.Options(headers: ApiConstants.headers(token)),
  //     );
  //
  //     debugPrint("📦 Conversations response: ${response.data}");
  //
  //     if (response.statusCode == 200) {
  //       final List list = response.data['data'] ?? [];
  //
  //       debugPrint("📊 Conversations count: ${list.length}");
  //
  //       if (list.isNotEmpty) {
  //         final first = list.first;
  //         final user = first['user'];
  //
  //         debugPrint("👤 First conversation user: $user");
  //
  //         if (user != null && user['_id'] != null) {
  //           adminId = user['_id'].toString();
  //           debugPrint("✅ Admin resolved: $adminId");
  //         }
  //       }
  //     }
  //   } catch (e) {
  //     debugPrint("❌ Resolve admin error: $e");
  //   }
  // }

  Future<void> resolveAdminFromConversation() async {
    try {
      debugPrint("📡 Calling chat/admin-messages");

      final token = await StorageService.getToken();

      final response = await _dio.get(
        "chat/admin-messages",
        options: dio.Options(headers: ApiConstants.headers(token)),
      );

      debugPrint("📦 Conversations response: ${response.data}");

      if (response.statusCode == 200) {
        final List list = response.data['data'] ?? [];

        debugPrint("📊 Admin count: ${list.length}");

        if (list.isNotEmpty) {
          final adminObject = list.first;

          debugPrint("👤 Admin Object: $adminObject");

          if (adminObject != null && adminObject['_id'] != null) {
            adminId = adminObject['_id'].toString();
            debugPrint("✅ Admin resolved: $adminId");
          }
        }
      }
    } catch (e) {
      debugPrint("❌ Resolve admin error: $e");
    }
  }

  Future<void> fetchChatHistory() async {
    try {
      debugPrint("📡 Fetching history for adminId: $adminId");

      isHistoryLoading.value = true;

      final token = await StorageService.getToken();

      final response = await _dio.get(
        "chat/messages/$adminId",
        options: dio.Options(headers: ApiConstants.headers(token)),
      );

      debugPrint("📦 History response: ${response.data}");

      if (response.statusCode == 200) {
        final List<ChatMessage> list = (response.data['data'] as List)
            .map((e) => ChatMessage.fromApi(Map<String, dynamic>.from(e)))
            .toList();

        messages.assignAll(list);

        debugPrint("✅ Loaded messages count: ${messages.length}");

        _scrollToBottom();
      }
    } catch (e) {
      debugPrint("❌ History error: $e");
    } finally {
      isHistoryLoading.value = false;
    }
  }

  Future<void> sendMessage() async {
    debugPrint("📤 Trying to send message");
    debugPrint("👤 userId: $userId");
    debugPrint("🧑‍💼 adminId: $adminId");
    final text = inputCtrl.text.trim();

    if (text.isEmpty || userId == null) return;

    if (adminId == null) {
      debugPrint("❌ Cannot send, admin not resolved");
      return;
    }

    final tempMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: userId!,
      receiverId: adminId!,
      text: text,
      createdAt: DateTime.now(),
    );

    messages.add(tempMessage);
    inputCtrl.clear();
    _scrollToBottom();

    isSending.value = true;

    try {
      final token = await StorageService.getToken();

      final response = await _dio.post(
        "chat/send_message/$adminId",
        data: {
          "message": {"text": text},
        },
        options: dio.Options(headers: ApiConstants.headers(token)),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final serverMessage = ChatMessage.fromApi(
          Map<String, dynamic>.from(response.data['data']),
        );

        final index = messages.indexWhere((m) => m.id == tempMessage.id);
        if (index != -1) {
          messages[index] = serverMessage;
        }
      }
    } catch (e) {
      debugPrint("❌ Send error: $e");
      messages.removeWhere((m) => m.id == tempMessage.id);
    } finally {
      isSending.value = false;
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 250), () {
      if (scrollCtrl.hasClients) {
        scrollCtrl.animateTo(
          scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void onClose() {
    inputCtrl.dispose();
    scrollCtrl.dispose();
    _socketService.disconnect();
    super.onClose();
  }
}
