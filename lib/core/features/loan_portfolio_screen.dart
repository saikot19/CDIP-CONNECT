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

class _LoanPortfolioScreenState extends State<LoanPortfolioScreen> {
  // Logic to switch screens matches the Figma "Tabs"
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
    final loans = widget.allSummary.loans;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: Stack(
        children: [
          // --- Header Section ---
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
          // Screen Title
          Positioned(
            left: 73,
            top: 61,
            child: const Text(
              'Loan Portfolio',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontFamily: 'Proxima Nova',
                fontWeight: FontWeight.w500,
                height: 1.42,
              ),
            ),
          ),
          // Back Button
          Positioned(
            left: 20,
            top: 58,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          // Transactions Last Updated Bar
          Positioned(
            left: 0,
            top: 116,
            child: Container(
              width: screenWidth,
              height: 23,
              color: const Color(0xFF05A300),
            ),
          ),
          Positioned(
            left: 76,
            top: 121,
            child: Text(
              'Transactions Last Updated on ${DateFormat('d MMM y').format(DateTime.now())}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: 'Proxima Nova',
                fontWeight: FontWeight.w400,
                height: 1,
              ),
            ),
          ),

          // --- Main Content Area ---
          Positioned(
            left: 0,
            top: 139,
            bottom: 0, // Extend to bottom
            child: Container(
              width: screenWidth,
              // No fixed height, let it fill
              child: Stack(
                children: [
                  // White Background for Content
                  Positioned.fill(
                    top: 20, // Offset for tabs background
                    child: Container(
                      color: const Color(0xFFF6F6F6),
                    ),
                  ),
                  // Tab Background (Gray strip behind tabs)
                  Positioned(
                    left: 0,
                    top: 0,
                    child: Container(
                      width: screenWidth,
                      height: 96,
                      color: const Color(0xFFF5F3F3),
                    ),
                  ),

                  // Tab 1: Loan Portfolio (Active)
                  Positioned(
                    left: 20,
                    top: 13,
                    child: Container(
                      width: 145,
                      height: 46,
                      decoration: ShapeDecoration(
                        color: const Color(0xFF0442BF),
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
                      child: Center(
                        child: Text(
                          'Loan Portfolio',
                          style: const TextStyle(
                            color: Color(0xFFF5F3F3),
                            fontSize: 14,
                            fontFamily: 'Proxima Nova',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Tab 2: Savings Portfolio (Inactive)
                  Positioned(
                    left: 183,
                    top: 13,
                    child: GestureDetector(
                      onTap: switchToSavings,
                      child: Container(
                        width: 157,
                        height: 46,
                        decoration: ShapeDecoration(
                          color: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              width: 1,
                              color: Color(0xFF0442BF),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Savings Portfolio',
                            style: const TextStyle(
                              color: Color(0xFF0442BF),
                              fontSize: 14,
                              fontFamily: 'Proxima Nova',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // White Content Container (The rounded box)
                  Positioned.fill(
                    top: 73, // Below tabs
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(
                              0), // Figma shows flat here inside the stack
                        ),
                      ),
                      child: Column(
                        children: [
                          // "Active Loan" / "Closed Loan" Header
                          Padding(
                            padding: const EdgeInsets.fromLTRB(29, 20, 29, 10),
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    const Text(
                                      'Active Loan',
                                      style: TextStyle(
                                        color: Color(0xFF0880C6),
                                        fontSize: 12,
                                        fontFamily: 'Proxima Nova',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      width: 81,
                                      height: 2,
                                      color: const Color(0xFF0880C6),
                                    )
                                  ],
                                ),
                                const SizedBox(width: 38),
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 10),
                                  child: Opacity(
                                    opacity: 0.50,
                                    child: Text(
                                      'Closed Loan',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontFamily: 'Proxima Nova',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(height: 1, color: Color(0xFFEEEEEE)),

                          // List of Loans
                          Expanded(
                            child: loans.isEmpty
                                ? const Center(child: Text('No active loans'))
                                : ListView.builder(
                                    padding: const EdgeInsets.only(
                                        top: 20,
                                        bottom: 100), // Space for bottom nav
                                    itemCount: loans.length,
                                    itemBuilder: (context, index) {
                                      return _buildLoanCard(
                                          context, loans[index], index);
                                    },
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Navigation Bar
          BottomNavBar(
            isHome: false,
            memberName: '',
            allSummary: widget.allSummary,
          ),
        ],
      ),
    );
  }

  Widget _buildLoanCard(BuildContext context, UserLoan loan, int index) {
    // Colors from Figma design cycling
    final List<Color> cardColors = [
      const Color(0xFF023373), // Dark Blue
      const Color(0xFF0468BF), // Light Blue
      const Color(0xFFF03240), // Red
    ];
    final color = cardColors[index % cardColors.length];

    // First letter of product name for icon
    final letter = loan.loanProductName.isNotEmpty
        ? loan.loanProductName[0].toUpperCase()
        : 'L';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoanDetailsScreen(
              loanId: loan.loanId,
              productName: loan.loanProductName,
            ),
          ),
        );
      },
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
              color: Color(0x19000000),
              blurRadius: 4,
              offset: Offset(0, 4),
            )
          ],
        ),
        child: Stack(
          children: [
            // Icon Background (White Box)
            Positioned(
              left: 20,
              top: 13,
              child: Container(
                width: 44,
                height: 44,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Center(
                  child: Text(
                    letter,
                    style: TextStyle(
                      color: const Color(0xFF0080C6),
                      fontSize: 26,
                      fontFamily: 'Proxima Nova',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),

            // Loan Product Name
            Positioned(
              left: 82, // 40 + 20 + padding
              top: 17,
              child: Text(
                loan.loanProductName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: 'Proxima Nova',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            // Loan ID
            Positioned(
              left: 225, // Adjusted to fit
              top: 17,
              child: SizedBox(
                width: 120, // Limit width to avoid overflow
                child: Text(
                  '#${loan.customizedLoanNo}',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontFamily: 'Proxima Nova',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            // --- Row 1 Info (Disbursement Date & Outstanding) ---

            // Disbursement Date
            Positioned(
              left: 266, // Figma: 286 (Right side)
              top: 58,
              right: 20,
              child: Text(
                loan.disburseDate,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: 'Proxima Nova',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Positioned(
              left: 106,
              top: 63,
              child: const Text(
                'Disbursement Date',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontFamily: 'Proxima Nova',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Positioned(
              left: 81,
              top: 63,
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: Color(0xFF0080C6), // Dot Color? Figma used specific per row?
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // Outstanding Amount (Figma puts it below Date? Or swapped? 
            // Figma: Row 1 Date, Row 2 Outstanding, Row 3 Overdue)
            
            // Row 2: Outstanding
            Positioned(
              left: 200, 
              right: 20,
              top: 83,
              child: Text(
                '${loan.outstandingAmount.toStringAsFixed(0)} BDT',
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: 'Proxima Nova',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
             Positioned(
              left: 106,
              top: 88,
              child: const Text(
                'Outstanding Amount',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontFamily: 'Proxima Nova',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Positioned(
              left: 81,
              top: 88,
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: Color(0xFFFF9900), // Orange dot for outstanding
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // Row 3: Overdue Amount
            Positioned(
              left: 200,
              right: 20,
              top: 108,
              child: Text(
                '${loan.overdueAmount.toStringAsFixed(0)} BDT',
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: 'Proxima Nova',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
             Positioned(
              left: 106,
              top: 113,
              child: const Text(
                'Overdue Amount',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontFamily: 'Proxima Nova',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Positioned(
              left: 81,
              top: 113,
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: Color(0xFFFF0000), // Red dot for overdue
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
