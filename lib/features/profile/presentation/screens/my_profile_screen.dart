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
import 'package:lottie/lottie.dart';
import 'package:cdip_connect/core/utils/app_navigation.dart';

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
                          AppNavigation.smoothRoute(
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
                      await ref
                          .read(localizationProvider.notifier)
                          .changeLanguage(nextLanguage);
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
                    onTap: () => _showUnavailableFeature(t.manageAddress),
                  ),
                  _buildProfileMenuRow(
                    icon: Icons.star_outline,
                    text: t.rateUs,
                    onTap: () => _showUnavailableFeature(t.rateUs),
                  ),
                  _buildProfileMenuRow(
                    icon: Icons.info_outline,
                    text: t.aboutUs,
                    onTap: () => _showUnavailableFeature(t.aboutUs),
                  ),
                  _buildProfileMenuRow(
                    icon: Icons.privacy_tip_outlined,
                    text: t.privacyPolicy,
                    onTap: () => _showUnavailableFeature(t.privacyPolicy),
                  ),
                  _buildProfileMenuRow(
                    icon: Icons.description_outlined,
                    text: t.termsCondition,
                    onTap: () => _showUnavailableFeature(t.termsCondition),
                  ),
                  _buildProfileMenuRow(
                    icon: Icons.logout,
                    text: t.logout,
                    textColor: const Color(0xFFFF737B),
                    onTap: () async {
                      final confirmed = await _showLogoutConfirmation();
                      if (!confirmed) return;

                      await AuthService.logout();
                      AppToast.showInfo('You have been logged out securely.');

                      if (!context.mounted) return;
                      AppNavigation.resetTo(
                        context,
                        const SignUpScreen(),
                        style: RouteTransitionStyle.fadeScale,
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

  void _showUnavailableFeature(String featureName) {
    AppToast.showComingSoon(featureName);
  }

  Future<bool> _showLogoutConfirmation() async {
    final result = await showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Logout confirmation',
      barrierColor: Colors.black.withOpacity(0.35),
      transitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (context, animation, secondaryAnimation) {
        return const SizedBox.shrink();
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
          reverseCurve: Curves.easeInCubic,
        );

        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.92, end: 1).animate(curved),
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              contentPadding: const EdgeInsets.fromLTRB(22, 22, 22, 8),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 110,
                    child: Lottie.network(
                      'https://assets2.lottiefiles.com/packages/lf20_jbrw3hcz.json',
                      repeat: true,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 84,
                          height: 84,
                          decoration: const ShapeDecoration(
                            color: Color(0xFFFFF2F2),
                            shape: OvalBorder(),
                          ),
                          child: const Icon(
                            Icons.logout,
                            color: Color(0xFFFF737B),
                            size: 42,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Are you sure you want to logout?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF1E1E1E),
                      fontSize: 18,
                      fontFamily: 'Proxima Nova',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'You will need to sign in again to access your account.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF6B6B6B),
                      fontSize: 13,
                      fontFamily: 'Proxima Nova',
                      fontWeight: FontWeight.w400,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
              actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              actions: [
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context, false),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF0880C6)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: Color(0xFF0880C6),
                            fontFamily: 'Proxima Nova',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 248, 9, 21),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Logout',
                          style: TextStyle(
                            fontFamily: 'Proxima Nova',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    return result ?? false;
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
