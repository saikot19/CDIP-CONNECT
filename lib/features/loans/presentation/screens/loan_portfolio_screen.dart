import 'package:cdip_connect/core/services/localization_service.dart';
import 'package:cdip_connect/core/services/shared_preference_service.dart';
import 'package:cdip_connect/core/utils/app_formatters.dart';
import 'package:cdip_connect/core/utils/app_navigation.dart';
import 'package:cdip_connect/core/utils/display_formatters.dart';
import 'package:cdip_connect/features/dashboard/presentation/screens/home_screen.dart';
import 'package:cdip_connect/features/loans/presentation/screens/loan_details_screen.dart';
import 'package:cdip_connect/features/savings/presentation/screens/savings_portfolio_screen.dart';
import 'package:cdip_connect/shared/models/login_response_model.dart';
import 'package:cdip_connect/shared/widgets/bottom_nav_bar.dart';
import 'package:cdip_connect/shared/widgets/app_back_button.dart';
import 'package:cdip_connect/shared/widgets/empty_portfolio_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoanPortfolioScreen extends ConsumerStatefulWidget {
  final AllSummary allSummary;

  const LoanPortfolioScreen({super.key, required this.allSummary});

  @override
  ConsumerState<LoanPortfolioScreen> createState() => _LoanPortfolioScreenState();
}

