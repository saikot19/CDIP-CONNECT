import 'package:cdip_connect/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/login_response_model.dart';
import '../services/auth_service.dart';
import 'sign_up.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

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
            // Top Bar
            Positioned(
              left: 73,
              top: 56,
              child: Text(
                'My Profile',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontFamily: 'Proxima Nova',
                  fontWeight: FontWeight.w500,
                  height: 1.42,
                ),
              ),
            ),
            Positioned(
              left: 20,
              top: 53,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 40,
                  height: 40,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(),
                  child: Icon(Icons.arrow_back, color: Color(0xFF0880C6)),
                ),
              ),
            ),
            // Profile Picture Circle BG
            Positioned(
              left: 131.01,
              top: 139,
              child: Container(
                transform: Matrix4.identity()..rotateZ(2.09),
                width: 82,
                height: 82,
                decoration: ShapeDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment(0.50, -0.00),
                    end: Alignment(0.50, 1.00),
                    colors: [Color(0xFF21439C), Color(0xFF0A7CC3)],
                  ),
                  shape: const OvalBorder(),
                ),
              ),
            ),
            // Profile Picture
            Positioned(
              left: 37,
              top: 116,
              child: Container(
                width: 76,
                height: 76,
                decoration: ShapeDecoration(
                  image: const DecorationImage(
                    image: AssetImage('assets/logo/profile.png'),
                    fit: BoxFit.cover,
                  ),
                  shape: const OvalBorder(),
                ),
              ),
            ),
            // Name from DB
            Positioned(
              left: 118,
              top: 125,
              child: SizedBox(
                width: 132,
                height: 26,
                child: FutureBuilder<String>(
                  future: AuthService.getMemberName(),
                  builder: (context, snapshot) {
                    final name = snapshot.data ?? 'User';
                    return Text(
                      name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFF3A3A3A),
                        fontSize: 16,
                        fontFamily: 'Proxima Nova',
                        fontWeight: FontWeight.w600,
                        height: 0.81,
                      ),
                    );
                  },
                ),
              ),
            ),
            // Member Code from DB
            Positioned(
              left: 126,
              top: 146,
              child: FutureBuilder<Map<String, dynamic>?>(
                future: DatabaseHelper().getLoginResponse(),
                builder: (context, snapshot) {
                  String memberId = '000000000000';

                  if (snapshot.hasData && snapshot.data != null) {
                    try {
                      final response = LoginResponse.fromJson(snapshot.data!);
                      memberId = response.userData.id;
                    } catch (e) {
                      print('Error parsing member ID: $e');
                    }
                  }

                  return Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Member Code:',
                          style: TextStyle(
                            color: const Color(0xFF3A3A3A),
                            fontSize: 12,
                            fontFamily: 'Proxima Nova',
                            fontWeight: FontWeight.w700,
                            height: 1.08,
                          ),
                        ),
                        TextSpan(
                          text: ' $memberId',
                          style: TextStyle(
                            color: const Color(0xFF3A3A3A),
                            fontSize: 12,
                            fontFamily: 'Proxima Nova',
                            fontWeight: FontWeight.w400,
                            height: 1.08,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  );
                },
              ),
            ),
            // Branch Name from DB
            Positioned(
              left: 125,
              top: 166,
              child: FutureBuilder<Map<String, dynamic>?>(
                future: DatabaseHelper().getLoginResponse(),
                builder: (context, snapshot) {
                  String branchName = 'N/A';

                  if (snapshot.hasData && snapshot.data != null) {
                    try {
                      final response = LoginResponse.fromJson(snapshot.data!);
                      branchName = response.userData.branchName;
                    } catch (e) {
                      print('Error parsing branch name: $e');
                    }
                  }

                  return Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Branch Name:',
                          style: TextStyle(
                            color: const Color(0xFF3A3A3A),
                            fontSize: 12,
                            fontFamily: 'Proxima Nova',
                            fontWeight: FontWeight.w700,
                            height: 1.08,
                          ),
                        ),
                        TextSpan(
                          text: ' $branchName',
                          style: TextStyle(
                            color: const Color(0xFF3A3A3A),
                            fontSize: 12,
                            fontFamily: 'Proxima Nova',
                            fontWeight: FontWeight.w400,
                            height: 1.08,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  );
                },
              ),
            ),
            // Divider
            Positioned(
              left: 20,
              top: 214,
              child: Opacity(
                opacity: 0.30,
                child: Container(
                  width: 372,
                  height: 1,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 0.20,
                        strokeAlign: BorderSide.strokeAlignCenter,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // My Portfolio
            Positioned(
              left: 76,
              top: 244,
              child: Text(
                'My Portfolio',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF3A3A3A),
                  fontSize: 13,
                  fontFamily: 'Proxima Nova',
                  fontWeight: FontWeight.w400,
                  height: 1,
                ),
              ),
            ),
            Positioned(
              left: 32,
              top: 238,
              child: Opacity(
                opacity: 0.70,
                child: Container(
                  width: 25,
                  height: 25,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(),
                  child: Image.asset(
                    'assets/logo/lets-icons_order-light.png',
                    width: 25,
                    height: 25,
                  ),
                ),
              ),
            ),
            // Change Language
            Positioned(
              left: 75,
              top: 296.78,
              child: Text(
                'Change Language',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF3A3A3A),
                  fontSize: 13,
                  fontFamily: 'Proxima Nova',
                  fontWeight: FontWeight.w400,
                  height: 1,
                ),
              ),
            ),
            Positioned(
              left: 36,
              top: 294,
              child: Opacity(
                opacity: 0.70,
                child: Container(
                  width: 16,
                  height: 16,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(),
                  child: Image.asset(
                    'assets/logo/mdi_language.png',
                    width: 16,
                    height: 16,
                  ),
                ),
              ),
            ),
            // Manage Address
            Positioned(
              left: 76,
              top: 345.78,
              child: Text(
                'Manage Address',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF3A3A3A),
                  fontSize: 13,
                  fontFamily: 'Proxima Nova',
                  fontWeight: FontWeight.w400,
                  height: 1,
                ),
              ),
            ),
            Positioned(
              left: 32,
              top: 342,
              child: Opacity(
                opacity: 0.70,
                child: Container(
                  width: 20,
                  height: 20,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(),
                  child: Image.asset(
                    'assets/logo/carbon_location.png',
                    width: 20,
                    height: 20,
                  ),
                ),
              ),
            ),
            // Rate Us
            Positioned(
              left: 76,
              top: 396,
              child: Text(
                'Rate Us',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF3A3A3A),
                  fontSize: 13,
                  fontFamily: 'Proxima Nova',
                  fontWeight: FontWeight.w400,
                  height: 1,
                ),
              ),
            ),
            Positioned(
              left: 32,
              top: 389,
              child: Opacity(
                opacity: 0.70,
                child: Container(
                  width: 24.44,
                  height: 24.44,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(),
                  child: Image.asset(
                    'assets/logo/material-symbols-light_star-outline.png',
                    width: 24.44,
                    height: 24.44,
                  ),
                ),
              ),
            ),

            // About Us
            Positioned(
              left: 76,
              top: 446,
              child: Text(
                'About Us',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF3A3A3A),
                  fontSize: 13,
                  fontFamily: 'Proxima Nova',
                  fontWeight: FontWeight.w400,
                  height: 1,
                ),
              ),
            ),
            Positioned(
              left: 32,
              top: 442,
              child: Opacity(
                opacity: 0.70,
                child: Container(
                  width: 20,
                  height: 20,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(),
                  child: Image.asset(
                    'assets/logo/mdi_about-circle-outline.png',
                    width: 20,
                    height: 20,
                  ),
                ),
              ),
            ),
            // Privacy Policy
            Positioned(
              left: 76,
              top: 500,
              child: Text(
                'Privacy Policy',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF3A3A3A),
                  fontSize: 13,
                  fontFamily: 'Proxima Nova',
                  fontWeight: FontWeight.w400,
                  height: 1,
                ),
              ),
            ),
            Positioned(
              left: 32,
              top: 496,
              child: Opacity(
                opacity: 0.70,
                child: Container(
                  width: 22.22,
                  height: 22.22,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(),
                  child: Image.asset(
                    'assets/logo/material-symbols-light_privacy-tip-outline.png',
                    width: 22.22,
                    height: 22.22,
                  ),
                ),
              ),
            ),
            // Terms & Condition
            Positioned(
              left: 79,
              top: 550,
              child: Text(
                'Terms & Condition',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF3A3A3A),
                  fontSize: 13,
                  fontFamily: 'Proxima Nova',
                  fontWeight: FontWeight.w400,
                  height: 1,
                ),
              ),
            ),
            Positioned(
              left: 35,
              top: 546,
              child: Opacity(
                opacity: 0.70,
                child: Container(
                  width: 22.22,
                  height: 22.22,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(),
                  child: Image.asset(
                    'assets/logo/fluent_re-order-dots-horizontal-24-regular.png',
                    width: 22.22,
                    height: 22.22,
                  ),
                ),
              ),
            ),
            // Logout
            Positioned(
              left: 79,
              top: 600,
              child: GestureDetector(
                onTap: () async {
                  // Clear session and database
                  await AuthService.logout();

                  if (!context.mounted) return;

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignUpScreen()),
                    (route) => false,
                  );
                },
                child: const Text(
                  'Logout',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFFF737B),
                    fontSize: 13,
                    fontFamily: 'Proxima Nova',
                    fontWeight: FontWeight.w500,
                    height: 1,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 35,
              top: 596,
              child: Container(
                width: 22.22,
                height: 22.22,
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(),
                child: Image.asset(
                  'assets/logo/uil_sign-out-alt.png',
                  width: 22.22,
                  height: 22.22,
                ),
              ),
            ),
            // Bottom Navigation Bar
            BottomNavBar(
              isProfile: true,
              memberName: '',
              allSummary: AllSummary(
                memberId: '',
                loanCount: 0,
                loans: [],
                savingCount: 0,
                savings: [],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
