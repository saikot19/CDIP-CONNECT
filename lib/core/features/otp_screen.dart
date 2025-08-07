import 'package:flutter/material.dart';
import 'set_password.dart';

class OTPScreen extends StatelessWidget {
  const OTPScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                    TextSpan(
                      text: 'Check your phone. We have sent you the \ncode at ',
                      style: TextStyle(
                        color: const Color(0xFF3A3A3A),
                        fontSize: 16,
                        fontFamily: 'Proxima Nova',
                        fontWeight: FontWeight.w400,
                        height: 1.25,
                      ),
                    ),
                    TextSpan(
                      text: '***451',
                      style: TextStyle(
                        color: const Color(0xFF3A3A3A),
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
            ...List.generate(
                4,
                (index) => Positioned(
                      left: 20 + (index * 58),
                      top: 230,
                      child: Container(
                        width: 50,
                        height: 48,
                        alignment: Alignment.center,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                width: 1, color: const Color(0xFF0080C6)),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: Text(
                          '4',
                          style: TextStyle(
                            color: const Color(0xFF3A3A3A),
                            fontSize: 16,
                            fontFamily: 'Proxima Nova',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )),
            // Timer
            Positioned(
              left: 20,
              top: 298,
              child: Text(
                '09 seconds remaining',
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
                  // Add resend code functionality
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SetPasswordScreen(),
                    ),
                  );
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
          ],
        ),
      ),
    );
  }
}
