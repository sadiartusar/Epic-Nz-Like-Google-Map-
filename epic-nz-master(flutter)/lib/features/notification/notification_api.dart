import 'package:dio/dio.dart';
import '../../core/base_url/api_constants.dart';
import '../../core/service/storage_service.dart';

class NotificationApi {
  final Dio _dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));

  Future<Map<String, dynamic>> getMyNotifications({int page = 1}) async {
    final token = await StorageService.getToken();

    if (token == null || token.isEmpty) {
      throw Exception("User not authenticated");
    }

    final res = await _dio.get(
      "notification/me?page=$page",
      options: Options(headers: ApiConstants.headers(token)),
    );

    return {"data": res.data['data'] ?? [], "meta": res.data['meta'] ?? {}};
  }

  Future<void> markAsRead(String notificationId) async {
    final token = await StorageService.getToken();
    if (token == null || token.isEmpty) {
      throw Exception("User not authenticated");
    }

    await _dio.patch(
      "notification/read/$notificationId",
      options: Options(headers: ApiConstants.headers(token)),
    );
  }

  Future<void> markAllRead() async {
    final token = await StorageService.getToken();
    if (token == null || token.isEmpty) {
      throw Exception("User not authenticated");
    }

    await _dio.patch(
      "notification/read-all",
      options: Options(headers: ApiConstants.headers(token)),
    );
  }

  Future<Map<String, dynamic>> getAdmins() async {
    final token = await StorageService.getToken();
    final response = await _dio.get(
      'chat/admin-messages',
      options: Options(headers: ApiConstants.headers(token)),
    );
    return response.data;
  }
}
