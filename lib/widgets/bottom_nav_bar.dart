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
    const activeColor = Color(0xFF0880C6);
    const inactiveColor = Colors.grey;

    return Positioned(
      left: 0, // Adjusted to match the background container width usually 412 or screen width
      bottom: 0,
      child: Container(
        width: 412, // Fixed width as per design? Or MediaQuery? keeping 412 for now
        height: 80,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                width: 412,
                height: 80,
                decoration: const ShapeDecoration(
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
              top: 20, // Adjusted slightly for Icon alignment
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
                  width: 40, // increased tap area
                  height: 40,
                  color: Colors.transparent, // transparent hit box
                  child: Icon(
                    Icons.home, // Default home icon
                    size: 30,
                    color: isHome ? activeColor : inactiveColor,
                  ),
                ),
              ),
            ),
            // Profile Icon
            Positioned(
              left: 345, // Adjusted position to match right side (~361 in original but 412 width, 361 is far right)
              top: 20,
              child: GestureDetector(
                onTap: () {
                  if (!isProfile) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyProfileScreen(),
                      ),
                    );
                  }
                },
                child: Container(
                  width: 40,
                  height: 40,
                  color: Colors.transparent,
                  child: Icon(
                    Icons.person, // Default profile icon
                    size: 30,
                    color: isProfile ? activeColor : inactiveColor,
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