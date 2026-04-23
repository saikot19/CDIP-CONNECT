import 'package:cdip_connect/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/login_response_model.dart';
import '../services/auth_service.dart';
import 'loan_portfolio_screen.dart' as loan;
import 'savings_portfolio_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late Future<String> _memberNameFuture;
  late Future<DashboardSummary?> _dashboardSummaryFuture;
  late Future<List<MarketingBanner>> _bannersFuture;
  late Future<AllSummary?> _allSummaryFuture;
  late Future<bool> _updateAvailableFuture;

  final PageController _bannerController = PageController();
  int _currentBannerIndex = 0;

  late AnimationController _animationController;
  late Animation<double> _summaryFadeAnimation;
  late Animation<Offset> _summarySlideAnimation;
  late Animation<double> _manageFadeAnimation;
  late Animation<Offset> _manageSlideAnimation;
  late Animation<double> _bannerFadeAnimation;
  late Animation<Offset> _bannerSlideAnimation;

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

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _summaryFadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
    );

    _summarySlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOutCubic),
      ),
    );

    _manageFadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.7, curve: Curves.easeOut),
    );

    _manageSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.7, curve: Curves.easeOutCubic),
      ),
    );

    _bannerFadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.45, 1.0, curve: Curves.easeOut),
    );

    _bannerSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.45, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _bannerController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    if (hour < 21) return 'Good Evening';
    return 'Good Night';
  }

  Future<bool> _checkForUpdate() async {
    // Keep your existing update-check flow here later.
    return false;
  }

  String _formatCurrency(dynamic value) {
    if (value == null) return '0.00';
    try {
      final numValue = double.parse(value.toString());
      return numValue.toStringAsFixed(2);
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

  Widget _buildAnimatedSection({
    required Animation<double> fade,
    required Animation<Offset> slide,
    required Widget child,
  }) {
    return FadeTransition(
      opacity: fade,
      child: SlideTransition(
        position: slide,
        child: child,
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
              Column(
                children: [
                  _buildHeaderAndSummary(context, allSummary),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 100),
                      child: Column(
                        children: [
                          _buildAnimatedSection(
                            fade: _manageFadeAnimation,
                            slide: _manageSlideAnimation,
                            child: _buildManagePortfolio(context, allSummary),
                          ),
                          const SizedBox(height: 20),
                          _buildAnimatedSection(
                            fade: _bannerFadeAnimation,
                            slide: _bannerSlideAnimation,
                            child: Column(
                              children: [
                                _buildBottomBanner(context),
                                const SizedBox(height: 15),
                                _buildDotIndicators(),
                              ],
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                ],
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

  Widget _buildHeaderAndSummary(BuildContext context, AllSummary allSummary) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 2, 34, 212),
                Color.fromARGB(255, 0, 26, 71),
                Color.fromRGBO(20, 36, 103, 0.8),
              ],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    radius: 29,
                    child:
                        const Icon(Icons.person, size: 32, color: Colors.grey),
                  ),
                  GestureDetector(
                    onTap: () async {
                      final isUpdateAvailable = await _updateAvailableFuture;
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
                      children: [
                        const Icon(
                          Icons.notifications_outlined,
                          size: 28,
                          color: Colors.white,
                        ),
                        FutureBuilder<bool>(
                          future: _updateAvailableFuture,
                          builder: (context, snapshot) {
                            if (snapshot.hasData && snapshot.data == true) {
                              return Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  width: 8,
                                  height: 8,
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
                ],
              ),
              const SizedBox(height: 20),
              Text(
                '${_getGreeting()},',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'Proxima Nova',
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 5),
              FutureBuilder<String>(
                future: _memberNameFuture,
                builder: (context, snapshot) {
                  return Text(
                    snapshot.data ?? 'Member',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontFamily: 'Proxima Nova',
                      fontWeight: FontWeight.w700,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _buildAnimatedSection(
          fade: _summaryFadeAnimation,
          slide: _summarySlideAnimation,
          child: _buildPortfolioSummary(context, allSummary),
        ),
      ],
    );
  }

  Widget _buildPortfolioSummary(BuildContext context, AllSummary allSummary) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(14),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 100,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Portfolio Summary',
            style: TextStyle(
              color: Color(0xFF1E1E1E),
              fontSize: 16,
              fontFamily: 'Proxima Nova',
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 15),
          FutureBuilder<DashboardSummary?>(
            future: _dashboardSummaryFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final summary = snapshot.data;
              if (summary == null) {
                return const Text('Unable to load portfolio data');
              }

              return _buildDashboardSummaryCards(summary, allSummary);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardSummaryCards(
    DashboardSummary summary,
    AllSummary allSummary,
  ) {
    final loanOutstanding = _formatCurrency(summary.loanOutstanding);
    final savingsOutstanding = _formatCurrency(summary.savingsOutstanding);
    final dueAmount = _formatCurrency(summary.dueLoanAmount);

    return Column(
      children: [
        GestureDetector(
          onTap: () => _openLoanPortfolio(allSummary),
          child: _buildSummaryCard(
            color: const Color(0xFF2370A1),
            iconAsset: 'assets/logo/flowbite_chart-pie-outline.png',
            title: 'Total Outstanding',
            amount: loanOutstanding,
            countLabel: 'Number of Loans',
            count: summary.loanCount.toString(),
          ),
        ),
        const SizedBox(height: 7),
        GestureDetector(
          onTap: () => _openSavingsPortfolio(allSummary),
          child: _buildSummaryCard(
            color: const Color(0xFF075F63),
            iconAsset: 'assets/logo/Group.png',
            title: 'Total Savings',
            amount: savingsOutstanding,
            countLabel: 'Number of Savings',
            count: summary.savingsCount.toString(),
          ),
        ),
        const SizedBox(height: 7),
        _buildSummaryCard(
          color: const Color(0xFFFF5959),
          iconAsset: 'assets/logo/zondicons_minus-outline.png',
          title: 'Total Due Amount',
          amount: dueAmount,
          countLabel: 'Number of Due Loans',
          count: summary.dueLoanCount.toString(),
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required Color color,
    required String iconAsset,
    required String title,
    required String amount,
    required String countLabel,
    required String count,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: ShapeDecoration(
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Row(
        children: [
          Image.asset(iconAsset, width: 42, height: 42, color: Colors.white),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '$amount BDT',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                countLabel,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                count,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildManagePortfolio(BuildContext context, AllSummary allSummary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            'Manage Portfolio',
            style: TextStyle(
              color: Color(0xFF1E1E1E),
              fontSize: 16,
              fontFamily: 'Proxima Nova',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildManageButton(
              context,
              'assets/logo/Cash in Hand.png',
              'Loan',
              () => _openLoanPortfolio(allSummary),
            ),
            _buildManageButton(
              context,
              'assets/logo/Request Money.png',
              'Savings',
              () => _openSavingsPortfolio(allSummary),
            ),
            _buildManageButton(
              context,
              'assets/logo/Pocket Money.png',
              'Referral',
              () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildManageButton(
    BuildContext context,
    String asset,
    String label,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
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
                width: 46,
                height: 46,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontFamily: 'Proxima Nova',
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBanner(BuildContext context) {
    return FutureBuilder<List<MarketingBanner>>(
      future: _bannersFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox(height: 108);
        }

        final banners = snapshot.data!;

        return SizedBox(
          height: 108,
          child: PageView.builder(
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
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: ShapeDecoration(
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                    onError: (exception, stackTrace) {
                      print('❌ Banner Image Error: $exception');
                    },
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildDotIndicators() {
    return FutureBuilder<List<MarketingBanner>>(
      future: _bannersFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox(height: 6);
        }

        final banners = snapshot.data!;

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(banners.length, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              margin: const EdgeInsets.symmetric(horizontal: 2.5),
              width: _currentBannerIndex == index ? 12 : 6,
              height: 6,
              decoration: ShapeDecoration(
                color: _currentBannerIndex == index
                    ? const Color(0xFF0880C6)
                    : const Color(0xFFEBEBEB),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
