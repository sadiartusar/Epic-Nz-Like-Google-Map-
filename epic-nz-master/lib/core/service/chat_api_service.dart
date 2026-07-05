import 'package:dio/dio.dart';
import 'package:epic_nz/core/base_url/api_constants.dart';
import 'package:epic_nz/core/service/storage_service.dart';
import 'package:epic_nz/features/help_support/model/chat_massage_model.dart';

class ChatApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));

  Future<ChatMessage> sendMessage({
    required String receiverId,
    required String text,
  }) async {
    final token = await StorageService.getToken();

    final res = await _dio.post(
      'chat/send_message/$receiverId',
      data: {
        "message": {"text": text},
      },
      options: Options(headers: ApiConstants.headers(token)),
    );

    final data = (res.data["data"] as Map).cast<String, dynamic>();
    return ChatMessage.fromApi(data);
  }
}
