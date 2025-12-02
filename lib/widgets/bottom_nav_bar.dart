import 'package:cdip_connect/core/features/home_screen.dart';
import 'package:cdip_connect/core/features/my_profile.dart';
import 'package:cdip_connect/core/models/login_response_model.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final bool isHome;
  final bool isProfile;
  final AllSummary? allSummary;
  final String memberName;

  const BottomNavBar({
    super.key,
    this.isHome = false,
    this.isProfile = false,
    this.allSummary,
    this.memberName = '',
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 8,
      bottom: 0,
      child: Container(
        width: 412,
        height: 80,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                width: 412,
                height: 80,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(18),
                      topRight: Radius.circular(18),
                    ),
                  ),
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
            // Home Icon
            Positioned(
              left: 37,
              top: 25,
              child: GestureDetector(
                onTap: () {
                  if (!isHome) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(
                          memberName: memberName,
                          allSummary: allSummary ??
                              AllSummary(
                                memberId: '',
                                loanCount: 0,
                                loans: [],
                                savingCount: 0,
                                savings: [],
                              ),
                        ),
                      ),
                      (route) => false,
                    );
                  }
                },
                child: Container(
                  width: 24,
                  height: 25,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(),
                  child: Image.asset(
                    'assets/logo/tdesign_home.png',
                    width: 24,
                    height: 25,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            // Profile Icon
            Positioned(
              left: 361,
              top: 23,
              child: GestureDetector(
                onTap: () {
                  if (!isProfile) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyProfileScreen(),
                      ),
                    );
                  }
                },
                child: Opacity(
                  opacity: isProfile ? 1.0 : 0.60,
                  child: Container(
                    width: 24,
                    height: 24,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(),
                    child: Image.asset(
                      'assets/logo/iconoir_profile-circle.png',
                      width: 24,
                      height: 24,
                      fit: BoxFit.contain,
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
