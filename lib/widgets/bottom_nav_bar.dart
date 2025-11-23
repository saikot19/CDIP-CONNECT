import 'package:cdip_connect/core/features/home_screen.dart';
import 'package:cdip_connect/core/features/my_profile.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final bool isHome;
  final bool isProfile;

  const BottomNavBar({super.key, this.isHome = false, this.isProfile = false});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
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
                  color: const Color.fromARGB(255, 255, 255, 255),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(18),
                      topRight: Radius.circular(18),
                    ),
                  ),
                ),
              ),
            ),
            // Home icon
            Positioned(
              left: 37,
              top: 28,
              child: GestureDetector(
                onTap: () {
                  if (!isHome) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen(
                                memberName: '',
                              )),
                      (route) => false,
                    );
                  }
                },
                child: Image.asset(
                  'assets/logo/tdesign_home.png',
                  width: 24,
                  height: 24,
                  fit: BoxFit.contain,
                  color: isHome ? const Color(0xFF0880C6) : null,
                ),
              ),
            ),
            // Profile icon
            Positioned(
              right: 37,
              top: 28,
              child: GestureDetector(
                onTap: () {
                  if (!isProfile) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyProfileScreen()),
                    );
                  }
                },
                child: Image.asset(
                  'assets/logo/iconoir_profile-circle.png',
                  width: 24,
                  height: 24,
                  fit: BoxFit.contain,
                  color: isProfile ? const Color(0xFF0880C6) : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
