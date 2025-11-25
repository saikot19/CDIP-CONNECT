import 'package:cdip_connect/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import 'savings_portfolio_screen.dart';
import 'loan_details.dart';

class LoanPortfolioScreen extends StatefulWidget {
  const LoanPortfolioScreen({super.key});

  @override
  State<LoanPortfolioScreen> createState() => _LoanPortfolioScreenState();
}

class _LoanPortfolioScreenState extends State<LoanPortfolioScreen> {
  bool showLoan = true;
  late Future<List<Map<String, dynamic>>> _loanProductsFuture;

  @override
  void initState() {
    super.initState();
    _loadLoanData();
  }

  void _loadLoanData() {
    _loanProductsFuture = _getLoanProductsWithTransactions();
  }

  Future<List<Map<String, dynamic>>> _getLoanProductsWithTransactions() async {
    final db = DatabaseHelper();
    final products = await db.getLoanProducts();
    final transactions = await db.getLoanTransactions();

    return List.generate(products.length, (index) {
      return {
        'product': products[index],
        'transactions': transactions,
      };
    });
  }

  void switchToSavings() {
    setState(() {
      showLoan = false;
    });
    Future.delayed(const Duration(milliseconds: 350), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SavingsPortfolioScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
              child: Container(
                width: screenWidth * 0.1,
                height: screenWidth * 0.1,
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(),
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
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: _loanProductsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(
                            child: Text('No loan data available'),
                          );
                        }

                        final loanData = snapshot.data!;
                        return _LoanPortfolioContent(
                          loanData: loanData,
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                        );
                      },
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
              child: Container(
                width: screenWidth,
                height: screenHeight * 0.1,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(18),
                      topRight: Radius.circular(18),
                    ),
                  ),
                  shadows: [
                    BoxShadow(
                      color: Color(0x3F000000),
                      blurRadius: 15,
                      offset: Offset(0, 4),
                      spreadRadius: 0,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}

class _LoanPortfolioContent extends StatelessWidget {
  final List<Map<String, dynamic>> loanData;
  final double screenWidth;
  final double screenHeight;

  const _LoanPortfolioContent({
    required this.loanData,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    // Only show first 3 loan products
    final displayData = loanData.take(3).toList();
    final cardHeight = screenHeight * 0.22;
    final horizontalPadding = screenWidth * 0.02;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(top: screenHeight * 0.05),
        child: Column(
          children: List.generate(displayData.length, (index) {
            final product = displayData[index]['product'];
            final transactions = displayData[index]['transactions'];

            return Padding(
              padding: EdgeInsets.only(bottom: screenHeight * 0.025),
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => DraggableScrollableSheet(
                      initialChildSize: 0.7,
                      minChildSize: 0.5,
                      maxChildSize: 0.95,
                      expand: false,
                      builder: (context, scrollController) => LoanDetailsScreen(
                        scrollController: scrollController,
                        transactions: transactions,
                        productName: product.name,
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
                  child: Column(
                    children: [
                      // Blue top portion (shows Loan Product, Name, Outstanding)
                      Container(
                        height: cardHeight * 0.42,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Color(0xFF0080C6),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: horizontalPadding,
                              vertical: cardHeight * 0.08),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Left side: labels and product name
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Loan Product',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.9),
                                        fontSize: screenWidth * 0.032,
                                        fontFamily: 'Proxima Nova',
                                        fontWeight: FontWeight.w600,
                                        height: 1,
                                      ),
                                    ),
                                    SizedBox(height: cardHeight * 0.03),
                                    Text(
                                      product.name,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: screenWidth * 0.035,
                                        fontFamily: 'Proxima Nova',
                                        fontWeight: FontWeight.w700,
                                        height: 1.15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Right side: Outstanding label & amount
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Outstanding',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.95),
                                      fontSize: screenWidth * 0.03,
                                      fontFamily: 'Proxima Nova',
                                      fontWeight: FontWeight.w700,
                                      height: 1,
                                    ),
                                  ),
                                  SizedBox(height: cardHeight * 0.03),
                                  SizedBox(
                                    width: screenWidth * 0.32,
                                    child: Text(
                                      transactions.isNotEmpty
                                          ? '${transactions.last.outstanding} BDT'
                                          : '0 BDT',
                                      textAlign: TextAlign.right,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: screenWidth * 0.035,
                                        fontFamily: 'Proxima Nova',
                                        fontWeight: FontWeight.w700,
                                        height: 1.15,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      // White bottom portion (divider, Disbursement Date, Recovered)
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: horizontalPadding,
                                vertical: cardHeight * 0.05),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Divider
                                Container(
                                  height: 1,
                                  color: Colors.black.withOpacity(0.06),
                                ),
                                SizedBox(height: cardHeight * 0.04),
                                Row(
                                  children: [
                                    // Left: Disbursement Date
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Opacity(
                                            opacity: 0.5,
                                            child: Text(
                                              'Disbursement Date',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: screenWidth * 0.025,
                                                fontFamily: 'Proxima Nova',
                                                fontWeight: FontWeight.w400,
                                                height: 1,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: cardHeight * 0.02),
                                          Text(
                                            transactions.isNotEmpty
                                                ? transactions
                                                    .first.transactionDate
                                                : 'N/A',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: const Color(0xFF21409A),
                                              fontSize: screenWidth * 0.033,
                                              fontFamily: 'Proxima Nova',
                                              fontWeight: FontWeight.w500,
                                              height: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Right: Recovered
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Opacity(
                                            opacity: 0.5,
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
                                          SizedBox(height: cardHeight * 0.02),
                                          Text(
                                            transactions.isNotEmpty
                                                ? '${transactions.fold(0, (sum, t) => sum + (double.tryParse(t.amount) ?? 0)).toStringAsFixed(0)} BDT'
                                                : '0 BDT',
                                            textAlign: TextAlign.right,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: const Color(0xFF05A300),
                                              fontSize: screenWidth * 0.033,
                                              fontFamily: 'Proxima Nova',
                                              fontWeight: FontWeight.w500,
                                              height: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
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
