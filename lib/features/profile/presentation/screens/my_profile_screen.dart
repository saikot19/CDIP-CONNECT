import 'package:cdip_connect/core/services/localization_service.dart';
import 'package:cdip_connect/core/utils/app_feedback.dart';
import 'package:cdip_connect/core/utils/app_navigation.dart';
import 'package:cdip_connect/core/utils/app_toast.dart';
import 'package:cdip_connect/core/utils/app_formatters.dart';
import 'package:cdip_connect/features/auth/application/auth_service.dart';
import 'package:cdip_connect/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:cdip_connect/features/dashboard/presentation/screens/home_screen.dart';
import 'package:cdip_connect/features/loans/presentation/screens/loan_portfolio_screen.dart';
import 'package:cdip_connect/shared/models/login_response_model.dart';
import 'package:cdip_connect/shared/widgets/bottom_nav_bar.dart';
import 'package:cdip_connect/shared/widgets/app_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyProfileScreen extends ConsumerStatefulWidget {
  const MyProfileScreen({super.key});

  @override
  ConsumerState<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends ConsumerState<MyProfileScreen> {
  String _memberName = 'User';
  String _memberCode = '000000000000';
  String _branchName = 'N/A';
  AllSummary? _allSummary;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final memberName = await AuthService.getMemberName();
    final memberCode = await AuthService.getMemberCode();
    final summary = await AuthService.getUserAllSummary();
    final loginResponse = await AuthService.getLoginResponse();

    if (!mounted) return;
    setState(() {
      _memberName = memberName.trim().isEmpty ? 'User' : memberName.trim();
      _memberCode = memberCode.trim().isEmpty ? '000000000000' : memberCode.trim();
      _allSummary = summary;
      if (loginResponse != null) {
        _branchName = loginResponse.userData.branchName.trim().isEmpty
            ? 'N/A'
            : loginResponse.userData.branchName.trim();
      }
    });
  }

  void _goHome() {
    AppNavigation.resetTo(
      context,
      const HomeScreen(),
      style: RouteTransitionStyle.cupertino,
    );
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(localizationProvider);
    final t = AppLocalizations(language);

    return WillPopScope(
      onWillPop: () async {
        _goHome();
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F6F6),
        body: Stack(
          children: [
            Positioned.fill(
              bottom: 80,
              child: SafeArea(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: constraints.maxHeight - 36),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTopBar(t),
                            const SizedBox(height: 22),
                            _buildProfileSummary(t),
                            const SizedBox(height: 18),
                            _buildMenuCard(t, language),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
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

  Widget _buildTopBar(AppLocalizations t) {
    return Row(
      children: [
        AppBackButton(onTap: _goHome),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            t.myProfile,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 24,
                            fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileSummary(AppLocalizations t) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF0880C6), width: 2),
              color: const Color(0xFF0880C6).withOpacity(0.08),
            ),
            child: const Icon(
              Icons.person_outline_rounded,
              color: Color(0xFF0880C6),
              size: 32,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _memberName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF1E1E1E),
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                _ProfileInfoLine(label: t.memberCode, value: _memberCode),
                const SizedBox(height: 4),
                _ProfileInfoLine(label: t.branchName, value: _branchName),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(AppLocalizations t, String language) {
    final rows = [
      _ProfileMenuAction(
        icon: Icons.account_balance_wallet_outlined,
        text: t.myPortfolio,
        onTap: () {
          if (_allSummary != null) {
            Navigator.push(
              context,
              AppNavigation.smoothRoute(
                builder: (context) => LoanPortfolioScreen(allSummary: _allSummary!),
              ),
            );
          }
        },
      ),
      _ProfileMenuAction(
        icon: Icons.assignment_outlined,
        text: t.applicationHistory,
        onTap: () => _showUnavailableFeature(t.applicationHistory),
      ),
      _ProfileMenuAction(
        icon: Icons.translate_rounded,
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
      _ProfileMenuAction(
        icon: Icons.location_on_outlined,
        text: t.manageAddress,
        onTap: () => _showUnavailableFeature(t.manageAddress),
      ),
      _ProfileMenuAction(
        icon: Icons.star_outline_rounded,
        text: t.rateUs,
        onTap: () => _showUnavailableFeature(t.rateUs),
      ),
      _ProfileMenuAction(
        icon: Icons.info_outline_rounded,
        text: t.aboutUs,
        onTap: () => _showUnavailableFeature(t.aboutUs),
      ),
      _ProfileMenuAction(
        icon: Icons.privacy_tip_outlined,
        text: t.privacyPolicy,
        onTap: () => _showUnavailableFeature(t.privacyPolicy),
      ),
      _ProfileMenuAction(
        icon: Icons.more_horiz_rounded,
        text: t.termsCondition,
        onTap: () => _showUnavailableFeature(t.termsCondition),
      ),
      _ProfileMenuAction(
        icon: Icons.logout_rounded,
        text: t.logout,
        iconColor: const Color(0xFFFF5733),
        textColor: const Color(0xFF3A3A3A),
        onTap: _logout,
      ),
    ];

    return Column(
      children: rows.map((row) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: _ProfileMenuRow(action: row),
        );
      }).toList(),
    );
  }

  void _showUnavailableFeature(String featureName) {
    AppToast.showComingSoon(featureName);
  }

  Future<void> _logout() async {
    final confirmed = await AppFeedback.confirmLogout(context);
    if (!confirmed) return;

    await AuthService.logout();
    AppToast.showInfo('You have been logged out securely.');

    if (!mounted) return;
    AppNavigation.resetTo(
      context,
      const SignUpScreen(),
      style: RouteTransitionStyle.fadeScale,
    );
  }
}

class _ProfileInfoLine extends StatelessWidget {
  final String label;
  final String value;

  const _ProfileInfoLine({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$label: ',
            style: const TextStyle(
              color: Color(0xFF3A3A3A),
              fontSize: 12,
                            fontWeight: FontWeight.w700,
            ),
          ),
          TextSpan(
            text: AppFormatters.digits(value),
            style: const TextStyle(
              color: Color(0xFF3A3A3A),
              fontSize: 12,
                            fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _ProfileMenuAction {
  final IconData icon;
  final String text;
  final VoidCallback onTap;
  final Color iconColor;
  final Color textColor;

  const _ProfileMenuAction({
    required this.icon,
    required this.text,
    required this.onTap,
    this.iconColor = const Color(0xFF0878C8),
    this.textColor = const Color(0xFF3A3A3A),
  });
}

class _ProfileMenuRow extends StatelessWidget {
  final _ProfileMenuAction action;

  const _ProfileMenuRow({required this.action});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: action.onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 54,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 16,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: ShapeDecoration(
                  color: action.iconColor,
                  shape: const OvalBorder(),
                ),
                child: Icon(action.icon, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 22),
              Expanded(
                child: Text(
                  action.text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: action.textColor,
                    fontSize: 13,
                                        fontWeight: FontWeight.w400,
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
