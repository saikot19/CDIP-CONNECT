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
  static const _kAppVersion = 'app_version';
  static const _kAccessToken = 'access_token';
  static const _kName = 'name';
  static const _kBranchName = 'branch_name';
  static const _kMobileNo = 'mobile_no';
  static const _kSmartId = 'smart_id';
  static const _kNationalId = 'national_id';
  static const _kSamityId = 'samity_id';
  static const _kOriginalMemberId = 'original_member_id';
  static const _kIsLoggedIn = 'is_logged_in';

  /// Save user session from login response
  static Future<void> saveUserSession(LoginResponse response) async {
    try {
      print('📌 Starting saveUserSession...');

      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kAppVersion, response.appVersion);
      await prefs.setString(_kAccessToken, response.accessToken);
      await prefs.setString(_kName, response.userData.name);
      await prefs.setString(_kBranchName, response.userData.branchName);
      await prefs.setString(_kMobileNo, response.userData.mobileNo);
      await prefs.setString(_kSmartId, response.userData.smartId);
      await prefs.setString(_kNationalId, response.userData.nationalId);
      await prefs.setString(_kSamityId, response.userData.samityId);
      await prefs.setString(
          _kOriginalMemberId, response.userData.originalMemberId);
      await prefs.setBool(_kIsLoggedIn, true);
      print('✅ SharedPreferences saved successfully');

      // Save to SQLite
      final db = DatabaseHelper();

      print('📌 Inserting loan products: ${response.loanProducts.length}');
      await db.insertLoanProducts(response.loanProducts);
      print('✅ Loan products inserted');

      print(
          '📌 Inserting loan transactions: ${response.loanTransaction.transactions.length}');
      await db.insertLoanTransactions(response.loanTransaction.transactions);
      print('✅ Loan transactions inserted');

      print(
          '📌 Inserting saving transactions: ${response.savingTransaction.transactions.length}');
      await db
          .insertSavingTransactions(response.savingTransaction.transactions);
      print('✅ Saving transactions inserted');

      print('📌 Inserting login summary');
      await db.insertLoginSummary(response);
      print('✅ Login summary inserted');

      print('✅ saveUserSession completed successfully!');
    } catch (e) {
      print('❌ Error in saveUserSession: $e');
      rethrow;
    }
  }

  /// Get app version
  static Future<String> getAppVersion() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kAppVersion) ?? '';
  }

  /// Get access token
  static Future<String> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kAccessToken) ?? '';
  }

  /// Get member name
  static Future<String> getMemberName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kName) ?? 'User';
  }

  /// Get branch name
  static Future<String> getBranchName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kBranchName) ?? '';
  }

  /// Get mobile number
  static Future<String> getMobileNo() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kMobileNo) ?? '';
  }

  /// Get smart ID
  static Future<String> getSmartId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kSmartId) ?? '';
  }

  /// Get national ID
  static Future<String> getNationalId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kNationalId) ?? '';
  }

  /// Get samity ID
  static Future<String> getSamityId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kSamityId) ?? '';
  }

  /// Get original member ID
  static Future<String> getOriginalMemberId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kOriginalMemberId) ?? '';
  }

  /// Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kIsLoggedIn) ?? false;
  }

  /// Get all user session data
  static Future<Map<String, String>> getUserSessionData() async {
    return {
      'app_version': await getAppVersion(),
      'access_token': await getAccessToken(),
      'name': await getMemberName(),
      'branch_name': await getBranchName(),
      'mobile_no': await getMobileNo(),
      'smart_id': await getSmartId(),
      'national_id': await getNationalId(),
      'samity_id': await getSamityId(),
      'original_member_id': await getOriginalMemberId(),
    };
  }

  /// Clear user session on logout
  static Future<void> clear() async {
    try {
      print('📌 Starting logout...');

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_kAppVersion);
      await prefs.remove(_kAccessToken);
      await prefs.remove(_kName);
      await prefs.remove(_kBranchName);
      await prefs.remove(_kMobileNo);
      await prefs.remove(_kSmartId);
      await prefs.remove(_kNationalId);
      await prefs.remove(_kSamityId);
      await prefs.remove(_kOriginalMemberId);
      await prefs.setBool(_kIsLoggedIn, false);
      print('✅ SharedPreferences cleared');

      // Clear database
      final db = DatabaseHelper();
      await db.clearAllData();
      print('✅ Database cleared');

      print('✅ Logout completed successfully!');
    } catch (e) {
      print('❌ Error in logout: $e');
      rethrow;
    }
  }
}
