import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

import '../models/login_response_model.dart';

class ApiService {
  static const String _baseUrl = 'https://connect.cdipits.site/api/v1';
  static const Duration _timeout = Duration(seconds: 25);

  static Future<Map<String, dynamic>> sendOtp(String phone) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/send-otp'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'verify_phone': phone}),
          )
          .timeout(_timeout);

      final responseData = _decodeMap(response.body);
      print('OTP Response: $responseData');

      if (response.statusCode == 200) {
        return {
          'status': _asInt(responseData['status'], fallback: 200),
          'message': _asString(responseData['message'], fallback: 'Success'),
          'otp': _asString(responseData['otp']),
        };
      }

      return {
        'status': response.statusCode,
        'message': _asString(
          responseData['message'],
          fallback: 'Failed to send OTP',
        ),
        'otp': '',
      };
    } on TimeoutException {
      return {
        'status': 408,
        'message': 'Request timeout',
        'otp': '',
      };
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
      final response = await http
          .post(
            Uri.parse('$_baseUrl/otp_verified'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'verify_phone': phone,
              'check_otp': otp,
            }),
          )
          .timeout(_timeout);

      return _decodeMap(response.body);
    } on TimeoutException {
      return {
        'status': false,
        'message': 'Request timeout',
      };
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
      final response = await http
          .post(
            Uri.parse('$_baseUrl/member_login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'phone': phone,
              'password': password,
            }),
          )
          .timeout(_timeout);

      final responseData = _decodeMap(response.body);
      print('Login Response: $responseData');

      if (response.statusCode == 200 && _asInt(responseData['status']) == 200) {
        final loginResponse = LoginResponse.fromJson(responseData);

        // Fire and forget, does not block login UX
        Future.microtask(() => _checkAppVersion(loginResponse.appVersion));

        return loginResponse;
      }

      return _errorResponse(
        _asString(responseData['message'], fallback: 'Unknown error'),
      );
    } on TimeoutException {
      return _errorResponse('Request timeout');
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

  static Future<void> _checkAppVersion(String latestVersion) async {
    try {
      if (latestVersion.trim().isEmpty) return;

      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;

      if (_compareVersions(currentVersion, latestVersion) < 0) {
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

  static int _compareVersions(String current, String latest) {
    final currentParts =
        current.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    final latestParts =
        latest.split('.').map((e) => int.tryParse(e) ?? 0).toList();

    final maxLength = currentParts.length > latestParts.length
        ? currentParts.length
        : latestParts.length;

    while (currentParts.length < maxLength) {
      currentParts.add(0);
    }
    while (latestParts.length < maxLength) {
      latestParts.add(0);
    }

    for (int i = 0; i < maxLength; i++) {
      if (currentParts[i] < latestParts[i]) return -1;
      if (currentParts[i] > latestParts[i]) return 1;
    }

    return 0;
  }

  static Map<String, dynamic> _decodeMap(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      return {};
    } catch (_) {
      return {};
    }
  }

  static String _asString(dynamic value, {String fallback = ''}) {
    if (value == null) return fallback;
    return value.toString();
  }

  static int _asInt(dynamic value, {int fallback = 0}) {
    if (value == null) return fallback;
    if (value is int) return value;
    if (value is double) return value.toInt();
    return int.tryParse(value.toString()) ?? fallback;
  }
}
