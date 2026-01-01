import 'package:cdip_connect/core/services/shared_preference_service.dart';
import 'package:cdip_connect/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/login_response_model.dart';
import 'savings_portfolio_screen.dart';
import 'loan_details.dart';

class LoanPortfolioScreen extends StatefulWidget {
  final AllSummary allSummary;

  const LoanPortfolioScreen({super.key, required this.allSummary});

  @override
  State<LoanPortfolioScreen> createState() => _LoanPortfolioScreenState();
}

class _LoanPortfolioScreenState extends State<LoanPortfolioScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _lastUpdated = '';

  final List<UserLoan> _activeLoans = [];
  final List<UserLoan> _closedLoans = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadLastUpdated();
    _filterLoans();
  }

  void _filterLoans() {
    for (var loan in widget.allSummary.loans) {
      if (loan.isOpen) {
        _activeLoans.add(loan);
      } else {
        _closedLoans.add(loan);
      }
    }
    // Sort closed loans by disbursement date, most recent first
    _closedLoans.sort((a, b) => b.disburseDate.compareTo(a.disburseDate));
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

  void switchToSavings() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            SavingsPortfolioScreen(allSummary: widget.allSummary),
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
                  'Loan Portfolio',
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
                      _buildPortfolioTab('Loan Portfolio', true, () {}),
                      const SizedBox(width: 18),
                      _buildPortfolioTab('Savings Portfolio', false, switchToSavings),
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
                      Tab(text: 'Active Loan'),
                      Tab(text: 'Closed Loan'),
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
                        _buildLoanList(_activeLoans, true),
                        _buildLoanList(_closedLoans, false),
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

  Widget _buildLoanList(List<UserLoan> loans, bool isActive) {
    if (loans.isEmpty) {
      return Center(child: Text('No ${isActive ? 'active' : 'closed'} loans'));
    }
    return ListView.builder(
      padding: const EdgeInsets.only(top: 20, bottom: 100),
      itemCount: loans.length,
      itemBuilder: (context, index) {
        bool isMostRecentClosed = !isActive && index == 0;
        return _buildLoanCard(context, loans[index], index,
            isTappable: isActive || isMostRecentClosed);
      },
    );
  }

  Widget _buildLoanCard(BuildContext context, UserLoan loan, int index, {required bool isTappable}) {
    final color = loan.isOpen ? const Color(0xFF023373) : const Color(0xFF9B9B9B);
    final letter = loan.loanProductName.isNotEmpty
        ? loan.loanProductName[0].toUpperCase()
        : 'L';

    return GestureDetector(
      onTap: isTappable
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoanDetailsScreen(
                    loanId: loan.loanId,
                    productName: loan.loanProductName,
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
                  child: Text(letter,
                      style: const TextStyle(
                          color: Color(0xFF0080C6), fontSize: 26, fontWeight: FontWeight.w700)),
                ),
              ),
            ),
            Positioned(
              left: 82,
              top: 17,
              child: Text(loan.loanProductName, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
            ),
            Positioned(
              right: 20,
              top: 17,
              child: Text('#${loan.customizedLoanNo}', style: const TextStyle(color: Colors.white, fontSize: 12)),
            ),
            // Loan details rows
            _buildDetailRow('Disbursement Date', loan.disburseDate, 58, false),
            _buildDetailRow('Outstanding Amount', '${loan.outstandingAmount.toStringAsFixed(0)} BDT', 83, false),
            _buildDetailRow('Overdue Amount', '${loan.overdueAmount.toStringAsFixed(0)} BDT', 108, loan.isOverdue),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value, double top, bool isOverdue) {
    final valueColor = (title == 'Overdue Amount' && isOverdue) ? Colors.red : Colors.white;

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
                    color: title == 'Disbursement Date'
                        ? const Color(0xFF0080C6)
                        : title == 'Outstanding Amount'
                            ? const Color(0xFFFF9900)
                            : (title == 'Overdue Amount' && isOverdue) ? Colors.red : const Color(0xFFFF0000),
                    shape: BoxShape.circle),
              ),
              const SizedBox(width: 15),
              Text(title, style: TextStyle(color: valueColor, fontSize: 12)),
            ],
          ),
          Text(value, style: TextStyle(color: valueColor, fontSize: 14, fontWeight: FontWeight.w600)),
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
