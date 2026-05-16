import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cdip_connect/core/services/secure_session_service.dart';
import 'package:cdip_connect/core/utils/display_formatters.dart';
import 'package:cdip_connect/features/auth/data/services/api_service.dart';
import 'package:cdip_connect/shared/data/local/database_helper.dart';
import 'package:cdip_connect/shared/models/login_response_model.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<void>>((ref) {
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

      if (ApiService.isSuccess(response)) {
        final verifiedToken = ApiService.verifiedTokenOf(response);
        if (verifiedToken.isNotEmpty) {
          await SecureSessionService.saveVerifiedToken(
            phone: phone,
            verifiedToken: verifiedToken,
          );
        }

        await DatabaseHelper().saveAuthApiResponse(
          responseType: 'otp_verification',
          phone: phone,
          response: response,
        );
      }

      state = const AsyncValue.data(null);
      return response;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> setPassword({
    required String phone,
    required String password,
    required String verifiedToken,
  }) async {
    state = const AsyncValue.loading();
    try {
      final response = await ApiService.setPassword(
        phone: phone,
        password: password,
        verifiedToken: verifiedToken,
      );

      if (ApiService.isSuccess(response)) {
        await DatabaseHelper().saveAuthApiResponse(
          responseType: 'set_password',
          phone: phone,
          response: response,
        );

        final accessToken = response['access_token']?.toString() ?? '';
        if (accessToken.isNotEmpty) {
          await SecureSessionService.saveAccessToken(accessToken);
        }
      }

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
  final notifier = OtpTimerNotifier();
  ref.onDispose(notifier.disposeTimer);
  return notifier;
});

class OtpTimerNotifier extends StateNotifier<int> {
  OtpTimerNotifier() : super(0);

  Timer? _timer;

  void startTimer({int seconds = 240}) {
    _timer?.cancel();
    state = seconds;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state <= 1) {
        state = 0;
        timer.cancel();
        return;
      }

      state = state - 1;
    });
  }

  void reset() {
    _timer?.cancel();
    state = 0;
  }

  void disposeTimer() {
    _timer?.cancel();
  }
}

class AuthService {
  static const String _keyIsLoggedIn = 'isLoggedIn';
  static const String _keyMemberName = 'memberName';
  static const String _keyMemberId = 'memberId';
  static const String _keyMemberPhone = 'memberPhone';
  static const String _keyAccessToken = 'accessToken';
  static const String _keyLastUpdated = 'lastUpdated';
  static const String _keyAppVersion = 'appVersion';

  static Future<void> saveUserSession(LoginResponse response) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final db = DatabaseHelper();

      print('Saving user session...');

      await prefs.setBool(_keyIsLoggedIn, true);
      await prefs.setString(_keyMemberName, response.userData.name);
      await prefs.setString(_keyMemberId, response.userData.id);
      await prefs.setString(_keyMemberPhone, response.userData.mobileNo);
      // Keep sensitive tokens in encrypted platform storage. A legacy
      // SharedPreferences value may exist from older builds and is cleaned on logout.
      await SecureSessionService.saveAccessToken(response.accessToken);
      await prefs.remove(_keyAccessToken);
      await prefs.setString(_keyLastUpdated, response.lastUpdated);
      await prefs.setString(_keyAppVersion, response.appVersion);

      await db.saveLoginResponse(response);

      print('User session saved successfully');
    } catch (e) {
      print('Error saving user session: $e');
      rethrow;
    }
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  static Future<String> getMemberName() async {
    final prefs = await SharedPreferences.getInstance();
    return DisplayFormatters.firstName(prefs.getString(_keyMemberName));
  }


  static Future<String> getRememberedPhone() async {
    final prefs = await SharedPreferences.getInstance();
    final phone = prefs.getString(_keyMemberPhone) ?? '';
    if (phone.trim().isNotEmpty) return phone.trim();

    try {
      final db = DatabaseHelper();
      final loginResponse = await db.getLoginResponse();
      final loginPhone = loginResponse?.userData.mobileNo.trim() ?? '';
      if (loginPhone.isNotEmpty) return loginPhone;

      final setPasswordResponse = await db.getLatestAuthApiResponse(
        responseType: 'set_password',
      );
      final setPasswordPhone = _phoneFromAuthMap(setPasswordResponse);
      if (setPasswordPhone.isNotEmpty) return setPasswordPhone;

      final otpResponse = await db.getLatestAuthApiResponse(
        responseType: 'otp_verification',
      );
      return _phoneFromAuthMap(otpResponse);
    } catch (_) {
      return '';
    }
  }

  static String _phoneFromAuthMap(Map<String, dynamic>? data) {
    if (data == null) return '';
    final userData = data['user_data'];
    if (userData is Map) {
      final phone = userData['mobile_no']?.toString().trim() ?? '';
      if (phone.isNotEmpty) return phone;
    }

    final memberDetails = data['memberDetails'];
    if (memberDetails is List && memberDetails.isNotEmpty) {
      final first = memberDetails.first;
      if (first is Map) {
        return first['mobile_no']?.toString().trim() ?? '';
      }
    }

    return '';
  }

  static Future<bool> hasRememberedAccount() async {
    final phone = await getRememberedPhone();
    return phone.isNotEmpty;
  }

  static Future<String> getMemberId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyMemberId) ?? '';
  }

  static Future<String> getAccessToken() async {
    final secureToken = await SecureSessionService.getAccessToken();
    if (secureToken.isNotEmpty) return secureToken;

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
      print('Error getting login response: $e');
      return null;
    }
  }

  static Future<AllSummary?> getUserAllSummary() async {
    try {
      final db = DatabaseHelper();
      final loginResponse = await db.getLoginResponse();
      return loginResponse?.allSummary;
    } catch (e) {
      print('Error getting user summary: $e');
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
      print('Error getting dashboard summary: $e');
      return null;
    }
  }

  static Future<String> getKnownMemberNameByPhone(String phone) async {
    try {
      final cleanPhone = phone.trim();
      final db = DatabaseHelper();
      final name = await db.getKnownMemberNameByPhone(cleanPhone);
      if (name.trim().isNotEmpty) return DisplayFormatters.firstName(name);

      final loginResponse = await db.getLoginResponse();
      if (loginResponse?.userData.mobileNo.trim() == cleanPhone) {
        return DisplayFormatters.firstName(loginResponse?.userData.name);
      }

      return '';
    } catch (e) {
      print('Error getting known member name: $e');
      return '';
    }
  }

  static Future<void> clear() async {
    await logout();
  }

  static Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final db = DatabaseHelper();

      print('Logging out...');

      await prefs.clear();
      await SecureSessionService.clearAll();
      await db.clearAllData();

      print('Logged out successfully');
    } catch (e) {
      print('Error logging out: $e');
    }
  }
}
