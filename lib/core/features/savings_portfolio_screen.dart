import 'package:cdip_connect/core/services/shared_preference_service.dart';
import 'package:cdip_connect/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/login_response_model.dart';
import 'loan_portfolio_screen.dart';
import 'savings_details.dart';

class SavingsPortfolioScreen extends StatefulWidget {
  final AllSummary allSummary;

  const SavingsPortfolioScreen({super.key, required this.allSummary});

  @override
  State<SavingsPortfolioScreen> createState() => _SavingsPortfolioScreenState();
}

class _SavingsPortfolioScreenState extends State<SavingsPortfolioScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _lastUpdated = '';

  final List<UserSaving> _activeSavings = [];
  final List<UserSaving> _closedSavings = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadLastUpdated();
    _filterSavings();
  }

  void _filterSavings() {
    for (var saving in widget.allSummary.savings) {
      if (saving.isOpen) {
        _activeSavings.add(saving);
      } else {
        _closedSavings.add(saving);
      }
    }
  }

  Future<void> _loadLastUpdated() async {
    final prefsService = SharedPreferenceService();
    final lastUpdated = await prefsService.getLastUpdated();
    if (lastUpdated != null && lastUpdated.isNotEmpty) {
      try {
        final dateTime = DateTime.parse(lastUpdated);
        final formattedDate = DateFormat('d MMM y').format(dateTime);
        setState(() {
          _lastUpdated = formattedDate;
        });
      } catch (e) {
        setState(() {
          _lastUpdated = lastUpdated;
        });
      }
    }
  }

  void switchToLoan() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoanPortfolioScreen(allSummary: widget.allSummary),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: Stack(
        children: [
          // Header
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: screenWidth,
              height: 116,
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
            ),
          ),
          // Title and back button
          Positioned(
            left: 20,
            top: 58,
            right: 20,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                const SizedBox(width: 13),
                const Text(
                  'Savings Portfolio',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontFamily: 'Proxima Nova',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          // Last updated bar
          Positioned(
            left: 0,
            top: 116,
            child: Container(
              width: screenWidth,
              height: 23,
              color: const Color(0xFF05A300),
              child: Center(
                child: Text(
                  'Transactions Last Updated on $_lastUpdated',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'Proxima Nova',
                  ),
                ),
              ),
            ),
          ),
          // Main Content
          Positioned(
            top: 139,
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              children: [
                // Portfolio Tabs
                Container(
                  color: const Color(0xFFF5F3F3),
                  padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 20),
                  child: Row(
                    children: [
                      _buildPortfolioTab('Loan Portfolio', false, switchToLoan),
                      const SizedBox(width: 18),
                      _buildPortfolioTab('Savings Portfolio', true, () {}),
                    ],
                  ),
                ),
                // Active/Closed Tabs
                Container(
                  color: Colors.white,
                  child: TabBar(
                    controller: _tabController,
                    indicatorColor: const Color(0xFF0880C6),
                    labelColor: const Color(0xFF0880C6),
                    unselectedLabelColor: Colors.black.withOpacity(0.5),
                    tabs: const [
                      Tab(text: 'Active Savings'),
                      Tab(text: 'Closed Savings'),
                    ],
                  ),
                ),
                // Tab Content
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildSavingsList(_activeSavings, true),
                        _buildSavingsList(_closedSavings, false),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Bottom Nav
          BottomNavBar(
            isHome: false,
            memberName: '',
            allSummary: widget.allSummary,
          ),
        ],
      ),
    );
  }

  Widget _buildSavingsList(List<UserSaving> savings, bool isActive) {
    if (savings.isEmpty) {
      return Center(child: Text('No ${isActive ? 'active' : 'closed'} savings accounts'));
    }
    return ListView.builder(
      padding: const EdgeInsets.only(top: 20, bottom: 100),
      itemCount: savings.length,
      itemBuilder: (context, index) {
        return _buildSavingsCard(context, savings[index], index, isTappable: isActive);
      },
    );
  }

  Widget _buildSavingsCard(BuildContext context, UserSaving saving, int index, {required bool isTappable}) {
    final color = saving.isOpen ? const Color(0xFF023373) : const Color(0xFF9B9B9B);
    final initials = (saving.productName?.isNotEmpty == true)
        ? saving.productName!.substring(0, 2).toUpperCase()
        : 'SA';

    return GestureDetector(
      onTap: isTappable
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SavingsDetailsScreen(
                    savingsId: saving.savingsId,
                    productName: saving.productName ?? 'Savings Account',
                  ),
                ),
              );
            }
          : null,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        height: 150,
        decoration: ShapeDecoration(
          color: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          shadows: const [
            BoxShadow(
                color: Color(0x19000000), blurRadius: 4, offset: Offset(0, 4))
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              left: 20,
              top: 13,
              child: Container(
                width: 44,
                height: 44,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Center(
                  child: Text(initials,
                      style: const TextStyle(
                          color: Color(0xFF0080C6), fontSize: 24, fontWeight: FontWeight.w700)),
                ),
              ),
            ),
            Positioned(
              left: 82,
              top: 17,
              child: Text(saving.productName ?? 'Savings', style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
            ),
            Positioned(
              right: 20,
              top: 17,
              child: Text('#${saving.code}', style: const TextStyle(color: Colors.white, fontSize: 12)),
            ),
            // Savings details rows
            _buildDetailRow('Opening Date', saving.openingDate, 58),
            if (!saving.isOpen)
              _buildDetailRow('Closing Date', saving.closingDate ?? 'N/A', 83),
            if (saving.isOpen)
              _buildDetailRow('Total Savings Amount', '${saving.netSavingAmount.toStringAsFixed(0)} BDT', 83),
            if (!saving.isOpen)
              _buildDetailRow('Total Deposit', '${saving.totalDeposit.toStringAsFixed(0)} BDT', 108),
            if (!saving.isOpen)
              _buildDetailRow('Total Withdraw', '${saving.totalWithdraw.toStringAsFixed(0)} BDT', 133),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value, double top) {
    return Positioned(
      left: 81,
      top: top,
      right: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                    color: title == 'Opening Date' || title == 'Closing Date'
                        ? const Color(0xFF0080C6)
                        : const Color(0xFFFF9900),
                    shape: BoxShape.circle),
              ),
              const SizedBox(width: 15),
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 12)),
            ],
          ),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildPortfolioTab(String title, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: ShapeDecoration(
          color: isActive ? const Color(0xFF0442BF) : Colors.transparent,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              color: isActive ? Colors.transparent : const Color(0xFF0442BF),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.white : const Color(0xFF0442BF),
            fontSize: 14,
            fontWeight: FontWeight.w700,
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
