import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static Future<Map<String, dynamic>> sendOtp(String phone) async {
    try {
      final response = await http.post(
        Uri.parse('https://connect.cdipits.site/api/v1/send-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"verify_phone": phone}),
      );

      // If server returns JSON, parse it. Otherwise return safe error.
      final bodyString = response.body ?? '';
      if (response.statusCode == 200) {
        try {
          final body = jsonDecode(bodyString);
          return Map<String, dynamic>.from(body);
        } catch (e) {
          // Response not JSON (HTML/debug page). Return safe error but do not crash.
          return {
            'status': response.statusCode,
            'msg': 'Unexpected server response (non-JSON)',
            'msg_id': null,
            'raw': bodyString,
          };
        }
      } else {
        return {
          'status': response.statusCode,
          'msg': 'Server error: ${response.statusCode}',
          'msg_id': null,
          'raw': bodyString,
        };
      }
    } catch (e) {
      return {
        'status': 'error',
        'msg': 'Failed to send OTP: $e',
        'msg_id': null,
      };
    }
  }

  static Future<Map<String, dynamic>> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('https://connect.cdipits.site/api/v1/otp_verified'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "verify_phone": phone,
          "check_otp": otp,
        }),
      );

      final bodyString = response.body ?? '';
      if (response.statusCode == 200) {
        try {
          final Map<String, dynamic> body = jsonDecode(bodyString);
          // Normalize return shape for convenience
          return {
            ...body,
            'status': body['status'], // boolean true/false per API
            'message': body['message'] ?? body['msg'] ?? '',
            'memberDetails': body['memberDetails'] ?? [],
          };
        } catch (e) {
          return {
            'status': false,
            'message': 'Unexpected server response (non-JSON)',
            'memberDetails': [],
            'raw': bodyString,
          };
        }
      } else {
        return {
          'status': false,
          'message': 'Server error: ${response.statusCode}',
          'memberDetails': [],
          'raw': bodyString,
        };
      }
    } catch (e) {
      return {
        'status': false,
        'message': 'Failed to verify OTP: $e',
        'memberDetails': [],
      };
    }
  }
}
