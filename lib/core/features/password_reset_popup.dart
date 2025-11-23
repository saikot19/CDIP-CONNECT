import 'package:flutter/material.dart';
import 'home_screen.dart';

class PasswordResetPopup extends StatelessWidget {
  const PasswordResetPopup({super.key});

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
            // Success Image
            Positioned(
              left: 117,
              top: 189,
              child: SizedBox(
                width: 178,
                height: 156,
                child: Image.asset(
                  'assets/logo/success.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            // Password Reset Title
            Positioned(
              left: 145,
              top: 365,
              child: Text(
                'Password Reset',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'Proxima Nova',
                  fontWeight: FontWeight.w700,
                  height: 1.70,
                ),
              ),
            ),
            // Success Message
            Positioned(
              left: 70,
              top: 405,
              child: Text(
                'Your password has been reset successfully',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF3A3A3A),
                  fontSize: 14,
                  fontFamily: 'Proxima Nova',
                  fontWeight: FontWeight.w400,
                  height: 1.25,
                ),
              ),
            ),
            // Continue to Home Page Button
            Positioned(
              left: 20,
              top: 485,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomeScreen(
                              memberName: '',
                            )),
                    (route) => false,
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
                      'CONTINUE TO HOME PAGE',
                      textAlign: TextAlign.center,
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
