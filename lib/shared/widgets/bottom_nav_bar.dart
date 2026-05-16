import 'package:cdip_connect/features/dashboard/presentation/screens/home_screen.dart';
import 'package:cdip_connect/features/profile/presentation/screens/my_profile_screen.dart';
import 'package:cdip_connect/shared/models/login_response_model.dart';
import 'package:flutter/material.dart';
import 'package:cdip_connect/core/utils/app_navigation.dart';

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

  void _goToHome(BuildContext context) {
    if (isHome) return;

    Navigator.pushAndRemoveUntil(
      context,
      AppNavigation.smoothRoute(
        builder: (context) => const HomeScreen(),
      ),
      (route) => false,
    );
  }

  void _goToProfile(BuildContext context) {
    if (isProfile) return;

    Navigator.pushReplacement(
      context,
      AppNavigation.smoothRoute(
        builder: (context) => const MyProfileScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const activeColor = Color(0xFF0880C6);
    const inactiveColor = Colors.grey;

    return Positioned(
      left: 0,
      bottom: 0,
      child: SafeArea(
        top: false,
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
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: () => _goToHome(context),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    color: Colors.transparent,
                    child: Icon(
                      Icons.home,
                      size: 30,
                      color: isHome ? activeColor : inactiveColor,
                    ),
                  ),
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: () => _goToProfile(context),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
