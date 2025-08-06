import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

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
            Positioned(
              left: 20,
              top: 111,
              child: Text(
                'Sign Up',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontFamily: 'Proxima Nova',
                  fontWeight: FontWeight.w500,
                  height: 1.13,
                ),
              ),
            ),
            Positioned(
              left: 20,
              top: 357,
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Have already any account ?',
                      style: TextStyle(
                        color: const Color(0xFF3A3A3A),
                        fontSize: 12,
                        fontFamily: 'Proxima Nova',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                      text: ' ',
                      style: TextStyle(
                        color: const Color(0xFF0278C0),
                        fontSize: 14,
                        fontFamily: 'Proxima Nova',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: 'Sign Up',
                      style: TextStyle(
                        color: const Color(0xFF0080C6),
                        fontSize: 13,
                        fontFamily: 'Proxima Nova',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 98,
              top: 851,
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Powered By ',
                      style: TextStyle(
                        color: const Color(0xFF3A3A3A),
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
            Positioned(
              left: 20,
              top: 277,
              child: Container(
                width: 372,
                height: 49,
                decoration: ShapeDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(-0.00, 0.07),
                    end: Alignment(1.00, 0.91),
                    colors: [const Color(0xFF21409A), const Color(0xFF0080C6)],
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  shadows: [
                    BoxShadow(
                      color: Color(0x3F000000),
                      blurRadius: 15,
                      offset: Offset(0, 4),
                      spreadRadius: 0,
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              left: 175,
              top: 294,
              child: Text(
                'SIGN UP',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'Proxima Nova',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Positioned(
              left: 20,
              top: 176,
              child: Text(
                'Give Your Phone Number',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                  fontFamily: 'Proxima Nova',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Positioned(
              left: 20,
              top: 198,
              child: Container(
                width: 372,
                height: 48,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1,
                      color: const Color(0xFF0880C6),
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 45,
              top: 216,
              child: Container(
                width: 14,
                height: 14,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(),
                child: Stack(),
              ),
            ),
            Positioned(
              left: 90,
              top: 214,
              child: Text(
                '+88 01746538451',
                style: TextStyle(
                  color: const Color(0xFF3A3A3A),
                  fontSize: 16,
                  fontFamily: 'Proxima Nova',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Positioned(
              left: 20,
              top: 53,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 25,
                  height: 20,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(),
                  child: const Icon(Icons.arrow_back, color: Color(0xFF0880C6)),
                ),
              ),
            ),
            Positioned(
              left: 311,
              top: 111,
              child: Container(
                width: 81,
                height: 39,
                padding:
                    const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: Color(0xFF0880C6)),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                child: const Text(
                  'বাংলা',
                  style: TextStyle(
                    color: Color(0xFF0880C6),
                    fontSize: 13,
                    fontFamily: 'Hind Siliguri',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            // ... rest of your existing Positioned widgets ...
          ],
        ),
      ),
    );
  }
}
