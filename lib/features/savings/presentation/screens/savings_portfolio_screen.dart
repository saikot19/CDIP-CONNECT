import 'package:cdip_connect/core/services/localization_service.dart';
import 'package:cdip_connect/core/services/shared_preference_service.dart';
import 'package:cdip_connect/core/utils/app_formatters.dart';
import 'package:cdip_connect/core/utils/app_navigation.dart';
import 'package:cdip_connect/core/utils/display_formatters.dart';
import 'package:cdip_connect/features/dashboard/presentation/screens/home_screen.dart';
import 'package:cdip_connect/features/loans/presentation/screens/loan_portfolio_screen.dart';
import 'package:cdip_connect/features/savings/presentation/screens/savings_details_screen.dart';
import 'package:cdip_connect/shared/models/login_response_model.dart';
import 'package:cdip_connect/shared/widgets/bottom_nav_bar.dart';
import 'package:cdip_connect/shared/widgets/app_back_button.dart';
import 'package:cdip_connect/shared/widgets/empty_portfolio_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SavingsPortfolioScreen extends ConsumerStatefulWidget {
  final AllSummary allSummary;

  const SavingsPortfolioScreen({super.key, required this.allSummary});

  @override
  ConsumerState<SavingsPortfolioScreen> createState() => _SavingsPortfolioScreenState();
}

class _SavingsPortfolioScreenState extends ConsumerState<SavingsPortfolioScreen>
    with SingleTickerProviderStateMixin {
  static const Color _deepBlue = Color(0xFF073D82);
  static const Color _lightBlue = Color(0xFF0878C8);
  static const Color _closedGrey = Color(0xFF8A8A8A);

  late TabController _tabController;
  String _lastUpdated = 'Sync pending';

  final List<UserSaving> _activeSavings = [];
  final List<UserSaving> _closedSavings = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadLastUpdated();
    _filterSavings();
  }

  @override
  void didUpdateWidget(covariant SavingsPortfolioScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.allSummary != widget.allSummary) {
      _filterSavings();
    }
  }

  void _filterSavings() {
    _activeSavings
      ..clear()
      ..addAll(widget.allSummary.savings.where((saving) => saving.isOpen));
    _closedSavings
      ..clear()
      ..addAll(widget.allSummary.savings.where((saving) => !saving.isOpen));
  }

  Future<void> _loadLastUpdated() async {
    final prefsService = SharedPreferenceService();
    final lastUpdated = await prefsService.getLastUpdated();
    if (!mounted) return;
    if (lastUpdated != null && lastUpdated.isNotEmpty) {
      setState(() => _lastUpdated = DisplayFormatters.formatLastUpdated(lastUpdated));
    }
  }

  void switchToLoan() {
    Navigator.pushReplacement(
      context,
      AppNavigation.smoothRoute(
        builder: (context) => LoanPortfolioScreen(allSummary: widget.allSummary),
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
    final lastUpdatedText = _lastUpdated == 'Sync pending' ? t.syncPending : AppFormatters.digits(_lastUpdated);

    return WillPopScope(
      onWillPop: () async {
        _goHome();
        return false;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                      color: Theme.of(context).cardColor,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildSavingsList(_activeSavings, true, t),
                          _buildSavingsList(_closedSavings, false, t),
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
                  t.savingsPortfolio,
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
          Expanded(child: _buildPortfolioTab(t.loanPortfolio, false, switchToLoan)),
          const SizedBox(width: 18),
          Expanded(child: _buildPortfolioTab(t.savingsPortfolio, true, () {})),
        ],
      ),
    );
  }

  Widget _buildTabBar(AppLocalizations t) {
    return Container(
      color: Theme.of(context).cardColor,
      child: TabBar(
        controller: _tabController,
        indicatorColor: const Color(0xFF0880C6),
        labelColor: const Color(0xFF0880C6),
        unselectedLabelColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.55),
        tabs: [
          Tab(text: t.activeSavings),
          Tab(text: t.closedSavings),
        ],
      ),
    );
  }

  Widget _buildSavingsList(List<UserSaving> savings, bool isActive, AppLocalizations t) {
    if (savings.isEmpty) {
      return EmptyPortfolioState(
        title: isActive ? t.noActiveSavingsTitle : t.noClosedSavingsTitle,
        message: isActive ? t.noActiveSavingsMessage : t.noClosedSavingsMessage,
        fallbackIcon: Icons.savings_outlined,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 100),
      itemCount: savings.length,
      itemBuilder: (context, index) {
        return _buildSavingsCard(context, savings[index], index, isTappable: isActive, t: t);
      },
    );
  }

  Widget _buildSavingsCard(
    BuildContext context,
    UserSaving saving,
    int index, {
    required bool isTappable,
    required AppLocalizations t,
  }) {
    final color = saving.isOpen ? (index.isEven ? _deepBlue : _lightBlue) : _closedGrey;
    final initials = _savingInitials(saving.productName);

    return GestureDetector(
      onTap: isTappable
          ? () {
              Navigator.push(
                context,
                AppNavigation.smoothRoute(
                  style: RouteTransitionStyle.modalSheet,
                  builder: (context) => SavingsDetailsScreen(
                    savingsId: saving.savingsId,
                    productName: saving.productName ?? 'Savings Account',
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
            BoxShadow(
              color: Color(0x26000000),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _InitialBadge(text: initials),
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
                          saving.productName ?? 'Savings',
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
                          '#${saving.code}',
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
                    title: t.openingDate,
                    value: AppFormatters.date(saving.openingDate),
                  ),
                  const SizedBox(height: 10),
                  _CardDetailRow(
                    icon: Icons.payments_outlined,
                    title: t.totalSavingsAmount,
                    value: AppFormatters.amount(saving.netSavingAmount, suffix: t.bdt),
                  ),
                  if (!saving.isOpen) ...[
                    const SizedBox(height: 10),
                    _CardDetailRow(
                      icon: Icons.event_busy_outlined,
                      title: 'Closing Date',
                      value: AppFormatters.date(saving.closingDate),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _savingInitials(String? name) {
    final cleaned = (name ?? 'SA').trim().replaceAll(RegExp(r'\s+'), ' ');
    if (cleaned.isEmpty) return 'SA';
    final words = cleaned.split(' ').where((word) => word.isNotEmpty).toList();
    if (words.length == 1) {
      final end = words.first.length < 2 ? words.first.length : 2;
      return words.first.substring(0, end).toUpperCase();
    }
    return words.take(3).map((word) => word[0].toUpperCase()).join();
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
            fontSize: 20,
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

  const _CardDetailRow({
    required this.icon,
    required this.title,
    required this.value,
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
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    title,
                    maxLines: 1,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
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
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
                        fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
