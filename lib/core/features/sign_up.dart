import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'otp_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _phoneController = TextEditingController();
  String? _errorText;
  bool _isLoading = false;

  Future<void> _sendOtp() async {
    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    final phone = _phoneController.text.trim();

    // Validation: must start with 01, be 11 digits, and only digits
    if (!RegExp(r'^01\d{9}$').hasMatch(phone)) {
      setState(() {
        _errorText = 'Enter a valid 11-digit phone number starting with 01';
        _isLoading = false;
      });
      return;
    }

    final data = await ApiService.sendOtp(phone);

    if (data['status'] == 200 &&
        data['otp'] != null &&
        data['otp'].toString().isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OTPScreen(
              phone: phone,
              msgId: data['otp'].toString()), // ✅ changed to data['otp']
        ),
      );
    } else {
      setState(() {
        _errorText = data['msg'] ?? 'Failed to send OTP';
      });
    }
    setState(() {
      _isLoading = false;
    });
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
                  'Sign Up',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontFamily: 'Proxima Nova',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 32),
                // Phone Label
                const Text(
                  'Give Your Phone Number',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: 'Proxima Nova',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 12),
                // Phone Input Field
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF0880C6)),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 12),
                        child:
                            Icon(Icons.phone_android, color: Color(0xFF0880C6)),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          maxLength: 11,
                          decoration: const InputDecoration(
                            hintText: '01XXXXXXXXX',
                            border: InputBorder.none,
                            counterText: '',
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 14, horizontal: 8),
                          ),
                          style: const TextStyle(
                            color: Color(0xFF3A3A3A),
                            fontSize: 16,
                            fontFamily: 'Proxima Nova',
                            fontWeight: FontWeight.w400,
                          ),
                          onChanged: (value) {
                            setState(() {
                              _errorText = null;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                if (_errorText != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      _errorText!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                const SizedBox(height: 32),
                // SIGN UP Button
                SizedBox(
                  width: double.infinity,
                  height: 49,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _sendOtp,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      backgroundColor: const Color(0xFF21409A),
                      foregroundColor: Colors.white,
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'SIGN UP',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Proxima Nova',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 24),
                // Already have account
                Row(
                  children: [
                    const Text(
                      'Have already any account ?',
                      style: TextStyle(
                        color: Color(0xFF3A3A3A),
                        fontSize: 12,
                        fontFamily: 'Proxima Nova',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        // TODO: Navigate to login screen
                      },
                      child: const Text(
                        'Sign In',
                        style: TextStyle(
                          color: Color(0xFF0080C6),
                          fontSize: 13,
                          fontFamily: 'Proxima Nova',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 120),
                // Powered By
                Center(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Powered By ',
                          style: TextStyle(
                            color: Color(0xFF3A3A3A),
                            fontSize: 12,
                            fontFamily: 'Proxima Nova',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextSpan(
                          text: 'CDIP IT SERVICES LIMITED',
                          style: TextStyle(
                            color: const Color(0xFF0278C0),
                            fontSize: 12,
                            fontFamily: 'Proxima Nova',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
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
