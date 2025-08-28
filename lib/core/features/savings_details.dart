import 'package:flutter/material.dart';

class SavingsDetailsScreen extends StatelessWidget {
  final ScrollController? scrollController;
  const SavingsDetailsScreen({Key? key, this.scrollController})
      : super(key: key);

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
                  'Saving Portfolio Details',
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
                // Table rows
                ..._buildSavingsRows(),
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
                        '13,100 BDT',
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
                    Expanded(
                      flex: 3,
                      child: Text(
                        '13,100 BDT',
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

  List<Widget> _buildSavingsRows() {
    // Replace this with your real data
    final List<Map<String, String>> rows = [
      {
        'date': '18/9/2023',
        'deposit': '300 BDT',
        'withdraw': '0',
        'balance': '300 BDT',
      },
      {
        'date': '19/9/2023',
        'deposit': '7000 BDT',
        'withdraw': '0',
        'balance': '7,300 BDT',
      },
      {
        'date': '9/10/2023',
        'deposit': '300 BDT',
        'withdraw': '0',
        'balance': '7,600 BDT',
      },
      {
        'date': '18/12/2023',
        'deposit': '300 BDT',
        'withdraw': '0',
        'balance': '8,200 BDT',
      },
      {
        'date': '15/1/2024',
        'deposit': '300 BDT',
        'withdraw': '0',
        'balance': '8,500 BDT',
      },
      {
        'date': '19/2/2024',
        'deposit': '350 BDT',
        'withdraw': '0',
        'balance': '8,850 BDT',
      },
      {
        'date': '18/3/2024',
        'deposit': '250 BDT',
        'withdraw': '0',
        'balance': '9,100 BDT',
      },
      {
        'date': '15/4/2024',
        'deposit': '250 BDT',
        'withdraw': '0',
        'balance': '9,350 BDT',
      },
      {
        'date': '23/5/2024',
        'deposit': '250 BDT',
        'withdraw': '0',
        'balance': '9,600 BDT',
      },
      {
        'date': '10/6/2024',
        'deposit': '300 BDT',
        'withdraw': '0',
        'balance': '9,900 BDT',
      },
      {
        'date': '30/6/2024',
        'deposit': '407 BDT',
        'withdraw': '0',
        'balance': '10,307 BDT',
      },
      {
        'date': '15/7/2024',
        'deposit': '50 BDT',
        'withdraw': '0',
        'balance': '10,357 BDT',
      },
      {
        'date': '9/9/2024',
        'deposit': '1000 BDT',
        'withdraw': '0',
        'balance': '11,357 BDT',
      },
      {
        'date': '29/8/2024',
        'deposit': '350 BDT',
        'withdraw': '0',
        'balance': '11,707 BDT',
      },
      {
        'date': '6/11/2024',
        'deposit': '193 BDT',
        'withdraw': '0',
        'balance': '11,900 BDT',
      },
      {
        'date': '9/12/2024',
        'deposit': '200 BDT',
        'withdraw': '0',
        'balance': '12,100 BDT',
      },
      {
        'date': '19/2/2025',
        'deposit': '200 BDT',
        'withdraw': '0',
        'balance': '12,300 BDT',
      },
      {
        'date': '16/1/2025',
        'deposit': '200 BDT',
        'withdraw': '0',
        'balance': '12,500 BDT',
      },
      {
        'date': '12/3/2025',
        'deposit': '200 BDT',
        'withdraw': '0',
        'balance': '12,700 BDT',
      },
      {
        'date': '14/5/2025',
        'deposit': '200 BDT',
        'withdraw': '0',
        'balance': '12,900 BDT',
      },
      {
        'date': '15/6/2025',
        'deposit': '0',
        'withdraw': '0',
        'balance': '13,100 BDT',
      },
      {
        'date': '4/6/2025',
        'deposit': '0',
        'withdraw': '0',
        'balance': '13,100 BDT',
      },
      {
        'date': '17/4/2025',
        'deposit': '200 BDT',
        'withdraw': '0',
        'balance': '13,100 BDT',
      },
      {
        'date': '778',
        'deposit': '0',
        'withdraw': '0',
        'balance': '13,100 BDT',
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
                      row['deposit'] ?? '',
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
                      row['withdraw'] ?? '',
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
                      row['balance'] ?? '',
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
