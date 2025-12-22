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

class _SavingsPortfolioScreenState extends State<SavingsPortfolioScreen> {
  String _lastUpdated = '';

  @override
  void initState() {
    super.initState();
    _loadLastUpdated();
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
          _lastUpdated = lastUpdated; // fallback to raw string if parsing fails
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
    final savings = widget.allSummary.savings;

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
              'Savings Portfolio',
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
              'Transactions Last Updated on $_lastUpdated',
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
            bottom: 0,
            child: Container(
              width: screenWidth,
              child: Stack(
                children: [
                  // White Background for Content
                  Positioned.fill(
                    top: 20,
                    child: Container(
                      color: const Color(0xFFF6F6F6),
                    ),
                  ),
                  // Tab Background
                  Positioned(
                    left: 0,
                    top: 0,
                    child: Container(
                      width: screenWidth,
                      height: 96,
                      color: const Color(0xFFF5F3F3),
                    ),
                  ),

                  // Tab 1: Loan Portfolio (Inactive)
                  Positioned(
                    left: 20,
                    top: 13,
                    child: GestureDetector(
                      onTap: switchToLoan,
                      child: Container(
                        width: 145,
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
                            'Loan Portfolio',
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

                  // Tab 2: Savings Portfolio (Active)
                  Positioned(
                    left: 183,
                    top: 13,
                    child: Container(
                      width: 157,
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
                          'Savings Portfolio',
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

                  // White Content Container
                  Positioned.fill(
                    top: 73,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(0),
                        ),
                      ),
                      child: Column(
                        children: [
                          // "Active Savings" / "Closed Savings" Header
                          Padding(
                            padding: const EdgeInsets.fromLTRB(29, 20, 29, 10),
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    const Text(
                                      'Active Savings',
                                      style: TextStyle(
                                        color: Color(0xFF0880C6),
                                        fontSize: 12,
                                        fontFamily: 'Proxima Nova',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      width: 91,
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
                                      'Closed Savings',
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

                          // List of Savings
                          Expanded(
                            child: savings.isEmpty
                                ? const Center(
                                    child: Text('No savings accounts'))
                                : ListView.builder(
                                    padding: const EdgeInsets.only(
                                        top: 20, bottom: 100),
                                    itemCount: savings.length,
                                    itemBuilder: (context, index) {
                                      return _buildSavingsCard(
                                          context, savings[index], index);
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

  Widget _buildSavingsCard(BuildContext context, UserSaving saving, int index) {
    // Alternating colors for savings cards
    final List<Color> cardColors = [
      const Color(0xFF023373), // Dark Blue
      const Color(0xFF0468BF), // Light Blue
    ];
    final color = cardColors[index % cardColors.length];

    // Initials logic: "Compulsory Savings" -> "CS"
    String initials = 'SA';
    final productName = saving.productName ?? saving.code;
    if (productName.isNotEmpty) {
      final parts = productName.trim().split(' ');
      if (parts.length >= 2) {
        initials = '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      } else {
        initials = productName.substring(0, 1).toUpperCase();
        if (productName.length > 1) {
          initials += productName.substring(1, 2).toUpperCase();
        }
      }
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SavingsDetailsScreen(
              savingsId: saving.savingsId,
              productName: saving.productName ?? 'Savings Account',
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
            // Icon Background
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
                    initials,
                    style: TextStyle(
                      color: const Color(0xFF0080C6),
                      fontSize: 24,
                      fontFamily: 'Proxima Nova',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),

            // Product Name
            Positioned(
              left: 82,
              top: 17,
              child: SizedBox(
                width: 140,
                child: Text(
                  productName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'Proxima Nova',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),

            // ID
            Positioned(
              left: 240,
              top: 17,
              child: SizedBox(
                width: 120,
                child: Text(
                  '#${saving.code}',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontFamily: 'Proxima Nova',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),

            // --- Data Rows ---

            // Opening Date
            Positioned(
              left: 266,
              top: 58,
              right: 20,
              child: Text(
                saving.openingDate,
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
                'Opening Date',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontFamily: 'Proxima Nova',
                  fontWeight: FontWeight.w400,
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
                  color: Color(0xFF0080C6),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // Total Savings Amount
            Positioned(
              left: 200,
              right: 20,
              top: 83,
              child: Text(
                '${saving.netSavingAmount.toStringAsFixed(0)} BDT',
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
                'Total Savings Amount',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontFamily: 'Proxima Nova',
                  fontWeight: FontWeight.w400,
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
                  color: Color(0xFFFF9900), // Orange dot
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
