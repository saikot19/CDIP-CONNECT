import 'package:flutter/material.dart';
import 'set_password.dart';
import '../services/api_service.dart';
import 'home_screen.dart';
import 'dart:async';

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

  void _onVerify() async {
    _validateOtp(_otpController.text);
    if (_isValid) {
      final result = await ApiService.verifyOtp(
        phone: widget.phone,
        otp: _otpController.text.trim(),
      );
      if (result['status'] == true &&
          result['memberDetails'] != null &&
          result['memberDetails'].isNotEmpty) {
        final memberName = result['memberDetails'][0]['name'] ?? '';
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(memberName: memberName),
          ),
        );
      } else {
        setState(() {
          _errorText = result['message'] ?? 'Invalid OTP entered.';
        });
      }
    }
  }

  Future<void> _onResend() async {
    setState(() {
      _canResend = false;
      _remainingSeconds = 240;
      _errorText = null;
    });
    _startTimer();
    await ApiService.sendOtp(widget.phone);
    // Optionally show a message that OTP was resent
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('OTP resent successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back Button
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back, color: Color(0xFF0880C6)),
                ),
                const SizedBox(height: 24),
                // Title
                const Text(
                  'OTP Verification',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontFamily: 'Proxima Nova',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 32),
                // Description
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
                const SizedBox(height: 32),
                // OTP Input Field
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF0080C6)),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextField(
                    controller: _otpController,
                    onChanged: _validateOtp,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    decoration: InputDecoration(
                      counterText: '',
                      border: InputBorder.none,
                      hintText: 'Enter OTP',
                      hintStyle: const TextStyle(
                        color: Color(0xFFB0B0B0),
                        fontSize: 16,
                        fontFamily: 'Proxima Nova',
                        fontWeight: FontWeight.w400,
                      ),
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
                const SizedBox(height: 16),
                // Timer and Resend
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _remainingSeconds > 0
                          ? '${_formatTime(_remainingSeconds)} remaining'
                          : 'Time expired',
                      style: const TextStyle(
                        color: Color(0xFF3A3A3A),
                        fontSize: 16,
                        fontFamily: 'Proxima Nova',
                        fontWeight: FontWeight.w400,
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
                          fontSize: 13,
                          fontFamily: 'Proxima Nova',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                // Verify Button
                SizedBox(
                  width: double.infinity,
                  height: 49,
                  child: ElevatedButton(
                    onPressed: _onVerify,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      backgroundColor: const Color(0xFF21409A),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
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
