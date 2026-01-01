import 'dart:convert';

import 'package:cdip_connect/core/services/shared_preference_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

import '../models/login_response_model.dart';

class ApiService {
  static const String _baseUrl = 'https://connect.cdipits.site/api/v1';

  static Future<Map<String, dynamic>> sendOtp(String phone) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/send-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'verify_phone': phone}),
      );

      final responseData = jsonDecode(response.body);
      print('OTP Response: $responseData');

      if (response.statusCode == 200) {
        return {
          'status': responseData['status'],
          'message': responseData['message'],
          'otp': responseData['otp']?.toString() ?? '',
        };
      } else {
        return {
          'status': 400,
          'message': 'Failed to send OTP',
          'otp': '',
        };
      }
    } catch (e) {
      print('Error sending OTP: $e');
      return {
        'status': 500,
        'message': 'Network error',
        'otp': '',
      };
    }
  }

  static Future<Map<String, dynamic>> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/otp_verified'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'verify_phone': phone,
          'check_otp': otp,
        }),
      );

      return jsonDecode(response.body);
    } catch (e) {
      print('Error verifying OTP: $e');
      return {
        'status': false,
        'message': 'Network error',
      };
    }
  }

  static Future<LoginResponse> login({
    required String phone,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/member_login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'phone': phone,
          'password': password,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['status'] == 200) {
        final prefsService = SharedPreferenceService();
        await prefsService.saveData({
          'app_version': responseData['app_version'],
          'access_token': responseData['access_token'],
          'last_updated': responseData['last_updated'],
          'user_data': responseData['user_data'],
        });

        // Check version in background without blocking UI
        Future.microtask(() => _checkAppVersion(responseData['app_version']));

        return LoginResponse.fromJson(responseData);
      } else {
        return _errorResponse(responseData['message'] ?? 'Unknown error');
      }
    } catch (e) {
      print('Error logging in: $e');
      return _errorResponse('Network error: $e');
    }
  }

  static LoginResponse _errorResponse(String message) {
    return LoginResponse(
      status: 500,
      message: message,
      appVersion: '',
      accessToken: '',
      lastUpdated: '',
      userData: UserData(
        id: '',
        name: '',
        mobileNo: '',
        branchName: '',
        smartId: '',
        nationalId: '',
        samityId: '',
        originalMemberId: '',
        branchId: '',
      ),
      dashboardSummary: DashboardSummary(
        loanCount: 0,
        loanOutstanding: 0,
        savingsCount: 0,
        savingsOutstanding: 0,
        dueLoanCount: 0,
        dueLoanAmount: 0,
      ),
      marketingBanners: [],
      loanTransactions: [],
      savingAccounts: [],
      loanProducts: [],
      allSummary: AllSummary(
        memberId: '',
        loanCount: 0,
        loans: [],
        savingCount: 0,
        savings: [],
        marketingBanners: [],
      ),
    );
  }

  static void _checkAppVersion(String latestVersion) async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String currentVersion = packageInfo.version;

      if (currentVersion.compareTo(latestVersion) < 0) {
        Fluttertoast.showToast(
          msg: "A new version of the app is available. Please update.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      print('Error checking app version: $e');
    }
  }
}
