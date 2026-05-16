import 'package:cdip_connect/shared/data/local/database_helper.dart';
import 'package:flutter/material.dart';

class LoanDetailsScreen extends StatefulWidget {
  final String loanId;
  final String productName;

  const LoanDetailsScreen({
    super.key,
    required this.loanId,
    required this.productName,
  });

  @override
  State<LoanDetailsScreen> createState() => _LoanDetailsScreenState();
}

class _LoanDetailsScreenState extends State<LoanDetailsScreen> {
  late Future<List<Map<String, dynamic>>> _transactionsFuture;

  @override
  void initState() {
    super.initState();
    _transactionsFuture = DatabaseHelper().getLoanTransactions(
      loanId: widget.loanId,
    );
  }

  String _stringValue(dynamic value) => value?.toString() ?? '';

  double _doubleValue(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final topSafeArea = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: Padding(
        padding: EdgeInsets.fromLTRB(12, topSafeArea + 22, 12, 16),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
            boxShadow: [
              BoxShadow(
                color: Color(0x19000000),
                blurRadius: 18,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
                child: Row(
                  children: [
                    const Spacer(),
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.close,
                        color: Color(0xFF0880C6),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  widget.productName,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontFamily: 'Proxima Nova',
                    fontWeight: FontWeight.w500,
                    height: 1.25,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildHeader(),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Divider(
                  height: 1,
                  thickness: 0.5,
                  color: Colors.black26,
                ),
              ),
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: _transactionsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text(
                          'No transactions available',
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    }

                    return _buildTransactionList(snapshot.data!);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0080C6).withOpacity(0.10),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
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
    );
  }

  Widget _buildTransactionList(List<Map<String, dynamic>> txns) {
    final totalAmount = txns.fold<double>(
      0.0,
      (sum, t) => sum + _doubleValue(t['transaction_amount']),
    );

    final lastOutstanding = _stringValue(
      txns.last['transaction_principal_amount'],
    );

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      itemCount: txns.length + 1,
      separatorBuilder: (_, __) => const Divider(
        height: 18,
        thickness: 0.5,
        color: Colors.black12,
      ),
      itemBuilder: (context, index) {
        if (index == txns.length) {
          return Padding(
            padding: const EdgeInsets.only(top: 6),
            child: _buildTotalRow(totalAmount, lastOutstanding),
          );
        }

        final row = txns[index];
        final transactionDate = _stringValue(row['transaction_date']);
        final transactionAmount = _doubleValue(row['transaction_amount']);
        final outstandingAmount = _stringValue(
          row['transaction_principal_amount'],
        );

        return Row(
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
        );
      },
    );
  }

  Widget _buildTotalRow(double totalAmount, String lastOutstanding) {
    return Row(
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
    );
  }
}
