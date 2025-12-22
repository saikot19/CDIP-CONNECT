import 'package:flutter/material.dart';
import '../models/login_response_model.dart';
import 'reset_password_screen.dart';
import 'home_screen.dart';

class SetPasswordScreen extends StatelessWidget {
  const SetPasswordScreen({super.key});

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
                'Set Your Password',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontFamily: 'Proxima Nova',
                  fontWeight: FontWeight.w500,
                  height: 1.13,
                ),
              ),
            ),
            // Password Input Field
            Positioned(
              left: 20,
              top: 201,
              child: Container(
                width: 372,
                height: 48,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: const Color(0xFF0080C6)),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        '**************',
                        style: TextStyle(
                          color: const Color(0xFF3A3A3A),
                          fontSize: 16,
                          fontFamily: 'Proxima Nova',
                          fontWeight: FontWeight.w600,
                          height: 1.25,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child:
                          Icon(Icons.visibility_off, color: Color(0xFF0080C6)),
                    ),
                  ],
                ),
              ),
            ),
            // Password Label
            Positioned(
              left: 20,
              top: 179,
              child: Text(
                'Type Password',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                  fontFamily: 'Proxima Nova',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            // Forgot Password Text
            Positioned(
              left: 20,
              top: 265,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ResetPasswordScreen(),
                    ),
                  );
                },
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Forgot Password?',
                        style: TextStyle(
                          color: const Color(0xFF3A3A3A),
                          fontSize: 12,
                          fontFamily: 'Proxima Nova',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextSpan(text: ' '),
                      TextSpan(
                        text: 'Reset Password',
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
            ),
            // Proceed Button
            Positioned(
              left: 20,
              top: 315,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(
                        memberName: '',
                        allSummary: AllSummary(
                          memberId: '',
                          loanCount: 0,
                          loans: [],
                          savingCount: 0,
                          savings: [], marketingBanners: [],
                        ),
                        dashboardSummary: null,
                      ),
                    ),
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
                      'PROCEED',
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
