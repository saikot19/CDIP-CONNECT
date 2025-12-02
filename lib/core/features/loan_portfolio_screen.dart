import 'package:cdip_connect/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import '../models/login_response_model.dart';
import '../services/auth_service.dart';
import 'savings_portfolio_screen.dart';
import 'loan_details.dart';

class LoanPortfolioScreen extends StatefulWidget {
  final AllSummary allSummary;

  const LoanPortfolioScreen({super.key, required this.allSummary});

  @override
  State<LoanPortfolioScreen> createState() => _LoanPortfolioScreenState();
}

class _LoanPortfolioScreenState extends State<LoanPortfolioScreen> {
  bool showLoan = true;

  void switchToSavings() {
    setState(() {
      showLoan = false;
    });
    Future.delayed(const Duration(milliseconds: 350), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              SavingsPortfolioScreen(allSummary: widget.allSummary),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final loans = widget.allSummary.loans;

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(color: Colors.white),
        child: Stack(
          children: [
            // Header background
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                width: screenWidth,
                height: screenHeight * 0.15,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 36, 81, 165),
                ),
              ),
            ),
            // Decorative image
            Positioned(
              left: screenWidth,
              top: screenHeight * 0.18,
              child: Container(
                transform: Matrix4.identity()
                  ..translate(0.0, 0.0)
                  ..rotateZ(-3.14),
                width: screenWidth,
                height: screenHeight * 0.35,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage("https://placehold.co/432x288"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            // Title
            Positioned(
              left: screenWidth * 0.18,
              top: screenHeight * 0.065,
              child: Text(
                'Loan Portfolio',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenWidth * 0.06,
                  fontFamily: 'Proxima Nova',
                  fontWeight: FontWeight.w500,
                  height: 1.42,
                ),
              ),
            ),
            // Back button placeholder
            Positioned(
              left: screenWidth * 0.05,
              top: screenHeight * 0.06,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: screenWidth * 0.1,
                  height: screenWidth * 0.1,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: screenWidth * 0.06,
                  ),
                ),
              ),
            ),
            // Content area
            Positioned(
              left: screenWidth * 0.05,
              top: screenHeight * 0.18,
              child: Container(
                width: screenWidth * 0.9,
                height: screenHeight * 0.68,
                child: Stack(
                  children: [
                    // Loan list
                    loans.isEmpty
                        ? Center(
                            child: Text(
                              'No active loans',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: screenWidth * 0.04,
                              ),
                            ),
                          )
                        : _LoanPortfolioContent(
                            loans: loans,
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                          ),
                    // Tab switcher
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.02,
                                  vertical: screenHeight * 0.004),
                              child: Text(
                                'Loan Portfolio',
                                style: TextStyle(
                                  color: const Color(0xFF0880C6),
                                  fontSize: screenWidth * 0.03,
                                  fontFamily: 'Proxima Nova',
                                  fontWeight: FontWeight.w600,
                                  height: 1.67,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (showLoan) {
                                switchToSavings();
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.02,
                                  vertical: screenHeight * 0.004),
                              child: Text(
                                'Savings Portfolio',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: screenWidth * 0.03,
                                  fontFamily: 'Proxima Nova',
                                  fontWeight: FontWeight.w400,
                                  height: 1.67,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Tab underline
                    Positioned(
                      left: 0,
                      top: screenHeight * 0.035,
                      child: Container(
                        width: screenWidth * 0.25,
                        height: 2,
                        decoration: const BoxDecoration(
                          color: Color(0xFF0880C6),
                        ),
                      ),
                    ),
                    // Divider
                    Positioned(
                      left: 0,
                      top: screenHeight * 0.038,
                      child: Opacity(
                        opacity: 0.30,
                        child: Container(
                          width: screenWidth * 0.9,
                          height: 1,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Bottom Navigation Bar
            Positioned(
              left: 0,
              bottom: 0,
              child: BottomNavBar(
                isHome: false,
                memberName: '',
                allSummary: widget.allSummary,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: null,
    );
  }
}

class _LoanPortfolioContent extends StatelessWidget {
  final List<UserLoan> loans;
  final double screenWidth;
  final double screenHeight;

  const _LoanPortfolioContent({
    required this.loans,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    final cardHeight = screenHeight * 0.22;
    final horizontalPadding = screenWidth * 0.02;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(top: screenHeight * 0.05),
        child: Column(
          children: List.generate(loans.length, (index) {
            final loan = loans[index];

            return Padding(
              padding: EdgeInsets.only(bottom: screenHeight * 0.025),
              child: GestureDetector(
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
                  width: screenWidth * 0.9,
                  height: cardHeight,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Header background
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Opacity(
                          opacity: 0.10,
                          child: Container(
                            width: screenWidth * 0.9,
                            height: cardHeight * 0.35,
                            decoration: ShapeDecoration(
                              color: const Color(0xFF0080C6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Loan Product Label
                      Positioned(
                        left: horizontalPadding,
                        top: cardHeight * 0.09,
                        child: Text(
                          'Loan Product',
                          style: TextStyle(
                            color: const Color(0xFF21409A),
                            fontSize: screenWidth * 0.035,
                            fontFamily: 'Proxima Nova',
                            fontWeight: FontWeight.w700,
                            height: 1,
                          ),
                        ),
                      ),
                      // Loan Product Name
                      Positioned(
                        left: horizontalPadding,
                        top: cardHeight * 0.17,
                        child: SizedBox(
                          width: screenWidth * 0.5,
                          child: Text(
                            loan.loanProductName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: screenWidth * 0.03,
                              fontFamily: 'Proxima Nova',
                              fontWeight: FontWeight.w700,
                              height: 1.67,
                            ),
                          ),
                        ),
                      ),
                      // Outstanding Label (Right side)
                      Positioned(
                        right: horizontalPadding,
                        top: cardHeight * 0.09,
                        child: Text(
                          'Outstanding',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: const Color(0xFF0080C6),
                            fontSize: screenWidth * 0.035,
                            fontFamily: 'Proxima Nova',
                            fontWeight: FontWeight.w700,
                            height: 1,
                          ),
                        ),
                      ),
                      // Outstanding Amount
                      Positioned(
                        right: horizontalPadding,
                        top: cardHeight * 0.18,
                        child: SizedBox(
                          width: screenWidth * 0.35,
                          child: Text(
                            '${loan.outstandingAmount.toStringAsFixed(0)} BDT',
                            textAlign: TextAlign.right,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: screenWidth * 0.03,
                              fontFamily: 'Proxima Nova',
                              fontWeight: FontWeight.w700,
                              height: 1.17,
                            ),
                          ),
                        ),
                      ),
                      // Divider
                      Positioned(
                        left: horizontalPadding,
                        top: cardHeight * 0.43,
                        right: horizontalPadding,
                        child: Container(
                          height: 1,
                          color: Colors.black.withOpacity(0.1),
                        ),
                      ),
                      // Disbursement Date Label
                      Positioned(
                        left: horizontalPadding,
                        top: cardHeight * 0.51,
                        child: Opacity(
                          opacity: 0.50,
                          child: Text(
                            'Disburse Date',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: screenWidth * 0.025,
                              fontFamily: 'Proxima Nova',
                              fontWeight: FontWeight.w400,
                              height: 1,
                            ),
                          ),
                        ),
                      ),
                      // Disbursement Date
                      Positioned(
                        left: horizontalPadding,
                        top: cardHeight * 0.60,
                        child: SizedBox(
                          width: screenWidth * 0.4,
                          child: Text(
                            loan.disburseDate,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: const Color(0xFF21409A),
                              fontSize: screenWidth * 0.035,
                              fontFamily: 'Proxima Nova',
                              fontWeight: FontWeight.w400,
                              height: 1,
                            ),
                          ),
                        ),
                      ),
                      // Recovered Label
                      Positioned(
                        left: horizontalPadding,
                        top: cardHeight * 0.70,
                        child: Opacity(
                          opacity: 0.50,
                          child: Text(
                            'Recovered',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: screenWidth * 0.025,
                              fontFamily: 'Proxima Nova',
                              fontWeight: FontWeight.w400,
                              height: 1,
                            ),
                          ),
                        ),
                      ),
                      // Recovered Amount
                      Positioned(
                        left: horizontalPadding,
                        top: cardHeight * 0.79,
                        child: SizedBox(
                          width: screenWidth * 0.35,
                          child: Text(
                            '${loan.totalRecoveredAmount.toStringAsFixed(0)} BDT',
                            textAlign: TextAlign.left,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: const Color(0xFF21409A),
                              fontSize: screenWidth * 0.035,
                              fontFamily: 'Proxima Nova',
                              fontWeight: FontWeight.w400,
                              height: 1,
                            ),
                          ),
                        ),
                      ),
                      // Overdue Label
                      Positioned(
                        right: horizontalPadding,
                        top: cardHeight * 0.70,
                        child: Opacity(
                          opacity: 0.50,
                          child: Text(
                            'Overdue',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: screenWidth * 0.025,
                              fontFamily: 'Proxima Nova',
                              fontWeight: FontWeight.w400,
                              height: 1,
                            ),
                          ),
                        ),
                      ),
                      // Overdue Amount
                      Positioned(
                        right: horizontalPadding,
                        top: cardHeight * 0.79,
                        child: SizedBox(
                          width: screenWidth * 0.35,
                          child: Text(
                            '0 BDT',
                            textAlign: TextAlign.right,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: const Color(0xFFFF0000),
                              fontSize: screenWidth * 0.035,
                              fontFamily: 'Proxima Nova',
                              fontWeight: FontWeight.w400,
                              height: 1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
