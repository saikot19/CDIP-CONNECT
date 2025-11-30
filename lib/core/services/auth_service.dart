import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/login_response_model.dart';
import '../database/database_helper.dart';

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

// Timer provider for OTP countdown
final otpTimerProvider = StateNotifierProvider<OtpTimerNotifier, int>((ref) {
  return OtpTimerNotifier();
});

class OtpTimerNotifier extends StateNotifier<int> {
  OtpTimerNotifier() : super(0);

  void startTimer() {
    state = 240; // 4 minutes in seconds
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
}

class AuthService {
  static const String _keyIsLoggedIn = 'isLoggedIn';
  static const String _keyMemberName = 'memberName';
  static const String _keyMemberId = 'memberId';
  static const String _keyAccessToken = 'accessToken';

  // Save user session
  static Future<void> saveUserSession(LoginResponse response) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final db = DatabaseHelper();

      print('🔐 Saving user session...');

      // Save to SharedPreferences
      await prefs.setBool(_keyIsLoggedIn, true);
      await prefs.setString(_keyMemberName, response.userData.name);
      await prefs.setString(_keyMemberId, response.userData.id);
      await prefs.setString(_keyAccessToken, response.accessToken);

      // Save complete response to SQLite
      await db.saveLoginResponse(response.toJson());

      print('✅ User session saved successfully');
    } catch (e) {
      print('❌ Error saving user session: $e');
      rethrow;
    }
  }

  // Check if logged in
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  // Get member name
  static Future<String> getMemberName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyMemberName) ?? '';
  }

  // Get member ID
  static Future<String> getMemberId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyMemberId) ?? '';
  }

  // Get access token
  static Future<String> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyAccessToken) ?? '';
  }

  // Get user all summary
  static Future<AllSummary> getUserAllSummary() async {
    try {
      final memberId = await getMemberId();
      final db = DatabaseHelper();

      final allSummaryData = await db.getLoginResponse();

      if (allSummaryData != null) {
        try {
          final loginResponse = LoginResponse.fromJson(allSummaryData);
          print('✅ AllSummary loaded from DB');
          return loginResponse.allSummary;
        } catch (e) {
          print('❌ Error parsing login response: $e');
        }
      }

      // Fallback: construct from individual tables
      final loans = await db.getAllLoans(memberId);
      final savings = await db.getAllSavings(memberId);

      return AllSummary(
        memberId: memberId,
        loanCount: loans.length,
        loans: loans,
        savingCount: savings.length,
        savings: savings,
      );
    } catch (e) {
      print('❌ Error getting user summary: $e');
      return AllSummary(
        memberId: '',
        loanCount: 0,
        loans: [],
        savingCount: 0,
        savings: [],
      );
    }
  }

  // Logout (alias for backwards compatibility)
  static Future<void> clear() async {
    await logout();
  }

  // Logout
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
