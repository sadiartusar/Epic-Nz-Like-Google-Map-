import 'package:dio/dio.dart';
import '../../../core/base_url/api_constants.dart';
import '../../../core/service/storage_service.dart';

class SubscriptionService {
  late final Dio _dio;

  SubscriptionService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ),
    );
  }

  Future<Options> _authOptions() async {
    final token = await StorageService.getToken();
    return Options(headers: ApiConstants.headers(token));
  }

  Future<Map<String, dynamic>> createPaymentIntent(String plan) async {
    try {
      final response = await _dio.post(
        'subscription/intent',
        data: {"plan": plan},
        options: await _authOptions(),
      );

      return response.data['data'];
    } on DioException catch (e) {
      final msg =
          e.response?.data['message'] ?? 'Failed to create payment intent';
      throw Exception(msg);
    }
  }

  Future<Map<String, dynamic>> upgradePlan(String plan) async {
    try {
      final response = await _dio.patch(
        'subscription/upgrade',
        data: {"plan": plan},
        options: await _authOptions(),
      );

      return response.data['data'];
    } on DioException catch (e) {
      final msg = e.response?.data['message'] ?? 'Failed to upgrade plan';
      throw Exception(msg);
    }
  }

  Future<List<Map<String, dynamic>>> fetchPurchaseHistory() async {
    try {
      final response = await _dio.get(
        'subscription/my',
        options: await _authOptions(),
      );

      final List data = response.data['data'] ?? [];
      return data
          .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> autoRenewOff() async {
    try {
      await _dio.patch(
        'subscription/auto_renew/off',
        options: await _authOptions(),
      );
    } on DioException catch (e) {
      final msg =
          e.response?.data['message'] ?? 'Failed to turn off auto-renew';
      throw Exception(msg);
    }
  }
}
