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

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        return {
          'status': body['status'],
          'msg': body['message'],
          'otp': body['otp'], // ✅ changed from msg_id to otp
        };
      } else {
        return {
          'status': response.statusCode,
          'msg': 'Server returned error ${response.statusCode}',
          'otp': null,
        };
      }
    } catch (e) {
      return {
        'status': 'error',
        'msg': 'Failed to send OTP: $e',
        'otp': null,
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
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'User-Agent': 'FlutterApp/1.0',
        },
        body: jsonEncode({
          "verify_phone": phone,
          "check_otp": otp, // ✅ corrected key name
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return {
          'status': body['status'],
          'message': body['message'],
          'memberDetails': body['memberDetails'] ?? [],
        };
      } else {
        return {
          'status': false,
          'message': 'Server error: ${response.statusCode}',
          'memberDetails': [],
        };
      }
    } catch (e) {
      print('Exception caught: $e');
      return {
        'status': false,
        'message': 'Failed to verify OTP: $e',
        'memberDetails': [],
      };
    }
  }
}
