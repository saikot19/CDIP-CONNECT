import 'package:flutter/material.dart';

class LoanDetailsScreen extends StatelessWidget {
  final ScrollController? scrollController;
  const LoanDetailsScreen({Key? key, this.scrollController}) : super(key: key);

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
                const Text(
                  'Loan Portfolio Details',
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
                ..._buildLoanRows(),
                const Divider(
                    height: 24, thickness: 0.5, color: Colors.black26),
                // Totals row
                Row(
                  children: const [
                    Expanded(
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
                        '79,490 BDT',
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
                        '0 BDT',
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
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildLoanRows() {
    // Replace this with your real data
    final List<Map<String, String>> rows = [
      {
        'date': '23/10/2023',
        'amount': '6,560 BDT',
        'outstanding': '66,150 BDT',
      },
      {
        'date': '18/12/2023',
        'amount': '6,650 BDT',
        'outstanding': '59,500 BDT',
      },
      {
        'date': '15/1/2024',
        'amount': '6,650 BDT',
        'outstanding': '52,850 BDT',
      },
      {
        'date': '19/2/2024',
        'amount': '6,650 BDT',
        'outstanding': '46,220 BDT',
      },
      {
        'date': '18/3/2024',
        'amount': '6,650 BDT',
        'outstanding': '39,550 BDT',
      },
      {
        'date': '15/4/2024',
        'amount': '6,650 BDT',
        'outstanding': '32,900 BDT',
      },
      {
        'date': '23/5/2024',
        'amount': '6,560 BDT',
        'outstanding': '19,600 BDT',
      },
      {
        'date': '10/6/2024',
        'amount': '6,560 BDT',
        'outstanding': '19,600 BDT',
      },
      {
        'date': '15/7/2024',
        'amount': '6,650 BDT',
        'outstanding': '12,950 BDT',
      },
      {
        'date': '21/8/2024',
        'amount': '6,650 BDT',
        'outstanding': '6,950 BDT',
      },
      {
        'date': '27/8/2024',
        'amount': '650 BDT',
        'outstanding': '0 BDT',
      },
      {
        'date': '19/9/2024',
        'amount': '6,300 BDT',
        'outstanding': '0 BDT',
      },
    ];

    return rows
        .map(
          (row) => Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      row['date'] ?? '',
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
                      row['amount'] ?? '',
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
                      row['outstanding'] ?? '',
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
              const Divider(height: 18, thickness: 0.5, color: Colors.black12),
            ],
          ),
        )
        .toList();
  }
}
