import 'package:cdip_connect/core/services/localization_service.dart';
import 'package:cdip_connect/core/utils/app_formatters.dart';
import 'package:cdip_connect/core/utils/app_theme.dart';
import 'package:cdip_connect/shared/data/local/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoanDetailsScreen extends ConsumerStatefulWidget {
  final String loanId;
  final String productName;

  const LoanDetailsScreen({
    super.key,
    required this.loanId,
    required this.productName,
  });

  @override
  ConsumerState<LoanDetailsScreen> createState() => _LoanDetailsScreenState();
}

class _LoanDetailsScreenState extends ConsumerState<LoanDetailsScreen> {
  late Future<List<Map<String, dynamic>>> _transactionsFuture;

  @override
  void initState() {
    super.initState();
    _transactionsFuture = DatabaseHelper().getLoanTransactions(loanId: widget.loanId);
  }

  String _stringValue(dynamic value) => value?.toString() ?? '';

  double _doubleValue(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations(ref.watch(localizationProvider));
    final topSafeArea = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: AppTheme.scaffold(context),
      body: Padding(
        padding: EdgeInsets.fromLTRB(12, topSafeArea + 28, 12, 16),
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.elevatedSurface(context),
            borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
            boxShadow: [AppTheme.cardShadow(context)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopHandle(context),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    t.loanPortfolioDetails,
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppTheme.textPrimary(context),
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      height: 1.25,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildHeader(t),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Divider(height: 1, thickness: 0.5, color: AppTheme.divider(context)),
              ),
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: _transactionsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Text(
                          t.noTransactionsAvailable,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      );
                    }
                    return _buildTransactionList(snapshot.data!, t);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopHandle(BuildContext context) {
    return Padding(
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
            icon: const Icon(Icons.close, color: Color(0xFF0880C6)),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(AppLocalizations t) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0080C6).withOpacity(0.10),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              t.transactionDate,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.textPrimary(context),
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              t.transactionAmount,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.textPrimary(context),
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList(List<Map<String, dynamic>> txns, AppLocalizations t) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      itemCount: txns.length + 1,
      separatorBuilder: (_, __) => Divider(
        height: 18,
        thickness: 0.5,
        color: AppTheme.divider(context),
      ),
      itemBuilder: (context, index) {
        if (index == txns.length) {
          return _TransactionSummary(text: t.transactionCountNote(txns.length));
        }

        final row = txns[index];
        final transactionDate = _stringValue(row['transaction_date']);
        final transactionAmount = _doubleValue(row['transaction_amount']);

        return Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                AppFormatters.date(transactionDate),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppTheme.isDark(context)
                      ? AppTheme.textPrimary(context)
                      : const Color(0xFF21409A),
                  fontSize: 12,
                  fontWeight: AppTheme.isDark(context) ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                AppFormatters.amount(transactionAmount, suffix: t.bdt),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppTheme.isDark(context)
                      ? AppTheme.textPrimary(context)
                      : const Color(0xFF21409A),
                  fontSize: 12,
                  fontWeight: AppTheme.isDark(context) ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _TransactionSummary extends StatelessWidget {
  final String text;

  const _TransactionSummary({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          textAlign: TextAlign.left,
          style: TextStyle(
            color: AppTheme.mutedText(context),
            fontSize: 12,
            fontWeight: FontWeight.w400,
            height: 1.35,
          ),
        ),
      ),
    );
  }
}
