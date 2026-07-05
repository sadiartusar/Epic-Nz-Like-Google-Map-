import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static Future<void> saveToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  static Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<void> removeToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  static Future<void> saveUserId(String userId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
  }

  static Future<String?> getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  static Future<void> saveUserName(String name) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', name);
  }

  static Future<String?> getUserName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userName');
  }

  static Future<void> saveUserData(
    String name,
    String profilePic,
    String coverPic,
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', name);
    await prefs.setString('profilePic', profilePic);
    await prefs.setString('coverPic', coverPic);
  }

  static Future<Map<String, String?>> getUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString('userName'),
      'profilePic': prefs.getString('profilePic'),
      'coverPic': prefs.getString('coverPic'),
    };
  }

  static Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print("All local data cleared successfully.");
  }

  static Future<void> saveProfileCache(Map<String, dynamic> data) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_cache', jsonEncode(data));
  }

  static Future<Map<String, dynamic>?> getProfileCache() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('profile_cache');
    if (raw == null) return null;
    return jsonDecode(raw);
  }

  static Future<void> clearProfileCache() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('profile_cache');
  }
}
