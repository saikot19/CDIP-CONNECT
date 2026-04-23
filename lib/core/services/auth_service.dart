import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../database/database_helper.dart';
import '../models/login_response_model.dart';
import 'api_service.dart';

final authProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<void>>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<AsyncValue<void>> {
  AuthNotifier() : super(const AsyncValue.data(null));

  Future<Map<String, dynamic>> sendOtp(String phone) async {
    state = const AsyncValue.loading();
    try {
      final response = await ApiService.sendOtp(phone);
      state = const AsyncValue.data(null);
      return response;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    state = const AsyncValue.loading();
    try {
      final response = await ApiService.verifyOtp(phone: phone, otp: otp);
      state = const AsyncValue.data(null);
      return response;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<LoginResponse> login({
    required String phone,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    try {
      final response = await ApiService.login(phone: phone, password: password);
      state = const AsyncValue.data(null);
      return response;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}

final otpTimerProvider = StateNotifierProvider<OtpTimerNotifier, int>((ref) {
  return OtpTimerNotifier();
});

class OtpTimerNotifier extends StateNotifier<int> {
  OtpTimerNotifier() : super(0);

  void startTimer() {
    state = 240;
    _startCountdown();
  }

  void _startCountdown() {
    Future.delayed(const Duration(seconds: 1), () {
      if (state > 0) {
        state--;
        _startCountdown();
      }
    });
  }

  void reset() {
    state = 0;
  }
}

class AuthService {
  static const String _keyIsLoggedIn = 'isLoggedIn';
  static const String _keyMemberName = 'memberName';
  static const String _keyMemberId = 'memberId';
  static const String _keyAccessToken = 'accessToken';
  static const String _keyLastUpdated = 'lastUpdated';
  static const String _keyAppVersion = 'appVersion';

  static Future<void> saveUserSession(LoginResponse response) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final db = DatabaseHelper();

      print('🔐 Saving user session...');

      await prefs.setBool(_keyIsLoggedIn, true);
      await prefs.setString(_keyMemberName, response.userData.name);
      await prefs.setString(_keyMemberId, response.userData.id);
      await prefs.setString(_keyAccessToken, response.accessToken);
      await prefs.setString(_keyLastUpdated, response.lastUpdated);
      await prefs.setString(_keyAppVersion, response.appVersion);

      await db.saveLoginResponse(response);

      print('✅ User session saved successfully');
    } catch (e) {
      print('❌ Error saving user session: $e');
      rethrow;
    }
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  static Future<String> getMemberName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyMemberName) ?? '';
  }

  static Future<String> getMemberId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyMemberId) ?? '';
  }

  static Future<String> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyAccessToken) ?? '';
  }

  static Future<String> getLastUpdated() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyLastUpdated) ?? '';
  }

  static Future<LoginResponse?> getLoginResponse() async {
    try {
      final db = DatabaseHelper();
      return await db.getLoginResponse();
    } catch (e) {
      print('❌ Error getting login response: $e');
      return null;
    }
  }

  static Future<AllSummary?> getUserAllSummary() async {
    try {
      final db = DatabaseHelper();
      final loginResponse = await db.getLoginResponse();
      return loginResponse?.allSummary;
    } catch (e) {
      print('❌ Error getting user summary: $e');
      return null;
    }
  }

  static Future<DashboardSummary?> getDashboardSummary() async {
    try {
      final db = DatabaseHelper();

      final row = await db.getDashboardSummary();
      if (row != null) {
        return DashboardSummary.fromJson(row);
      }

      final loginResponse = await db.getLoginResponse();
      return loginResponse?.dashboardSummary;
    } catch (e) {
      print('❌ Error getting dashboard summary: $e');
      return null;
    }
  }

  static Future<void> clear() async {
    await logout();
  }

  static Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final db = DatabaseHelper();

      print('🔐 Logging out...');

      await prefs.clear();
      await db.clearAllData();

      print('✅ Logged out successfully');
    } catch (e) {
      print('❌ Error logging out: $e');
    }
  }
}
