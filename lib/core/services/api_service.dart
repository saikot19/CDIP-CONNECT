import 'package:http/http.dart' as http;
import 'dart:convert';
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
      print('Login Response: $responseData');

      return LoginResponse.fromJson(responseData);
    } catch (e) {
      print('Error logging in: $e');
      // Return a default error response that matches the model structure
      return LoginResponse(
        status: 500,
        message: 'Network error: $e',
        appVersion: '',
        accessToken: '',
        userData: UserData(
          id: '',
          originalMemberId: '',
          branchId: '',
          samityId: '',
          name: '',
          nickName: '',
          mobileNo: '',
          smartId: '',
          nationalId: '',
          branchName: '',
        ),
        loanProducts: [],
        allSummary: AllSummary(
          memberId: '',
          loanCount: 0,
          loans: [],
          savingCount: 0,
          savings: [],
          marketingBanners: [],
        ),
        loanTransaction: LoanTransaction(
          totalPayableAmount: '0',
          totalTransactionAmount: '0',
          totalOutstandingAfterTransaction: '0',
          transactions: [],
        ),
        savingTransaction: SavingTransaction(
          totalDepositAmount: '0',
          totalWithdrawalAmount: '0',
          finalBalance: '0',
          transactions: [],
        ),
        marketingBanners: [], // Added missing field for banners
      );
    }
  }
}
