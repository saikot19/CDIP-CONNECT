import 'package:cdip_connect/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import '../models/login_response_model.dart';
import '../services/auth_service.dart';
import 'loan_portfolio_screen.dart';
import 'sign_up.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  String _memberName = 'User';
  String _memberId = '000000000000';
  String _branchName = 'N/A';
  AllSummary? _allSummary;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final memberName = await AuthService.getMemberName();
    final memberId = await AuthService.getMemberId();
    final summary = await AuthService.getUserAllSummary();
    final loginResponse = await AuthService.getLoginResponse();

    if (mounted) {
      setState(() {
        _memberName = memberName;
        _memberId = memberId;
        _allSummary = summary;
        if (loginResponse != null) {
          _branchName = loginResponse.userData.branchName;
        }
      });
    }
  }

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
              child: CircleAvatar(
                radius: 38,
                backgroundColor: Colors.grey[300],
                child: Icon(
                  Icons.person,
                  size: 40,
                  color: Colors.grey[800],
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
                child: Text(
                  _memberName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF3A3A3A),
                    fontSize: 16,
                    fontFamily: 'Proxima Nova',
                    fontWeight: FontWeight.w600,
                    height: 0.81,
                  ),
                ),
              ),
            ),
            // Member Code from DB
            Positioned(
              left: 126,
              top: 146,
              child: Text.rich(
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
                      text: ' $_memberId',
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
              ),
            ),
            // Branch Name from DB
            Positioned(
              left: 125,
              top: 166,
              child: Text.rich(
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
                      text: ' $_branchName',
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
            // Menu Items
            Positioned(
              top: 230,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  _buildProfileMenuRow(
                    icon: Icons.article_outlined,
                    text: 'My Portfolio',
                    onTap: () {
                      if (_allSummary != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                LoanPortfolioScreen(allSummary: _allSummary!),
                          ),
                        );
                      }
                    },
                  ),
                  _buildProfileMenuRow(
                    icon: Icons.language,
                    text: 'Change Language',
                    onTap: () {},
                  ),
                  _buildProfileMenuRow(
                    icon: Icons.location_on_outlined,
                    text: 'Manage Address',
                    onTap: () {},
                  ),
                  _buildProfileMenuRow(
                    icon: Icons.star_outline,
                    text: 'Rate Us',
                    onTap: () {},
                  ),
                  _buildProfileMenuRow(
                    icon: Icons.info_outline,
                    text: 'About Us',
                    onTap: () {},
                  ),
                  _buildProfileMenuRow(
                    icon: Icons.privacy_tip_outlined,
                    text: 'Privacy Policy',
                    onTap: () {},
                  ),
                  _buildProfileMenuRow(
                    icon: Icons.description_outlined,
                    text: 'Terms & Condition',
                    onTap: () {},
                  ),
                  _buildProfileMenuRow(
                    icon: Icons.logout,
                    text: 'Logout',
                    textColor: const Color(0xFFFF737B),
                    onTap: () async {
                      await AuthService.logout();
                      if (!context.mounted) return;
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpScreen()),
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
            // Bottom Navigation Bar
            if (_allSummary != null)
              BottomNavBar(
                isProfile: true,
                memberName: _memberName,
                allSummary: _allSummary,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileMenuRow({
    required IconData icon,
    required String text,
    VoidCallback? onTap,
    Color textColor = const Color(0xFF3A3A3A),
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF3A3A3A).withOpacity(0.7)),
            const SizedBox(width: 24),
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 13,
                fontFamily: 'Proxima Nova',
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
