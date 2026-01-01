import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';
import 'set_password.dart';

class OTPScreen extends ConsumerStatefulWidget {
  final String phone;
  final String testOtp; // Add this

  const OTPScreen({
    super.key,
    required this.phone,
    this.testOtp = '', // Add this
  });

  @override
  ConsumerState<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends ConsumerState<OTPScreen> {
  final TextEditingController _otpController = TextEditingController();
  final List<TextEditingController> _otpControllers =
      List.generate(6, (index) => TextEditingController());
  String? _errorText;

  String get _formattedTime {
    final timeLeft = ref.watch(otpTimerProvider);
    final minutes = (timeLeft / 60).floor();
    final seconds = timeLeft % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> _resendOTP() async {
    if (ref.read(otpTimerProvider) > 0) return;

    try {
      final response =
          await ref.read(authProvider.notifier).sendOtp(widget.phone);
      if (response['status'] == 200) {
        ref.read(otpTimerProvider.notifier).startTimer();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('OTP resent successfully')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to resend OTP')),
      );
    }
  }

  Future<void> _verifyOTP() async {
    if (_otpController.text.length != 6) {
      setState(() => _errorText = 'Please enter 6-digit OTP');
      return;
    }

    try {
      final response = await ref.read(authProvider.notifier).verifyOtp(
            phone: widget.phone,
            otp: _otpController.text,
          );

      if (response['status'] == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SetPasswordScreen()),
        );
      } else {
        setState(() => _errorText = 'Invalid OTP');
      }
    } catch (e) {
      setState(() => _errorText = e.toString());
    }
  }

  void _updateOTP() {
    String otp = _otpControllers.map((c) => c.text).join();
    _otpController.text = otp;
  }

  @override
  void initState() {
    super.initState();

    // Auto-fill OTP for testing
    if (widget.testOtp.isNotEmpty) {
      print('Debug - Filling OTP: ${widget.testOtp}');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final digits = widget.testOtp.split('');
        for (var i = 0; i < digits.length && i < _otpControllers.length; i++) {
          _otpControllers[i].text = digits[i];
        }
        _updateOTP();
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ref.watch(authProvider); // Uncomment if needed for auth state monitoring
    final timeLeft = ref.watch(otpTimerProvider);

    return Scaffold(
      body: Container(
        width: 412,
        height: 917,
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(color: Colors.white),
        child: Stack(
          children: [
            // Back Button
            Positioned(
              left: 20,
              top: 53,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 35,
                  height: 35,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(),
                  child: const Icon(Icons.arrow_back, color: Color(0xFF0880C6)),
                ),
              ),
            ),
            // Title
            Positioned(
              left: 20,
              top: 111,
              child: Text(
                'OTP Verification',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontFamily: 'Proxima Nova',
                  fontWeight: FontWeight.w500,
                  height: 1.13,
                ),
              ),
            ),
            // Description
            Positioned(
              left: 20,
              top: 159,
              child: Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Check your phone. We have sent you the \ncode at ',
                      style: TextStyle(
                        color: Color(0xFF3A3A3A),
                        fontSize: 16,
                        fontFamily: 'Proxima Nova',
                        fontWeight: FontWeight.w400,
                        height: 1.25,
                      ),
                    ),
                    TextSpan(
                      // Safely handle phone number masking
                      text: widget.phone.length >= 3
                          ? '***${widget.phone.substring(widget.phone.length - 3)}'
                          : widget.phone,
                      style: const TextStyle(
                        color: Color(0xFF3A3A3A),
                        fontSize: 16,
                        fontFamily: 'Proxima Nova',
                        fontWeight: FontWeight.w700,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // OTP Input Boxes
            Positioned(
              left: 20,
              top: 230,
              child: Container(
                width: 372,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ...List.generate(
                      6,
                      (index) => Container(
                        width: 50,
                        height: 48,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1,
                              color: const Color(0xFF0080C6),
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: TextField(
                          controller: _otpControllers[index],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          onChanged: (value) {
                            if (value.length == 1 && index < 5) {
                              FocusScope.of(context).nextFocus();
                            }
                            _updateOTP();
                          },
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            counterText: '',
                          ),
                          style: const TextStyle(
                            color: Color(0xFF3A3A3A),
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
            // Timer
            Positioned(
              left: 20,
              top: 298,
              child: Text(
                timeLeft > 0 ? _formattedTime : '00:00',
                style: TextStyle(
                  color: const Color(0xFF3A3A3A),
                  fontSize: 16,
                  fontFamily: 'Proxima Nova',
                  fontWeight: FontWeight.w400,
                  height: 1.25,
                ),
              ),
            ),
            // Resend Code
            Positioned(
              left: 314,
              top: 301,
              child: GestureDetector(
                onTap: () {
                  _resendOTP();
                },
                child: Text(
                  'Resend Code',
                  style: TextStyle(
                    color: const Color(0xFF0080C6),
                    fontSize: 13,
                    fontFamily: 'Proxima Nova',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            // Verify Button
            Positioned(
              left: 20,
              top: 365,
              child: GestureDetector(
                onTap: () {
                  _verifyOTP();
                },
                child: Container(
                  width: 372,
                  height: 49,
                  decoration: ShapeDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment(-0.00, 0.07),
                      end: Alignment(1.00, 0.91),
                      colors: [Color(0xFF21409A), Color(0xFF0080C6)],
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    shadows: const [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 15,
                        offset: Offset(0, 4),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: const Center(
                    child: Text(
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
              ),
            ),
            // Error Message
            if (_errorText != null)
              Positioned(
                left: 20,
                top: 420,
                child: Text(
                  _errorText!,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontFamily: 'Proxima Nova',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
