import 'package:cdip_connect/core/services/localization_service.dart';
import 'package:cdip_connect/core/utils/app_toast.dart';
import 'package:cdip_connect/core/utils/display_formatters.dart';
import 'package:cdip_connect/shared/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:cdip_connect/shared/models/login_response_model.dart';
import 'package:cdip_connect/features/auth/application/auth_service.dart';
import 'package:cdip_connect/features/loans/presentation/screens/loan_portfolio_screen.dart';
import 'package:cdip_connect/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyProfileScreen extends ConsumerStatefulWidget {
  const MyProfileScreen({super.key});

  @override
  ConsumerState<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends ConsumerState<MyProfileScreen> {
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
        _memberName = DisplayFormatters.firstName(memberName, fallback: 'User');
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
    final language = ref.watch(localizationProvider);
    final t = AppLocalizations(language);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(color: Colors.white),
        child: Stack(
          children: [
            // Top Bar
            Positioned(
              left: 73,
              top: 56,
              child: Text(
                t.myProfile,
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
                      text: '${t.memberCode}:',
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
                      text: '${t.branchName}:',
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
                    text: t.myPortfolio,
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
                    text: t.changeLanguage,
                    onTap: () async {
                      final nextLanguage = language == 'bn' ? 'en' : 'bn';
                      await ref.read(localizationProvider.notifier).changeLanguage(nextLanguage);
                      AppToast.showSuccess(
                        nextLanguage == 'bn'
                            ? 'বাংলা ভাষা নির্বাচন করা হয়েছে।'
                            : 'English language selected.',
                      );
                    },
                  ),
                  _buildProfileMenuRow(
                    icon: Icons.location_on_outlined,
                    text: t.manageAddress,
                    onTap: () {},
                  ),
                  _buildProfileMenuRow(
                    icon: Icons.star_outline,
                    text: t.rateUs,
                    onTap: () {},
                  ),
                  _buildProfileMenuRow(
                    icon: Icons.info_outline,
                    text: t.aboutUs,
                    onTap: () {},
                  ),
                  _buildProfileMenuRow(
                    icon: Icons.privacy_tip_outlined,
                    text: t.privacyPolicy,
                    onTap: () {},
                  ),
                  _buildProfileMenuRow(
                    icon: Icons.description_outlined,
                    text: t.termsCondition,
                    onTap: () {},
                  ),
                  _buildProfileMenuRow(
                    icon: Icons.logout,
                    text: t.logout,
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
