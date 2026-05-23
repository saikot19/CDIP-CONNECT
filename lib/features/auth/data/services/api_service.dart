import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

import 'package:cdip_connect/shared/models/login_response_model.dart';

class ApiService {
  static const String _baseUrl = 'https://connect.cdipits.site/api/v1';
  static const Duration _timeout = Duration(seconds: 25);

  static const Map<String, String> _jsonHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Future<Map<String, dynamic>> sendOtp(String phone) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/send-otp'),
            headers: _jsonHeaders,
            body: jsonEncode({'verify_phone': phone.trim()}),
          )
          .timeout(_timeout);

      final responseData = _decodeMap(response.body);
      _debugResponse('Send OTP', responseData);

      if (response.statusCode == 200) {
        return {
          ...responseData,
          'status': _asInt(responseData['status'], fallback: 200),
          'message': _asString(responseData['message'], fallback: 'OTP sent successfully.'),
          'otp': _asString(responseData['otp']),
          'http_status': response.statusCode,
        };
      }

      return {
        'status': response.statusCode,
        'http_status': response.statusCode,
        'message': _asString(
          responseData['message'],
          fallback: 'Failed to send OTP. Please try again.',
        ),
        'otp': '',
      };
    } on TimeoutException {
      return {
        'status': 408,
        'http_status': 408,
        'message': 'Request timeout. Please try again.',
        'otp': '',
      };
    } catch (e) {
      _debugError('Send OTP error', e);
      return {
        'status': 500,
        'http_status': 500,
        'message': 'Network error. Please check your connection.',
        'otp': '',
      };
    }
  }

  static Future<Map<String, dynamic>> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    final requestBody = {
      'verify_phone': phone.trim(),
      'check_otp': otp.trim(),
    };

    // Some backend deployments verify OTP through /otp_verified, while some
    // older documentation mentions /send-otp with check_otp. We try the real
    // verification endpoint first, then keep /send-otp as a fallback.
    final endpoints = <String>[
      '$_baseUrl/otp_verified',
      '$_baseUrl/send-otp',
    ];

    Map<String, dynamic>? lastResponse;

    for (final endpoint in endpoints) {
      try {
        final response = await http
            .post(
              Uri.parse(endpoint),
              headers: _jsonHeaders,
              body: jsonEncode(requestBody),
            )
            .timeout(_timeout);

        final responseData = _decodeMap(response.body);
        responseData['http_status'] = response.statusCode;
        responseData['endpoint'] = endpoint;
        _debugResponse('OTP Verify', responseData);
        lastResponse = responseData;

        final verifiedToken = _asString(responseData['verified_token']).trim();
        final isVerified = responseData['status'] == true ||
            _asString(responseData['message'])
                .toLowerCase()
                .contains('verified');

        if (response.statusCode == 200 && verifiedToken.isNotEmpty) {
          return responseData;
        }

        // If the API says the OTP was verified but did not send the token,
        // return immediately with a clear error because set_password cannot
        // safely continue without verified_token.
        if (response.statusCode == 200 && isVerified && verifiedToken.isEmpty) {
          return {
            ...responseData,
            'status': false,
            'message': 'OTP verified but verification token was missing. Please try again.',
          };
        }

        // /send-otp may return a fresh OTP response even when check_otp is sent.
        // That is not a successful verification response, so do not treat
        // status: 200 as success unless verified_token exists.
        final message = _asString(responseData['message']).toLowerCase();
        final looksLikeSendOtp = message.contains('otp sent') ||
            responseData.containsKey('otp');
        if (looksLikeSendOtp) {
          continue;
        }

        // If the real endpoint returns a validation error, do not hide it by
        // calling the fallback endpoint.
        if (response.statusCode != 404 && response.statusCode != 405) {
          return {
            ...responseData,
            'status': false,
            'message': messageOf(
              responseData,
              fallback: 'OTP verification failed. Please try again.',
            ),
          };
        }
      } on TimeoutException {
        return {
          'status': false,
          'http_status': 408,
          'message': 'Request timeout. Please try again.',
        };
      } catch (e) {
        _debugError('OTP verify error', e);
        // Try the fallback endpoint if the first endpoint fails unexpectedly.
        lastResponse = {
          'status': false,
          'http_status': 500,
          'message': 'Network error. Please check your connection.',
        };
        continue;
      }
    }

    return {
      ...?lastResponse,
      'status': false,
      'message': 'OTP could not be verified. Please request a new OTP and try again.',
    };
  }

  static Future<Map<String, dynamic>> setPassword({
    required String phone,
    required String password,
    required String verifiedToken,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/set_password'),
            headers: _jsonHeaders,
            body: jsonEncode({
              'member_phone': phone.trim(),
              'password': password,
              'verified_token': verifiedToken.trim(),
            }),
          )
          .timeout(_timeout);

      final responseData = _decodeMap(response.body);
      responseData['http_status'] = response.statusCode;
      _debugResponse('Set Password', responseData);

      if (responseData.isNotEmpty) return responseData;

      return {
        'status': response.statusCode,
        'http_status': response.statusCode,
        'message': response.statusCode == 200
            ? 'Password set successfully.'
            : 'Password update failed. Please try again.',
      };
    } on TimeoutException {
      return {
        'status': 408,
        'http_status': 408,
        'message': 'Request timeout. Please try again.',
      };
    } catch (e) {
      _debugError('Set password error', e);
      return {
        'status': 500,
        'http_status': 500,
        'message': 'Network error. Please check your connection.',
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
            headers: _jsonHeaders,
            body: jsonEncode({
              'phone': phone.trim(),
              'password': password,
            }),
          )
          .timeout(_timeout);

      final responseData = _decodeMap(response.body);
      responseData['http_status'] = response.statusCode;
      _debugResponse('Login', responseData);

      if (response.statusCode == 200 && _asInt(responseData['status']) == 200) {
        try {
          final loginResponse = LoginResponse.fromJson(responseData);
          Future.microtask(() => _checkAppVersion(loginResponse.appVersion));
          return loginResponse;
        } catch (e, st) {
          _debugError('Login response parsing error', e, st);
          return _errorResponse(
            'Login succeeded, but the app could not prepare your account data. Please try again.',
          );
        }
      }

      return _errorResponse(
        _asString(responseData['message'], fallback: 'Login failed. Please try again.'),
      );
    } on TimeoutException {
      return _errorResponse('Request timeout. Please try again.');
    } catch (e, st) {
      _debugError('Login network error', e, st);
      return _errorResponse('Network error. Please check your connection.');
    }
  }

  static bool isSuccess(Map<String, dynamic> response) {
    final status = response['status'];

    // Business failure must always win over HTTP 200. Some endpoints return
    // HTTP 200 with {status: false}, and treating that as success breaks OTP
    // verification and password setup flows.
    if (status == false) return false;
    if (status == true) return true;

    if (status is int) return status == 200;
    if (status is String) {
      final normalized = status.toLowerCase().trim();
      if (normalized == 'false' || normalized == '0' || normalized == 'failed' || normalized == 'error') {
        return false;
      }
      return normalized == '200' || normalized == 'true' || normalized == 'success';
    }

    // Only fall back to HTTP status when the business status key is absent.
    if (!response.containsKey('status')) {
      return _asInt(response['http_status']) == 200;
    }

    return false;
  }

  static String messageOf(
    Map<String, dynamic> response, {
    String fallback = 'Something went wrong. Please try again.',
  }) {
    final errors = response['errors'];
    if (errors is Map && errors.isNotEmpty) {
      final firstValue = errors.values.first;
      if (firstValue is List && firstValue.isNotEmpty) {
        return firstValue.first.toString();
      }
      return firstValue.toString();
    }

    final message = response['message'];
    if (message == null || message.toString().trim().isEmpty) return fallback;
    return message.toString();
  }

  static String verifiedTokenOf(Map<String, dynamic> response) {
    return _asString(response['verified_token']);
  }

  static String memberNameOf(Map<String, dynamic> response) {
    final memberDetails = response['memberDetails'];
    if (memberDetails is List && memberDetails.isNotEmpty) {
      final firstMember = memberDetails.first;
      if (firstMember is Map) return _asString(firstMember['name']);
    }

    final userData = response['user_data'];
    if (userData is Map) return _asString(userData['name']);
    return '';
  }

  static bool memberExists(Map<String, dynamic> response) {
    final memberDetails = response['memberDetails'];
    if (memberDetails is List && memberDetails.isNotEmpty) {
      final firstMember = memberDetails.first;
      if (firstMember is Map) {
        final memberId = _asString(firstMember['id']).trim();
        final phone = _asString(firstMember['mobile_no']).trim();
        return memberId.isNotEmpty || phone.isNotEmpty;
      }
    }

    final userData = response['user_data'];
    if (userData is Map) {
      final memberId = _asString(userData['id']).trim();
      final phone = _asString(userData['mobile_no']).trim();
      return memberId.isNotEmpty || phone.isNotEmpty;
    }

    return false;
  }

  static Map? _memberPayloadOf(Map<String, dynamic> response) {
    final memberDetails = response['memberDetails'];
    if (memberDetails is List && memberDetails.isNotEmpty) {
      final firstMember = memberDetails.first;
      if (firstMember is Map) return firstMember;
    }

    final userData = response['user_data'];
    if (userData is Map) return userData;

    return null;
  }

  static String? memberPasswordValueOf(Map<String, dynamic> response) {
    final member = _memberPayloadOf(response);
    if (member == null || !member.containsKey('password')) return null;

    final rawPassword = member['password'];
    if (rawPassword == null) return null;

    return rawPassword.toString();
  }

  static bool memberPasswordIsNullOrEmpty(Map<String, dynamic> response) {
    final password = memberPasswordValueOf(response);
    return password == null || password.trim().isEmpty;
  }

  static bool memberAlreadyHasPassword(Map<String, dynamic> response) {
    final password = memberPasswordValueOf(response)?.trim();
    if (password == null || password.isEmpty) return false;

    final normalized = password.toLowerCase();
    const unusableValues = {
      '0',
      'null',
      'none',
      'n/a',
      'na',
      '-',
      'false',
      'no',
      'd41d8cd98f00b204e9800998ecf8427e', // md5 empty string
    };

    if (unusableValues.contains(normalized)) return false;

    // The backend stores hashed passwords. Any non-empty usable value means
    // password setup is complete and the member should sign in normally.
    return true;
  }

  static bool memberRequiresPasswordSetup(Map<String, dynamic> response) {
    return memberExists(response) && !memberAlreadyHasPassword(response);
  }

  static LoginResponse? loginResponseFromMap(Map<String, dynamic> response) {
    try {
      if (!isSuccess(response)) return null;
      if (response['user_data'] is! Map) return null;
      return LoginResponse.fromJson(response);
    } catch (e, st) {
      _debugError('Auth map to LoginResponse parse error', e, st);
      return null;
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
        code: '',
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
          msg: 'A new version of the app is available. Please update.',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      _debugError('App version check error', e);
    }
  }

  static int _compareVersions(String current, String latest) {
    final currentParts = current.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    final latestParts = latest.split('.').map((e) => int.tryParse(e) ?? 0).toList();

    final maxLength = currentParts.length > latestParts.length
        ? currentParts.length
        : latestParts.length;

    while (currentParts.length < maxLength) {
      currentParts.add(0);
    }
    while (latestParts.length < maxLength) {
      latestParts.add(0);
    }

    for (var i = 0; i < maxLength; i++) {
      if (currentParts[i] < latestParts[i]) return -1;
      if (currentParts[i] > latestParts[i]) return 1;
    }

    return 0;
  }

  static Map<String, dynamic> _decodeMap(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) return decoded;
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
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

  static void _debugResponse(String label, Map<String, dynamic> response) {
    assert(() {
      final sanitized = _sanitizeForLog(response);
      // ignore: avoid_print
      print('$label Response: $sanitized');
      return true;
    }());
  }

  static void _debugError(String label, Object error, [StackTrace? stackTrace]) {
    assert(() {
      // ignore: avoid_print
      print('$label: $error');
      if (stackTrace != null) {
        // ignore: avoid_print
        print(stackTrace);
      }
      return true;
    }());
  }

  static Map<String, dynamic> _sanitizeForLog(Map<String, dynamic> source) {
    final result = <String, dynamic>{};
    for (final entry in source.entries) {
      final key = entry.key.toLowerCase();
      final value = entry.value;
      if (key.contains('token') || key == 'otp' || key == 'password' || key == 'access_token') {
        result[entry.key] = '***';
      } else if (value is Map) {
        result[entry.key] = _sanitizeForLog(Map<String, dynamic>.from(value));
      } else if (value is List) {
        result[entry.key] = value.map((item) {
          if (item is Map) return _sanitizeForLog(Map<String, dynamic>.from(item));
          return item;
        }).toList();
      } else {
        result[entry.key] = value;
      }
    }
    return result;
  }
}
