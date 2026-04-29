import 'dart:async';
import 'dart:math' as math;

import 'package:cdip_connect/shared/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:cdip_connect/shared/data/local/database_helper.dart';
import 'package:cdip_connect/shared/models/login_response_model.dart';
import 'package:cdip_connect/features/auth/application/auth_service.dart';
import 'package:cdip_connect/features/loans/presentation/screens/loan_portfolio_screen.dart' as loan;
import 'package:cdip_connect/features/savings/presentation/screens/savings_portfolio_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<String> _memberNameFuture;
  late Future<DashboardSummary?> _dashboardSummaryFuture;
  late Future<List<MarketingBanner>> _bannersFuture;
  late Future<AllSummary?> _allSummaryFuture;
  late Future<bool> _updateAvailableFuture;

  final PageController _bannerController = PageController();
  Timer? _bannerAutoScrollTimer;
  int _currentBannerIndex = 0;

  static final AllSummary _emptySummary = AllSummary(
    memberId: '',
    loanCount: 0,
    loans: [],
    savingCount: 0,
    savings: [],
    marketingBanners: [],
  );

  @override
  void initState() {
    super.initState();

    _memberNameFuture = AuthService.getMemberName();
    _dashboardSummaryFuture = AuthService.getDashboardSummary();
    _bannersFuture = DatabaseHelper().getMarketingBanners();
    _allSummaryFuture = AuthService.getUserAllSummary();
    _updateAvailableFuture = _checkForUpdate();

    _startBannerAutoScroll();
  }

  @override
  void dispose() {
    _bannerAutoScrollTimer?.cancel();
    _bannerController.dispose();
    super.dispose();
  }

  void _startBannerAutoScroll() {
    _bannersFuture.then((banners) {
      if (!mounted || banners.length <= 1) return;

      _bannerAutoScrollTimer?.cancel();

      _bannerAutoScrollTimer = Timer.periodic(
        const Duration(seconds: 4),
        (_) {
          if (!mounted || !_bannerController.hasClients) return;

          final nextIndex = (_currentBannerIndex + 1) % banners.length;

          _bannerController.animateToPage(
            nextIndex,
            duration: const Duration(milliseconds: 450),
            curve: Curves.easeInOut,
          );
        },
      );
    }).catchError((_) {
      // Ignore banner auto-scroll setup errors.
    });
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    if (hour < 21) return 'Good Evening';
    return 'Good Night';
  }

  Future<bool> _checkForUpdate() async {
    return false;
  }

  String _formatAmount(dynamic value) {
    if (value == null) return '0';

    try {
      final number = double.parse(value.toString());
      return NumberFormat.decimalPattern('en_IN').format(number.round());
    } catch (_) {
      return value.toString();
    }
  }

  void _openLoanPortfolio(AllSummary summary) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => loan.LoanPortfolioScreen(allSummary: summary),
      ),
    );
  }

  void _openSavingsPortfolio(AllSummary summary) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SavingsPortfolioScreen(allSummary: summary),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: FutureBuilder<AllSummary?>(
        future: _allSummaryFuture,
        builder: (context, summarySnapshot) {
          final allSummary = summarySnapshot.data ?? _emptySummary;

          return Stack(
            children: [
              Positioned.fill(
                bottom: 80,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final sx = constraints.maxWidth / 412;
                    final sy = constraints.maxHeight / 837;
                    final fs = math.min(sx, sy);

                    double x(num value) => value.toDouble() * sx;
                    double y(num value) => value.toDouble() * sy;
                    double w(num value) => value.toDouble() * sx;
                    double h(num value) => value.toDouble() * sy;
                    double f(num value) => value.toDouble() * fs;

                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned.fill(
                          child: Container(
                            color: const Color(0xFFF6F6F6),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          top: 0,
                          width: constraints.maxWidth,
                          height: y(292),
                          child: Container(
                            decoration: const ShapeDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color.fromARGB(255, 2, 34, 212),
                                  Color.fromARGB(255, 0, 26, 71),
                                  Color.fromRGBO(20, 36, 103, 0.8),
                                ],
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: x(20),
                          top: y(50),
                          width: w(32),
                          height: h(32),
                          child: CircleAvatar(
                            backgroundColor: Colors.grey[300],
                            child: Icon(
                              Icons.person,
                              color: Colors.grey,
                              size: f(22),
                            ),
                          ),
                        ),
                        Positioned(
                          right: x(20),
                          top: y(50),
                          width: w(32),
                          height: h(32),
                          child: GestureDetector(
                            onTap: () async {
                              final isUpdateAvailable =
                                  await _updateAvailableFuture;

                              if (!mounted) return;

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    isUpdateAvailable
                                        ? 'New version available. Please update!'
                                        : 'App is up to date',
                                  ),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Center(
                                  child: Icon(
                                    Icons.notifications_outlined,
                                    color: Colors.white,
                                    size: f(24),
                                  ),
                                ),
                                FutureBuilder<bool>(
                                  future: _updateAvailableFuture,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData &&
                                        snapshot.data == true) {
                                      return Positioned(
                                        right: x(2),
                                        top: y(2),
                                        child: Container(
                                          width: w(7),
                                          height: h(7),
                                          decoration: const ShapeDecoration(
                                            color: Color(0xFFFF0000),
                                            shape: OvalBorder(),
                                          ),
                                        ),
                                      );
                                    }

                                    return const SizedBox.shrink();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          left: x(20),
                          top: y(105),
                          child: Text(
                            '${_getGreeting()},',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: f(16),
                              fontFamily: 'Proxima Nova',
                              fontWeight: FontWeight.w400,
                              height: 1,
                            ),
                          ),
                        ),
                        Positioned(
                          left: x(20),
                          top: y(129),
                          width: w(280),
                          child: FutureBuilder<String>(
                            future: _memberNameFuture,
                            builder: (context, snapshot) {
                              return Text(
                                snapshot.data?.isNotEmpty == true
                                    ? snapshot.data!
                                    : 'Member',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: f(24),
                                  fontFamily: 'Proxima Nova',
                                  fontWeight: FontWeight.w700,
                                  height: 0.83,
                                ),
                              );
                            },
                          ),
                        ),
                        Positioned(
                          left: x(20),
                          top: y(161),
                          width: w(372),
                          height: h(383),
                          child: Container(
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              shadows: const [
                                BoxShadow(
                                  color: Color(0x19000000),
                                  blurRadius: 4,
                                  offset: Offset(0, 4),
                                )
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          left: x(34),
                          top: y(175),
                          child: Text(
                            'Your Portfolio Summary',
                            style: TextStyle(
                              color: const Color(0xFF1E1E1E),
                              fontSize: f(16),
                              fontFamily: 'Proxima Nova',
                              fontWeight: FontWeight.w700,
                              height: 2.13,
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: FutureBuilder<DashboardSummary?>(
                            future: _dashboardSummaryFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Stack(
                                  children: [
                                    Positioned(
                                      left: x(20),
                                      top: y(215),
                                      width: w(372),
                                      height: h(317),
                                      child: const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                                  ],
                                );
                              }

                              final summary = snapshot.data;
                              if (summary == null) {
                                return Stack(
                                  children: [
                                    Positioned(
                                      left: x(34),
                                      top: y(220),
                                      child: const Text(
                                        'Unable to load portfolio data',
                                      ),
                                    ),
                                  ],
                                );
                              }

                              return Stack(
                                children: [
                                  _buildSummaryCard(
                                    sx: sx,
                                    sy: sy,
                                    fs: fs,
                                    left: 29,
                                    top: 215,
                                    color: const Color(0xFF2370A1),
                                    iconAsset:
                                        'assets/logo/flowbite_chart-pie-outline.png',
                                    title: 'Total Outstanding',
                                    amount:
                                        '${_formatAmount(summary.loanOutstanding)} BDT',
                                    countLabel: 'Number of Loans',
                                    count: summary.loanCount.toString(),
                                    onTap: () => _openLoanPortfolio(allSummary),
                                  ),
                                  _buildSummaryCard(
                                    sx: sx,
                                    sy: sy,
                                    fs: fs,
                                    left: 29,
                                    top: 323,
                                    color: const Color(0xFF075F63),
                                    iconAsset: 'assets/logo/Group.png',
                                    title: 'Total Savings',
                                    amount:
                                        '${_formatAmount(summary.savingsOutstanding)} BDT',
                                    countLabel: 'Number of Savings',
                                    count: summary.savingsCount.toString(),
                                    onTap: () =>
                                        _openSavingsPortfolio(allSummary),
                                  ),
                                  _buildSummaryCard(
                                    sx: sx,
                                    sy: sy,
                                    fs: fs,
                                    left: 29,
                                    top: 431,
                                    color: const Color(0xFFFF5959),
                                    iconAsset:
                                        'assets/logo/zondicons_minus-outline.png',
                                    title: 'Total Due Amount',
                                    amount:
                                        '${_formatAmount(summary.dueLoanAmount)} BDT',
                                    countLabel: 'Number of Due Loans',
                                    count: summary.dueLoanCount.toString(),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        Positioned(
                          left: x(20),
                          top: y(544),
                          child: Text(
                            'Manage Portfolio',
                            style: TextStyle(
                              color: const Color(0xFF1E1E1E),
                              fontSize: f(16),
                              fontFamily: 'Proxima Nova',
                              fontWeight: FontWeight.w700,
                              height: 2.13,
                            ),
                          ),
                        ),
                        _buildManageButton(
                          sx: sx,
                          sy: sy,
                          fs: fs,
                          left: 20,
                          top: 578,
                          asset: 'assets/logo/Cash in Hand.png',
                          label: 'Loan',
                          onTap: () => _openLoanPortfolio(allSummary),
                        ),
                        _buildManageButton(
                          sx: sx,
                          sy: sy,
                          fs: fs,
                          left: 168,
                          top: 578,
                          asset: 'assets/logo/Request Money.png',
                          label: 'Savings',
                          onTap: () => _openSavingsPortfolio(allSummary),
                        ),
                        _buildManageButton(
                          sx: sx,
                          sy: sy,
                          fs: fs,
                          left: 316,
                          top: 578,
                          asset: 'assets/logo/Pocket Money.png',
                          label: 'Referral',
                          onTap: () {},
                        ),
                        Positioned(
                          left: x(20),
                          top: y(692),
                          width: w(372),
                          height: h(108),
                          child: _buildBanner(),
                        ),
                        Positioned(
                          left: 0,
                          top: y(813),
                          width: constraints.maxWidth,
                          height: h(6),
                          child: _buildDotIndicators(fs),
                        ),
                      ],
                    );
                  },
                ),
              ),
              FutureBuilder<String>(
                future: _memberNameFuture,
                builder: (context, memberSnapshot) {
                  return BottomNavBar(
                    isHome: true,
                    memberName: memberSnapshot.data ?? '',
                    allSummary: allSummary,
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard({
    required double sx,
    required double sy,
    required double fs,
    required double left,
    required double top,
    required Color color,
    required String iconAsset,
    required String title,
    required String amount,
    required String countLabel,
    required String count,
    VoidCallback? onTap,
  }) {
    double x(num value) => value.toDouble() * sx;
    double y(num value) => value.toDouble() * sy;
    double w(num value) => value.toDouble() * sx;
    double h(num value) => value.toDouble() * sy;
    double f(num value) => value.toDouble() * fs;

    return Positioned(
      left: x(left),
      top: y(top),
      width: w(351),
      height: h(101),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: ShapeDecoration(
            color: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                left: w(14),
                top: h(32),
                width: w(42),
                height: h(42),
                child: Image.asset(
                  iconAsset,
                  width: w(42),
                  height: h(42),
                  color: Colors.white,
                  fit: BoxFit.contain,
                ),
              ),
              Positioned(
                left: w(71),
                top: h(31),
                width: w(155),
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: f(14),
                    fontFamily: 'Proxima Nova',
                    fontWeight: FontWeight.w600,
                    height: 1,
                  ),
                ),
              ),
              Positioned(
                left: w(71),
                top: h(53),
                width: w(170),
                child: Text(
                  amount,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: f(title == 'Total Due Amount' ? 25 : 23),
                    fontFamily: 'Proxima Nova',
                    fontWeight: FontWeight.w600,
                    height: title == 'Total Due Amount' ? 1 : 1.09,
                  ),
                ),
              ),
              Positioned(
                right: w(14),
                top: h(31),
                width: w(110),
                child: Text(
                  countLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: f(12),
                    fontFamily: 'Proxima Nova',
                    fontWeight: FontWeight.w600,
                    height: 1.17,
                  ),
                ),
              ),
              Positioned(
                right: w(14),
                top: h(53),
                width: w(110),
                child: Text(
                  count,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: f(23),
                    fontFamily: 'Proxima Nova',
                    fontWeight: FontWeight.w600,
                    height: 1.09,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildManageButton({
    required double sx,
    required double sy,
    required double fs,
    required double left,
    required double top,
    required String asset,
    required String label,
    required VoidCallback onTap,
  }) {
    double x(num value) => value.toDouble() * sx;
    double y(num value) => value.toDouble() * sy;
    double w(num value) => value.toDouble() * sx;
    double h(num value) => value.toDouble() * sy;
    double f(num value) => value.toDouble() * fs;

    return Positioned(
      left: x(left),
      top: y(top),
      width: w(76),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              width: w(76),
              height: h(76),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                shadows: const [
                  BoxShadow(
                    color: Color(0x5E000000),
                    blurRadius: 20,
                    offset: Offset(0, 4),
                    spreadRadius: -9,
                  )
                ],
              ),
              child: Center(
                child: Image.asset(
                  asset,
                  width: w(46),
                  height: h(46),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(height: h(11)),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: f(14),
                fontFamily: 'Proxima Nova',
                fontWeight: FontWeight.w500,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return FutureBuilder<List<MarketingBanner>>(
      future: _bannersFuture,
      builder: (context, snapshot) {
        final banners = snapshot.data ?? [];

        if (banners.isEmpty) {
          return Container(
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }

        return PageView.builder(
          controller: _bannerController,
          itemCount: banners.length,
          onPageChanged: (index) {
            setState(() {
              _currentBannerIndex = index;
            });
          },
          itemBuilder: (context, index) {
            final banner = banners[index];
            final imageUrl =
                'https://connect.cdipits.site/public/${banner.image}';

            return Container(
              decoration: ShapeDecoration(
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                  onError: (exception, stackTrace) {
                    print('❌ Banner Image Error: $exception');
                  },
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDotIndicators(double fs) {
    return FutureBuilder<List<MarketingBanner>>(
      future: _bannersFuture,
      builder: (context, snapshot) {
        final banners = snapshot.data ?? [];
        final count = banners.isEmpty ? 4 : banners.length;

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(count, (index) {
            final isActive = index == _currentBannerIndex;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              margin: EdgeInsets.symmetric(horizontal: 1.5 * fs),
              width: 6 * fs,
              height: 6 * fs,
              decoration: ShapeDecoration(
                color: isActive
                    ? const Color(0xFF0880C6)
                    : const Color(0xFFEBEBEB),
                shape: const OvalBorder(),
              ),
            );
          }),
        );
      },
    );
  }
}
