import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/api_service.dart';
import 'home_screen.dart';
import '../database/db_helper.dart';

class OTPScreen extends StatefulWidget {
  final String phone;
  final String msgId;
  const OTPScreen({super.key, required this.phone, required this.msgId});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController _otpController = TextEditingController();
  String? _errorText;
  bool _isValid = false;
  int _remainingSeconds = 240; // 4 minutes
  Timer? _timer;
  bool _canResend = false;
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _remainingSeconds = 240;
      _canResend = false;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      }
    });
  }

  String _formatTime(int seconds) {
    final min = seconds ~/ 60;
    final sec = seconds % 60;
    return '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  String _maskedPhone(String phone) {
    if (phone.length < 3) return phone;
    return '***${phone.substring(phone.length - 3)}';
  }

  void _validateOtp(String value) {
    if (value.length != 6 || !RegExp(r'^\d{6}$').hasMatch(value)) {
      setState(() {
        _errorText = 'Enter a valid 6-digit OTP';
        _isValid = false;
      });
    } else {
      setState(() {
        _errorText = null;
        _isValid = true;
      });
    }
  }

  Future<void> _onVerify() async {
    _validateOtp(_otpController.text.trim());
    if (!_isValid) return;

    setState(() {
      _isVerifying = true;
      _errorText = null;
    });

    final result = await ApiService.verifyOtp(
      phone: widget.phone,
      otp: _otpController.text.trim(),
    );

    setState(() {
      _isVerifying = false;
    });

    if (result['status'] == true &&
        result['memberDetails'] != null &&
        (result['memberDetails'] as List).isNotEmpty) {
      final Map<String, dynamic> member =
          Map<String, dynamic>.from(result['memberDetails'][0]);

      // 1) Save to SharedPreferences (simple credential caching)
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('member', jsonEncode(member));
        // optionally store phone too
        await prefs.setString('member_phone', widget.phone);
      } catch (e) {
        // ignore prefs errors, still continue
      }

      // 2) Save into local sqlite DB (use your db helper)
      try {
        // DBHelper provides a static method to insert/update from a Map
        await DBHelper.insertOrUpdateMemberMap(member);
      } catch (e) {
        // ignore DB failures for now
      }

      // 3) Navigate to HomeScreen and pass member name to show immediately
      final memberName = (member['name'] ?? '').toString();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(memberName: memberName),
        ),
        (route) => false,
      );
    } else {
      setState(() {
        _errorText = result['message']?.toString() ?? 'Invalid OTP entered.';
      });
    }
  }

  Future<void> _onResend() async {
    if (!_canResend) return;
    setState(() {
      _errorText = null;
      _canResend = false;
      _remainingSeconds = 240;
    });
    _startTimer();
    final resp = await ApiService.sendOtp(widget.phone);
    final msg = resp['msg'] ?? resp['message'] ?? 'OTP resent';
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg.toString())));
  }

  @override
  Widget build(BuildContext context) {
    // Responsive paddings and fonts preserved, UI kept same visually.
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back, color: Color(0xFF0880C6)),
                ),
                const SizedBox(height: 24),
                const Text(
                  'OTP Verification',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontFamily: 'Proxima Nova',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Check your phone. We have sent you the code at ',
                        style: TextStyle(
                          color: Color(0xFF3A3A3A),
                          fontSize: 16,
                          fontFamily: 'Proxima Nova',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextSpan(
                        text: _maskedPhone(widget.phone),
                        style: const TextStyle(
                          color: Color(0xFF3A3A3A),
                          fontSize: 16,
                          fontFamily: 'Proxima Nova',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF0080C6)),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextField(
                    controller: _otpController,
                    onChanged: (v) => _validateOtp(v),
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    decoration: InputDecoration(
                      counterText: '',
                      border: InputBorder.none,
                      hintText: 'Enter 6-digit OTP',
                      hintStyle: const TextStyle(color: Color(0xFFB0B0B0)),
                      errorText: _errorText,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 8),
                    ),
                    style: const TextStyle(
                      color: Color(0xFF3A3A3A),
                      fontSize: 16,
                      fontFamily: 'Proxima Nova',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _remainingSeconds > 0
                          ? '${_formatTime(_remainingSeconds)} remaining'
                          : 'Time expired',
                      style: const TextStyle(
                        color: Color(0xFF3A3A3A),
                        fontSize: 14,
                        fontFamily: 'Proxima Nova',
                      ),
                    ),
                    GestureDetector(
                      onTap: _canResend ? _onResend : null,
                      child: Text(
                        'Resend Code',
                        style: TextStyle(
                          color: _canResend
                              ? const Color(0xFF0080C6)
                              : Colors.grey,
                          fontSize: 14,
                          fontFamily: 'Proxima Nova',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 49,
                  child: ElevatedButton(
                    onPressed: _isVerifying ? null : _onVerify,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF21409A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: _isVerifying
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'VERIFY NOW',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'Proxima Nova',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