class _LoanPortfolioScreenState extends ConsumerState<LoanPortfolioScreen>
    with SingleTickerProviderStateMixin {
  static const Color _deepBlue = Color(0xFF073D82);
  static const Color _lightBlue = Color(0xFF0878C8);
  static const Color _closedGrey = Color(0xFF8A8A8A);

  late TabController _tabController;
  String _lastUpdated = 'Sync pending';

  final List<UserLoan> _activeLoans = [];
  final List<UserLoan> _closedLoans = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadLastUpdated();
    _filterLoans();
  }

  @override
  void didUpdateWidget(covariant LoanPortfolioScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.allSummary != widget.allSummary) {
      _filterLoans();
    }
  }

  void _filterLoans() {
    _activeLoans
      ..clear()
      ..addAll(widget.allSummary.loans.where((loan) => loan.isOpen));
    _closedLoans
      ..clear()
      ..addAll(widget.allSummary.loans.where((loan) => !loan.isOpen));

    _closedLoans.sort((a, b) {
      final aDate = DateTime.tryParse(a.disburseDate);
      final bDate = DateTime.tryParse(b.disburseDate);
      if (aDate == null && bDate == null) return 0;
      if (aDate == null) return 1;
      if (bDate == null) return -1;
      return bDate.compareTo(aDate);
    });
  }

  Future<void> _loadLastUpdated() async {
    final prefsService = SharedPreferenceService();
    final lastUpdated = await prefsService.getLastUpdated();
    if (!mounted) return;
    if (lastUpdated != null && lastUpdated.isNotEmpty) {
      setState(() => _lastUpdated = DisplayFormatters.formatLastUpdated(lastUpdated));
    }
  }

  void switchToSavings() {
    Navigator.pushReplacement(
      context,
      AppNavigation.smoothRoute(
        builder: (context) => SavingsPortfolioScreen(allSummary: widget.allSummary),
      ),
    );
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
    final t = AppLocalizations(ref.watch(localizationProvider));
    final top = MediaQuery.paddingOf(context).top;
    final lastUpdatedText = _lastUpdated == 'Sync pending' ? t.syncPending : _lastUpdated;

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
              child: Column(
                children: [
                  _buildHeader(top, t, lastUpdatedText),
                  _buildPortfolioSwitch(t),
                  _buildTabBar(t),
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildLoanList(_activeLoans, true, t),
                          _buildLoanList(_closedLoans, false, t),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            BottomNavBar(
              isHome: false,
              memberName: '',
              allSummary: widget.allSummary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(double top, AppLocalizations t, String lastUpdatedText) {
    return Column(
      children: [
        Container(
          height: top + 116,
          width: double.infinity,
          padding: EdgeInsets.only(left: 20, right: 20, top: top + 34),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 9, 14, 84),
                Color.fromARGB(255, 50, 61, 178),
              ],
            ),
          ),
          child: Row(
            children: [
              AppBackButton(
                onTap: _goHome,
                color: Colors.white,
                size: 24,
                touchSize: 38,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  t.loanPortfolio,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                                        fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          height: 23,
          color: const Color(0xFF05A300),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            '${t.transactionsLastUpdatedOn} $lastUpdatedText',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
                          ),
          ),
        ),
      ],
    );
  }

  Widget _buildPortfolioSwitch(AppLocalizations t) {
    return Container(
      color: const Color(0xFFF5F3F3),
      padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 20),
      child: Row(
        children: [
          Expanded(child: _buildPortfolioTab(t.loanPortfolio, true, () {})),
          const SizedBox(width: 18),
          Expanded(child: _buildPortfolioTab(t.savingsPortfolio, false, switchToSavings)),
        ],
      ),
    );
  }

  Widget _buildTabBar(AppLocalizations t) {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        indicatorColor: const Color(0xFF0880C6),
        labelColor: const Color(0xFF0880C6),
        unselectedLabelColor: Colors.black.withOpacity(0.5),
        tabs: [
          Tab(text: t.activeLoan),
          Tab(text: t.closedLoan),
        ],
      ),
    );
  }

  Widget _buildLoanList(List<UserLoan> loans, bool isActive, AppLocalizations t) {
    if (loans.isEmpty) {
      return EmptyPortfolioState(
        title: isActive ? t.noActiveLoansTitle : t.noClosedLoansTitle,
        message: isActive ? t.noActiveLoansMessage : t.noClosedLoansMessage,
        fallbackIcon: Icons.account_balance_wallet_outlined,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 100),
      itemCount: loans.length,
      itemBuilder: (context, index) {
        final isMostRecentClosed = !isActive && index == 0;
        return _buildLoanCard(
          context,
          loans[index],
          index,
          isTappable: isActive || isMostRecentClosed,
          t: t,
        );
      },
    );
  }

  Widget _buildLoanCard(
    BuildContext context,
    UserLoan loan,
    int index, {
    required bool isTappable,
    required AppLocalizations t,
  }) {
    final color = loan.isOpen ? (index.isEven ? _deepBlue : _lightBlue) : _closedGrey;
    final letter = loan.loanProductName.trim().isNotEmpty ? loan.loanProductName.trim()[0].toUpperCase() : 'L';

    return GestureDetector(
      onTap: isTappable
          ? () {
              Navigator.push(
                context,
                AppNavigation.smoothRoute(
                  style: RouteTransitionStyle.modalSheet,
                  builder: (context) => LoanDetailsScreen(
                    loanId: loan.loanId,
                    productName: loan.loanProductName,
                  ),
                ),
              );
            }
          : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
        constraints: const BoxConstraints(minHeight: 150),
        decoration: ShapeDecoration(
          color: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          shadows: const [
            BoxShadow(color: Color(0x26000000), blurRadius: 8, offset: Offset(0, 4)),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _InitialBadge(text: letter),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          loan.loanProductName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                                                        fontWeight: FontWeight.w700,
                            height: 1.25,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          '#${loan.customizedLoanNo}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                                                        fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  _CardDetailRow(
                    icon: Icons.calendar_today_outlined,
                    title: t.disbursementDate,
                    value: AppFormatters.date(loan.disburseDate),
                  ),
                  const SizedBox(height: 10),
                  _CardDetailRow(
                    icon: Icons.payments_outlined,
                    title: t.outstanding,
                    value: AppFormatters.amount(loan.outstandingAmount, suffix: t.bdt),
                  ),
                  const SizedBox(height: 10),
                  _CardDetailRow(
                    icon: Icons.money_off_outlined,
                    title: t.overdue,
                    value: AppFormatters.amount(loan.overdueAmount, suffix: t.bdt),
                    valueColor: loan.isOverdue ? Colors.redAccent : Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPortfolioTab(String title, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 49,
        alignment: Alignment.center,
        decoration: ShapeDecoration(
          color: isActive ? const Color(0xFF0442BF) : Colors.transparent,
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1, color: isActive ? Colors.transparent : const Color(0xFF0442BF)),
            borderRadius: BorderRadius.circular(10),
          ),
          shadows: isActive
              ? const [BoxShadow(color: Color(0x26000000), blurRadius: 10, offset: Offset(0, 4))]
              : const [],
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            title,
            maxLines: 1,
            style: TextStyle(
              color: isActive ? Colors.white : const Color(0xFF0442BF),
              fontSize: 14,
                            fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

class _InitialBadge extends StatelessWidget {
  final String text;

  const _InitialBadge({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          maxLines: 1,
          style: const TextStyle(
            color: Color(0xFF0880C6),
            fontSize: 24,
                        fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _CardDetailRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color valueColor;

  const _CardDetailRow({
    required this.icon,
    required this.title,
    required this.value,
    this.valueColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 14),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                                        fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.right,
          style: TextStyle(
            color: valueColor,
            fontSize: 15,
                        fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
