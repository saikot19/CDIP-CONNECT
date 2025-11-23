import 'package:flutter/material.dart';
import '../models/login_response_model.dart';

class LoanDetailsScreen extends StatelessWidget {
  final ScrollController? scrollController;
  final List<Transaction>? transactions;
  final String? productName;

  const LoanDetailsScreen({
    Key? key,
    this.scrollController,
    this.transactions,
    this.productName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final txns = transactions ?? [];

    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          controller: scrollController,
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
                  productName ?? 'Loan Portfolio Details',
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
                // Table rows (replace with your real data)
                if (txns.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      'No transactions available',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  )
                else
                  ...txns.map((row) => Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  row.transactionDate,
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
                                  '${row.amount} BDT',
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
                                  '${row.outstanding} BDT',
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
                if (txns.isNotEmpty) ...[
                  const Divider(
                      height: 24, thickness: 0.5, color: Colors.black26),
                  // Totals row
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
                          '${txns.fold(0.0, (sum, t) => sum + (double.tryParse(t.amount) ?? 0)).toStringAsFixed(0)} BDT',
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
                          '${txns.last.outstanding} BDT',
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
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
