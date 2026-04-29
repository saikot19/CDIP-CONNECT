import 'package:cdip_connect/core/utils/app_toast.dart';
import 'package:cdip_connect/core/utils/app_validators.dart';
import 'package:cdip_connect/features/auth/data/services/api_service.dart';
import 'package:cdip_connect/features/auth/presentation/screens/otp_screen.dart';
import 'package:cdip_connect/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final TextEditingController _phoneController = TextEditingController();
  String? _errorText;
  bool _isLoading = false;

  Future<void> _handleSignUp() async {
    FocusScope.of(context).unfocus();

    final phone = _phoneController.text.trim();
    final validationMessage = AppValidators.bangladeshPhone(phone);

    if (validationMessage != null) {
      setState(() => _errorText = validationMessage);
      AppToast.showError(validationMessage);
      return;
    }

    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    try {
      final response = await ApiService.sendOtp(phone);
      final status = response['status'];
      final message = response['message']?.toString() ?? '';

      if (status == 200 || status == '200') {
        AppToast.showSuccess('OTP sent successfully. Please check your phone.');

        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OTPScreen(phone: phone),
          ),
        );
      } else if ((status == 400 || status == '400') &&
          message.toLowerCase().contains('already set')) {
        AppToast.showInfo('This number already has an account. Please sign in.');

        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SignInScreen(phone: phone),
          ),
        );
      } else {
        final error = message.isNotEmpty ? message : 'Failed to send OTP.';
        setState(() => _errorText = error);
        AppToast.showError(error);
      }
    } catch (_) {
      const error = 'Network error occurred. Please check your connection.';
      if (!mounted) return;
      setState(() => _errorText = error);
      AppToast.showError(error);
    } finally {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  void _clearError() {
    if (_errorText != null) {
      setState(() => _errorText = null);
    }
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
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back, color: Color(0xFF0880C6)),
                ),
                const SizedBox(height: 24),
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
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF0880C6)),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: Icon(Icons.phone_android, color: Color(0xFF0880C6)),
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
                              vertical: 14,
                              horizontal: 8,
                            ),
                          ),
                          style: const TextStyle(
                            color: Color(0xFF3A3A3A),
                            fontSize: 16,
                            fontFamily: 'Proxima Nova',
                            fontWeight: FontWeight.w400,
                          ),
                          onChanged: (_) => _clearError(),
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
                SizedBox(
                  width: double.infinity,
                  height: 49,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleSignUp,
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
                Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      const Text(
                        'Have already any account? ',
                        style: TextStyle(
                          color: Color(0xFF3A3A3A),
                          fontSize: 12,
                          fontFamily: 'Proxima Nova',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignInScreen(phone: ''),
                            ),
                          );
                        },
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                            color: Color(0xFF0080C6),
                            fontSize: 12,
                            fontFamily: 'Proxima Nova',
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 120),
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
                        const TextSpan(
                          text: 'CDIP IT SERVICES LIMITED',
                          style: TextStyle(
                            color: Color(0xFF0278C0),
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

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }
}
