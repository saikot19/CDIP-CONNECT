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
    final screenWidth = MediaQuery.of(context).size.width;
    const activeColor = Color(0xFF0880C6);
    const inactiveColor = Colors.grey;

    return Positioned(
      left: 0,
      bottom: 0,
      child: Container(
        width: screenWidth,
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Home Icon
            GestureDetector(
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
                              marketingBanners: [],
                            ),
                      ),
                    ),
                    (route) => false,
                  );
                }
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                color: Colors.transparent, // For larger tap area
                child: Icon(
                  Icons.home,
                  size: 30,
                  color: isHome ? activeColor : inactiveColor,
                ),
              ),
            ),
            // Profile Icon
            GestureDetector(
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
                padding: const EdgeInsets.all(12),
                color: Colors.transparent,
                child: Icon(
                  Icons.person,
                  size: 30,
                  color: isProfile ? activeColor : inactiveColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
