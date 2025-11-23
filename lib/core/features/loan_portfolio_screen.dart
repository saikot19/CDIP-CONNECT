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
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: 412,
            height: 917,
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(color: Colors.white),
            child: Stack(
              children: [
                // Header background
                Positioned(
                  left: 0,
                  top: 0,
                  child: Container(
                    width: 412,
                    height: 116,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 36, 81, 165),
                    ),
                  ),
                ),
                // Decorative image
                Positioned(
                  left: 422.12,
                  top: 138.13,
                  child: Container(
                    transform: Matrix4.identity()
                      ..translate(0.0, 0.0)
                      ..rotateZ(-3.14),
                    width: 431.66,
                    height: 288.13,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage("https://placehold.co/432x288"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                // Top Bar: Only show which portfolio is active
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
                // Profile/Icon (if needed)
                Positioned(
                  left: 20,
                  top: 58,
                  child: Container(
                    width: 40,
                    height: 40,
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(),
                  ),
                ),
                // Content area with crossfade and tab switcher
                Positioned(
                  left: 20,
                  top: 141,
                  child: Container(
                    width: 372,
                    height: 776,
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
                            );
                          },
                        ),
                        // Responsive tab switcher for Loan Portfolio and Savings Portfolio
                        Positioned(
                          left: 0,
                          top: 0,
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {},
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 4),
                                  child: Text(
                                    'Loan Portfolio',
                                    style: TextStyle(
                                      color: const Color(0xFF0880C6),
                                      fontSize: 12,
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 4),
                                  child: Text(
                                    'Savings Portfolio',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
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
                          top: 26,
                          child: Container(
                            width: 91,
                            height: 2,
                            decoration: const BoxDecoration(
                              color: Color(0xFF0880C6),
                            ),
                          ),
                        ),
                        // Divider
                        Positioned(
                          left: 0,
                          top: 28,
                          child: Opacity(
                            opacity: 0.30,
                            child: Container(
                              width: 372,
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
                  top: 837,
                  child: Container(
                    width: 412,
                    height: 80,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 0,
                          top: 0,
                          child: Container(
                            width: 412,
                            height: 80,
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
                ),
              ],
            ),
          ),
          const BottomNavBar(),
        ],
      ),
    );
  }
}

class _LoanPortfolioContent extends StatelessWidget {
  final List<Map<String, dynamic>> loanData;

  const _LoanPortfolioContent({required this.loanData});

  @override
  Widget build(BuildContext context) {
    // Only show first 3 loan products
    final displayData = loanData.take(3).toList();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Column(
          children: List.generate(displayData.length, (index) {
            final product = displayData[index]['product'];
            final transactions = displayData[index]['transactions'];

            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
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
                  width: 372,
                  height: 173,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Opacity(
                          opacity: 0.10,
                          child: Container(
                            width: 372,
                            height: 60,
                            decoration: const ShapeDecoration(
                              color: Color(0xFF0080C6),
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
                      Positioned(
                        left: 13,
                        top: 57,
                        child: Text(
                          'Loan Product',
                          style: TextStyle(
                            color: Color(0xFF21409A),
                            fontSize: 14,
                            fontFamily: 'Proxima Nova',
                            fontWeight: FontWeight.w700,
                            height: 1,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 13,
                        top: 71,
                        child: Text(
                          product.name,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: 'Proxima Nova',
                            fontWeight: FontWeight.w700,
                            height: 1.67,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 275,
                        top: 57,
                        child: Text(
                          'Outstanding',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Color(0xFF0080C6),
                            fontSize: 14,
                            fontFamily: 'Proxima Nova',
                            fontWeight: FontWeight.w700,
                            height: 1,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 287,
                        top: 73,
                        child: SizedBox(
                          width: 67,
                          height: 17,
                          child: Opacity(
                            opacity: 0.50,
                            child: Text(
                              transactions.isNotEmpty
                                  ? '${transactions.last.outstanding} BDT'
                                  : '0 BDT',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontFamily: 'Proxima Nova',
                                fontWeight: FontWeight.w700,
                                height: 1.67,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 13,
                        top: 117,
                        child: Opacity(
                          opacity: 0.50,
                          child: Text(
                            'Disbursement Date',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontFamily: 'Proxima Nova',
                              fontWeight: FontWeight.w400,
                              height: 1,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 13,
                        top: 131,
                        child: Text(
                          transactions.isNotEmpty
                              ? transactions.first.transactionDate
                              : 'N/A',
                          style: TextStyle(
                            color: Color(0xFF21409A),
                            fontSize: 14,
                            fontFamily: 'Proxima Nova',
                            fontWeight: FontWeight.w400,
                            height: 1,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 255,
                        top: 117,
                        child: Opacity(
                          opacity: 0.50,
                          child: Text(
                            'Recovered',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontFamily: 'Proxima Nova',
                              fontWeight: FontWeight.w400,
                              height: 1,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 278,
                        top: 131,
                        child: Text(
                          transactions.isNotEmpty
                              ? '${transactions.fold(0, (sum, t) => sum + (double.tryParse(t.amount) ?? 0)).toStringAsFixed(0)} BDT'
                              : '0 BDT',
                          style: TextStyle(
                            color: Color(0xFF05A300),
                            fontSize: 14,
                            fontFamily: 'Proxima Nova',
                            fontWeight: FontWeight.w400,
                            height: 1,
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
