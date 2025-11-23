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

    // Group transactions into products (assuming same product for all in this case)
    return [
      {'productName': 'Savings Product 1', 'transactions': transactions},
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 412,
        height: 917,
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(color: Colors.white),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                width: 412,
                height: 116,
                decoration:
                    const BoxDecoration(color: Color.fromARGB(255, 2, 33, 90)),
              ),
            ),
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
            Positioned(
              left: 20,
              top: 58,
              child: Container(
                width: 40,
                height: 40,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(),
                child: Stack(),
              ),
            ),
            Positioned(
              left: 20,
              top: 141,
              child: Container(
                width: 372,
                height: 776,
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
                        );
                      },
                    ),
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4),
                              child: Text(
                                'Loan Portfolio',
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
                          GestureDetector(
                            onTap: () {},
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4),
                              child: Text(
                                'Savings Portfolio',
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
                        ],
                      ),
                    ),
                    Positioned(
                      left: 114,
                      top: 26,
                      child: Container(
                        width: 91,
                        height: 2,
                        decoration:
                            BoxDecoration(color: const Color(0xFF0880C6)),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      top: 28,
                      child: Opacity(
                        opacity: 0.30,
                        child: Container(
                          width: 372,
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 0.20,
                                strokeAlign: BorderSide.strokeAlignCenter,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
            const BottomNavBar(),
          ],
        ),
      ),
    );
  }
}

class _SavingsPortfolioContent extends StatelessWidget {
  final List<Map<String, dynamic>> savingsData;

  const _SavingsPortfolioContent({required this.savingsData});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Column(
          children: List.generate(savingsData.length, (index) {
            final productName = savingsData[index]['productName'];
            final transactions = savingsData[index]['transactions'];

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
                  width: 372,
                  height: 126,
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
                            height: 46,
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
                      Positioned(
                        left: 13,
                        top: 51,
                        child: Text(
                          'Savings Product',
                          style: TextStyle(
                            color: const Color(0xFF21409A),
                            fontSize: 14,
                            fontFamily: 'Proxima Nova',
                            fontWeight: FontWeight.w700,
                            height: 1,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 13,
                        top: 67,
                        child: Text(
                          productName,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: 'Proxima Nova',
                            fontWeight: FontWeight.w700,
                            height: 1.25,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 290,
                        top: 51,
                        child: Opacity(
                          opacity: 0.50,
                          child: Text(
                            'Opening Date',
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
                        left: 281,
                        top: 67,
                        child: Text(
                          transactions.isNotEmpty
                              ? transactions.first.transactionDate
                              : 'N/A',
                          style: TextStyle(
                            color: const Color(0xFF3A3A3A),
                            fontSize: 14,
                            fontFamily: 'Proxima Nova',
                            fontWeight: FontWeight.w400,
                            height: 1,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 13,
                        top: 105,
                        child: Opacity(
                          opacity: 0.50,
                          child: Text(
                            'Total Savings Amount',
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
                        top: 119,
                        child: Text(
                          transactions.isNotEmpty
                              ? '${transactions.last.outstanding} BDT'
                              : '0 BDT',
                          style: TextStyle(
                            color: const Color(0xFF21409A),
                            fontSize: 14,
                            fontFamily: 'Proxima Nova',
                            fontWeight: FontWeight.w600,
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
