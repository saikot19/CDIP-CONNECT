import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class SavingsDetailsScreen extends StatefulWidget {
  final String savingsId;
  final String productName;

  const SavingsDetailsScreen({
    Key? key,
    required this.savingsId,
    required this.productName,
  }) : super(key: key);

  @override
  State<SavingsDetailsScreen> createState() => _SavingsDetailsScreenState();
}

class _SavingsDetailsScreenState extends State<SavingsDetailsScreen> {
  late Future<List<Map<String, dynamic>>> _transactionsFuture;

  @override
  void initState() {
    super.initState();
    _transactionsFuture = _getSavingsTransactions();
  }

  Future<List<Map<String, dynamic>>> _getSavingsTransactions() async {
    final db = DatabaseHelper();
    return await db.getSavingTransactions(savingsId: widget.savingsId);
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
                // Drag handle
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // Title
                Text(
                  widget.productName,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontFamily: 'Proxima Nova',
                    fontWeight: FontWeight.w500,
                    height: 1.42,
                  ),
                ),
                const SizedBox(height: 16),
                // Table header
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF0080C6).withOpacity(0.10),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  child: Row(
                    children: const [
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
                          'Deposit\nAmount',
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
                          'Withdraw\nAmount',
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
                          'Balance',
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
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          'No transactions available',
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    }

                    final txns = snapshot.data!;
                    return Column(
                      children: [
                        ...txns.map((row) => Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        row['transaction_date'],
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
                                        '${row['deposit_amount']} BDT',
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
                                        '${row['withdrawal_amount']} BDT',
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
                                        '${row['balance']} BDT',
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
                                    color: Colors.black12),
                              ],
                            )),
                        const Divider(
                            height: 24, thickness: 0.5, color: Colors.black26),
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
                                '${txns.fold(0.0, (sum, t) => sum + (t['deposit_amount'] ?? 0)).toStringAsFixed(0)} BDT',
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
                                '${txns.fold(0.0, (sum, t) => sum + (t['withdrawal_amount'] ?? 0)).toStringAsFixed(0)} BDT',
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
                                '${txns.last['balance']} BDT',
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
