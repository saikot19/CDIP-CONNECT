import 'package:cdip_connect/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import 'loan_portfolio_screen.dart';
import 'savings_details.dart';

class SavingsPortfolioScreen extends StatefulWidget {
  const SavingsPortfolioScreen({super.key});

  @override
  State<SavingsPortfolioScreen> createState() => _SavingsPortfolioScreenState();
}

class _SavingsPortfolioScreenState extends State<SavingsPortfolioScreen> {
  late Future<List<Map<String, dynamic>>> _savingsTransactionsFuture;

  @override
  void initState() {
    super.initState();
    _loadSavingsData();
  }

  void _loadSavingsData() {
    _savingsTransactionsFuture = _getSavingsTransactions();
  }

  Future<List<Map<String, dynamic>>> _getSavingsTransactions() async {
    final db = DatabaseHelper();
    final transactions = await db.getSavingTransactions();

    return [
      {'productName': 'Savings Product 1', 'transactions': transactions},
    ];
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
            // Header
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                width: screenWidth,
                height: screenHeight * 0.15,
                decoration:
                    const BoxDecoration(color: Color.fromARGB(255, 2, 33, 90)),
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
                'Savings Portfolio',
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
                      future: _savingsTransactionsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(
                            child: Text('No savings data available'),
                          );
                        }

                        final savingsData = snapshot.data!;
                        return _SavingsPortfolioContent(
                          savingsData: savingsData,
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
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const LoanPortfolioScreen(),
                                ),
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.02,
                                  vertical: screenHeight * 0.004),
                              child: Text(
                                'Loan Portfolio',
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
                          GestureDetector(
                            onTap: () {},
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.02,
                                  vertical: screenHeight * 0.004),
                              child: Text(
                                'Savings Portfolio',
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
                        ],
                      ),
                    ),
                    // Tab underline
                    Positioned(
                      left: screenWidth * 0.28,
                      top: screenHeight * 0.035,
                      child: Container(
                        width: screenWidth * 0.25,
                        height: 2,
                        decoration:
                            BoxDecoration(color: const Color(0xFF0880C6)),
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

class _SavingsPortfolioContent extends StatelessWidget {
  final List<Map<String, dynamic>> savingsData;
  final double screenWidth;
  final double screenHeight;

  const _SavingsPortfolioContent({
    required this.savingsData,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    final cardHeight = screenHeight * 0.18;
    final horizontalPadding = screenWidth * 0.02;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(top: screenHeight * 0.05),
        child: Column(
          children: List.generate(savingsData.length, (index) {
            final productName = savingsData[index]['productName'];
            final transactions = savingsData[index]['transactions'];

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
                      builder: (context, scrollController) =>
                          SavingsDetailsScreen(
                        scrollController: scrollController,
                        transactions: transactions,
                        productName: productName,
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
                            height: cardHeight * 0.40,
                            decoration: ShapeDecoration(
                              color: const Color(0xFF05A300),
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
                      // Savings Product Label
                      Positioned(
                        left: horizontalPadding,
                        top: cardHeight * 0.40,
                        child: Text(
                          'Savings Product',
                          style: TextStyle(
                            color: const Color(0xFF21409A),
                            fontSize: screenWidth * 0.035,
                            fontFamily: 'Proxima Nova',
                            fontWeight: FontWeight.w700,
                            height: 1,
                          ),
                        ),
                      ),
                      // Product Name
                      Positioned(
                        left: horizontalPadding,
                        top: cardHeight * 0.52,
                        child: SizedBox(
                          width: screenWidth * 0.5,
                          child: Text(
                            productName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: screenWidth * 0.03,
                              fontFamily: 'Proxima Nova',
                              fontWeight: FontWeight.w700,
                              height: 1.2,
                            ),
                          ),
                        ),
                      ),
                      // Opening Date Label (Right)
                      Positioned(
                        right: horizontalPadding,
                        top: cardHeight * 0.40,
                        child: Opacity(
                          opacity: 0.50,
                          child: Text(
                            'Opening Date',
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
                      // Opening Date
                      Positioned(
                        right: horizontalPadding,
                        top: cardHeight * 0.52,
                        child: SizedBox(
                          width: screenWidth * 0.35,
                          child: Text(
                            transactions.isNotEmpty
                                ? transactions.first.transactionDate
                                : 'N/A',
                            textAlign: TextAlign.right,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: const Color(0xFF3A3A3A),
                              fontSize: screenWidth * 0.035,
                              fontFamily: 'Proxima Nova',
                              fontWeight: FontWeight.w400,
                              height: 1,
                            ),
                          ),
                        ),
                      ),
                      // Divider
                      Positioned(
                        left: horizontalPadding,
                        top: cardHeight * 0.68,
                        right: horizontalPadding,
                        child: Container(
                          height: 1,
                          color: Colors.black.withOpacity(0.1),
                        ),
                      ),
                      // Total Savings Label
                      Positioned(
                        left: horizontalPadding,
                        top: cardHeight * 0.78,
                        child: Opacity(
                          opacity: 0.50,
                          child: Text(
                            'Total Savings Amount',
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
                      // Total Savings Amount
                      Positioned(
                        left: horizontalPadding,
                        top: cardHeight * 0.90,
                        child: SizedBox(
                          width: screenWidth * 0.5,
                          child: Text(
                            transactions.isNotEmpty
                                ? '${transactions.last.outstanding} BDT'
                                : '0 BDT',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: const Color(0xFF21409A),
                              fontSize: screenWidth * 0.035,
                              fontFamily: 'Proxima Nova',
                              fontWeight: FontWeight.w600,
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
