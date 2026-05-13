import 'package:flutter/material.dart';

import 'package:cdip_connect/shared/data/local/database_helper.dart';

class LoanDetailsScreen extends StatefulWidget {
  final String loanId;
  final String productName;

  const LoanDetailsScreen({
    Key? key,
    required this.loanId,
    required this.productName,
  }) : super(key: key);

  @override
  State<LoanDetailsScreen> createState() => _LoanDetailsScreenState();
}

class _LoanDetailsScreenState extends State<LoanDetailsScreen> {
  late Future<List<Map<String, dynamic>>> _transactionsFuture;

  @override
  void initState() {
    super.initState();
    _transactionsFuture = _getLoanTransactions();
  }

  Future<List<Map<String, dynamic>>> _getLoanTransactions() async {
    final db = DatabaseHelper();
    return db.getLoanTransactions(loanId: widget.loanId);
  }

  String _stringValue(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }

  double _doubleValue(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Text(
                  widget.productName,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontFamily: 'Proxima Nova',
                    fontWeight: FontWeight.w500,
                    height: 1.42,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF0080C6).withOpacity(0.10),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 8,
                  ),
                  child: const Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          'Transaction\nDate',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: 'Proxima Nova',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          'Transaction\nAmount',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: 'Proxima Nova',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Text(
                          'Loan Outstanding\nAmount',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: 'Proxima Nova',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, thickness: 0.5, color: Colors.black26),
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: _transactionsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          'No transactions available',
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    }

                    final txns = snapshot.data!;
                    final totalAmount = txns.fold<double>(
                      0.0,
                      (sum, t) => sum + _doubleValue(t['transaction_amount']),
                    );

                    final lastOutstanding = _stringValue(
                      txns.last['transaction_principal_amount'],
                    );

                    return Column(
                      children: [
                        ...txns.map((row) {
                          final transactionDate =
                              _stringValue(row['transaction_date']);
                          final transactionAmount =
                              _doubleValue(row['transaction_amount']);
                          final outstandingAmount = _stringValue(
                            row['transaction_principal_amount'],
                          );

                          return Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      transactionDate,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Color(0xFF21409A),
                                        fontSize: 12,
                                        fontFamily: 'Proxima Nova',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      '${transactionAmount.toStringAsFixed(0)} BDT',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Color(0xFF21409A),
                                        fontSize: 12,
                                        fontFamily: 'Proxima Nova',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Text(
                                      '$outstandingAmount BDT',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Color(0xFF0880C6),
                                        fontSize: 12,
                                        fontFamily: 'Proxima Nova',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(
                                height: 18,
                                thickness: 0.5,
                                color: Colors.black12,
                              ),
                            ],
                          );
                        }),
                        const Divider(
                          height: 24,
                          thickness: 0.5,
                          color: Colors.black26,
                        ),
                        Row(
                          children: [
                            const Expanded(
                              flex: 3,
                              child: Text(
                                'Total',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontFamily: 'Proxima Nova',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                '${totalAmount.toStringAsFixed(0)} BDT',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontFamily: 'Proxima Nova',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Text(
                                '$lastOutstanding BDT',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontFamily: 'Proxima Nova',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
