class LoginResponse {
  final int status;
  final String message;
  final String appVersion;
  final String accessToken;
  final String lastUpdated;
  final UserData userData;
  final DashboardSummary dashboardSummary;
  final List<MarketingBanner> marketingBanners;
  final List<LoanTransaction> loanTransactions;
  final List<SavingAccount> savingAccounts;
  final List<LoanProduct> loanProducts;
  final AllSummary allSummary;

  LoginResponse({
    required this.status,
    required this.message,
    required this.appVersion,
    required this.accessToken,
    required this.lastUpdated,
    required this.userData,
    required this.dashboardSummary,
    required this.marketingBanners,
    required this.loanTransactions,
    required this.savingAccounts,
    required this.loanProducts,
    required this.allSummary,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final rawLoanTransaction = json['loan_transaction'];
    final List rawLoanTransactions;
    if (rawLoanTransaction is List) {
      rawLoanTransactions = rawLoanTransaction;
    } else if (rawLoanTransaction is Map) {
      final data = rawLoanTransaction['data'];
      rawLoanTransactions = data is List ? data : const [];
    } else {
      rawLoanTransactions = const [];
    }

    final loanTransactions = rawLoanTransactions
        .whereType<Map>()
        .map((e) => LoanTransaction.fromJson(Map<String, dynamic>.from(e)))
        .toList();

    // Support both the correct API key and the old wrong key for backward compatibility.
    final rawSavings = (json['saving_transaction'] as List?) ??
        (json['savingTransaction'] as List?) ??
        [];

    final savingAccounts = rawSavings
        .whereType<Map>()
        .map((e) => SavingAccount.fromJson(Map<String, dynamic>.from(e)))
        .toList();

    final allSummary = AllSummary.fromApi(
      loanTransactions: loanTransactions,
      savingAccounts: savingAccounts,
      memberId: _asString(json['user_data']?['id']),
    );

    return LoginResponse(
      status: _asInt(json['status']),
      message: _asString(json['message']),
      appVersion: _asString(json['app_version']),
      accessToken: _asString(json['access_token']),
      lastUpdated: _asString(
        json['last_updated'],
        fallback: DateTime.now().toIso8601String(),
      ),
      userData:
          UserData.fromJson((json['user_data'] as Map<String, dynamic>?) ?? {}),
      dashboardSummary: DashboardSummary.fromJson(
        (json['dashboard_summery'] as Map<String, dynamic>?) ?? {},
      ),
      marketingBanners: ((json['marketing_bannar'] as List?) ?? [])
          .whereType<Map>()
          .map((e) => MarketingBanner.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      loanTransactions: loanTransactions,
      savingAccounts: savingAccounts,
      loanProducts: ((json['loan_product'] as List?) ?? [])
          .whereType<Map>()
          .map((e) => LoanProduct.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      allSummary: allSummary,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'app_version': appVersion,
      'access_token': accessToken,
      'last_updated': lastUpdated,
      'user_data': userData.toJson(),
      'dashboard_summery': dashboardSummary.toJson(),
      'marketing_bannar': marketingBanners.map((e) => e.toJson()).toList(),
      'loan_transaction': loanTransactions.map((e) => e.toJson()).toList(),
      // Write the correct API key
      'saving_transaction': savingAccounts.map((e) => e.toJson()).toList(),
      'loan_product': loanProducts.map((e) => e.toJson()).toList(),
    };
  }
}

class AllSummary {
  final String memberId;
  final int loanCount;
  final List<UserLoan> loans;
  final int savingCount;
  final List<UserSaving> savings;
  final List<MarketingBanner> marketingBanners;

  AllSummary({
    required this.memberId,
    required this.loanCount,
    required this.loans,
    required this.savingCount,
    required this.savings,
    required this.marketingBanners,
  });

  factory AllSummary.fromApi({
    required List<LoanTransaction> loanTransactions,
    required List<SavingAccount> savingAccounts,
    required String memberId,
  }) {
    final userLoans = loanTransactions.map((lt) {
      return UserLoan(
        loanId: lt.loanId,
        customizedLoanNo: lt.customizedLoanNo,
        loanProductName: lt.productName,
        disburseDate: lt.disburseDate,
        lastScheduleDate: lt.loanFullyPaidDate,
        loanAmount: lt.totalPayableAmount.toDouble(),
        totalPayableAmount: lt.totalPayableAmount.toDouble(),
        totalRecoveredAmount: lt.totalTransactionAmount.toDouble(),
        outstandingAmount: lt.totalOutstandingAfterTransaction.toDouble(),
        isOverdue: lt.totalOverdueTransactionAmount > 0,
        overdueAmount: lt.totalOverdueTransactionAmount.toDouble(),
        isOpen: lt.isOpen == '1',
      );
    }).toList();

    // Deduplicate savings by savingsId so duplicate API rows do not create duplicate cards.
    final Map<String, SavingAccount> uniqueSavingsMap = {};
    for (final sa in savingAccounts) {
      uniqueSavingsMap[sa.savingId] = sa;
    }

    final userSavings = uniqueSavingsMap.values.map((sa) {
      return UserSaving(
        savingsId: sa.savingId,
        code: sa.customizedSavingNo,
        productName: sa.productName.isEmpty ? null : sa.productName,
        openingDate: sa.openingDate,
        closingDate: sa.closingDate,
        totalDeposit: sa.totalDeposit.toDouble(),
        totalWithdraw: sa.totalWithdraw.toDouble(),
        netSavingAmount: sa.currentBalance.toDouble(),
        isOpen: sa.isOpen == 1,
      );
    }).toList();

    return AllSummary(
      memberId: memberId,
      loanCount: userLoans.length,
      loans: userLoans,
      savingCount: userSavings.length,
      savings: userSavings,
      marketingBanners: const [],
    );
  }
}

class DashboardSummary {
  final int loanCount;
  final double loanOutstanding;
  final int savingsCount;
  final double savingsOutstanding;
  final int dueLoanCount;
  final double dueLoanAmount;

  DashboardSummary({
    required this.loanCount,
    required this.loanOutstanding,
    required this.savingsCount,
    required this.savingsOutstanding,
    required this.dueLoanCount,
    required this.dueLoanAmount,
  });

  factory DashboardSummary.fromJson(Map<String, dynamic> json) {
    return DashboardSummary(
      loanCount: _asInt(json['loan_count']),
      loanOutstanding: _asDouble(json['loan_outstanding']),
      savingsCount: _asInt(json['savings_count']),
      savingsOutstanding: _asDouble(json['savings_outstanding']),
      dueLoanCount: _asInt(json['due_loan_count']),
      dueLoanAmount: _asDouble(json['due_loan_amount']),
    );
  }

  Map<String, dynamic> toJson() => {
        'loan_count': loanCount,
        'loan_outstanding': loanOutstanding,
        'savings_count': savingsCount,
        'savings_outstanding': savingsOutstanding,
        'due_loan_count': dueLoanCount,
        'due_loan_amount': dueLoanAmount,
      };
}

class MarketingBanner {
  final String id;
  final String image;
  final String title;

  MarketingBanner({
    required this.id,
    required this.image,
    required this.title,
  });

  factory MarketingBanner.fromJson(Map<String, dynamic> json) {
    return MarketingBanner(
      id: _asString(json['id']),
      image: _asString(json['image']),
      title: _asString(json['title']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'image': image,
        'title': title,
      };
}

class UserData {
  final String id;
  final String code;
  final String name;
  final String? nickName;
  final String mobileNo;
  final String branchName;
  final String smartId;
  final String nationalId;
  final String samityId;
  final String originalMemberId;
  final String branchId;

  UserData({
    required this.id,
    required this.code,
    required this.name,
    this.nickName,
    required this.mobileNo,
    required this.branchName,
    required this.smartId,
    required this.nationalId,
    required this.samityId,
    required this.originalMemberId,
    required this.branchId,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: _asString(json['id']),
      code: _asString(json['code']),
      name: _asString(json['name']),
      nickName: json['nick_name']?.toString(),
      mobileNo: _asString(json['mobile_no']),
      branchName: _asString(json['branch_name']),
      smartId: _asString(json['smart_id']),
      nationalId: _asString(json['national_id']),
      samityId: _asString(json['samity_id']),
      originalMemberId: _asString(json['original_member_id']),
      branchId: _asString(json['branch_id']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'name': name,
        'nick_name': nickName,
        'mobile_no': mobileNo,
        'branch_name': branchName,
        'smart_id': smartId,
        'national_id': nationalId,
        'samity_id': samityId,
        'original_member_id': originalMemberId,
        'branch_id': branchId,
      };
}

class LoanProduct {
  final String id;
  final String code;
  final String name;

  LoanProduct({
    required this.id,
    required this.code,
    required this.name,
  });

  factory LoanProduct.fromJson(Map<String, dynamic> json) {
    return LoanProduct(
      id: _asString(json['id']),
      code: _asString(json['code']),
      name: _asString(json['name']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'name': name,
      };
}

class LoanTransaction {
  final String loanId;
  final String productName;
  final String customizedLoanNo;
  final String disburseDate;
  final String loanFullyPaidDate;
  final String isLoanFullyPaid;
  final String isOpen;
  final int totalPayableAmount;
  final int totalTransactionAmount;
  final int totalOverdueTransactionAmount;
  final int totalOutstandingAfterTransaction;
  final List<Transaction> transactions;

  LoanTransaction({
    required this.loanId,
    required this.productName,
    required this.customizedLoanNo,
    required this.disburseDate,
    required this.loanFullyPaidDate,
    required this.isLoanFullyPaid,
    required this.isOpen,
    required this.totalPayableAmount,
    required this.totalTransactionAmount,
    required this.totalOverdueTransactionAmount,
    required this.totalOutstandingAfterTransaction,
    required this.transactions,
  });

  factory LoanTransaction.fromJson(Map<String, dynamic> json) {
    return LoanTransaction(
      loanId: _asString(json['loan_id']),
      productName: _asString(json['product_name']),
      customizedLoanNo: _asString(json['customized_loan_no']),
      disburseDate: _asString(json['disburse_date']),
      loanFullyPaidDate: _asString(json['loan_fully_paid_date']),
      isLoanFullyPaid: _asString(json['is_loan_fully_paid'], fallback: '0'),
      isOpen: _asString(json['is_open'], fallback: '0'),
      totalPayableAmount: _asInt(json['total_payable_amount']),
      totalTransactionAmount: _asInt(json['total_transaction_amount']),
      totalOverdueTransactionAmount:
          _asInt(json['total_overdue_transaction_amount']),
      totalOutstandingAfterTransaction:
          _asInt(json['total_outstanding_after_transaction']),
      transactions: ((json['transactions'] as List?) ?? [])
          .map((e) => Transaction.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'loan_id': loanId,
        'product_name': productName,
        'customized_loan_no': customizedLoanNo,
        'disburse_date': disburseDate,
        'loan_fully_paid_date': loanFullyPaidDate,
        'is_loan_fully_paid': isLoanFullyPaid,
        'is_open': isOpen,
        'total_payable_amount': totalPayableAmount,
        'total_transaction_amount': totalTransactionAmount,
        'total_overdue_transaction_amount': totalOverdueTransactionAmount,
        'total_outstanding_after_transaction': totalOutstandingAfterTransaction,
        'transactions': transactions.map((e) => e.toJson()).toList(),
      };
}

class SavingAccount {
  final String savingId;
  final String productName;
  final String customizedSavingNo;
  final String openingDate;
  final String? closingDate;
  final int isOpen;
  final int totalDeposit;
  final int totalWithdraw;
  final int currentBalance;
  final List<SavingTransactionDetail> transactions;

  SavingAccount({
    required this.savingId,
    required this.productName,
    required this.customizedSavingNo,
    required this.openingDate,
    this.closingDate,
    required this.isOpen,
    required this.totalDeposit,
    required this.totalWithdraw,
    required this.currentBalance,
    required this.transactions,
  });

  factory SavingAccount.fromJson(Map<String, dynamic> json) {
    return SavingAccount(
      savingId: _asString(json['saving_id']),
      productName: _asString(json['product_name']),
      customizedSavingNo: _asString(json['customized_saving_no']),
      openingDate: _asString(json['opening_date']),
      closingDate: json['closing_date']?.toString(),
      isOpen: _asInt(json['is_open']),
      totalDeposit: _asInt(json['total_deposit']),
      totalWithdraw: _asInt(json['total_withdraw']),
      currentBalance: _asInt(json['current_balance']),
      transactions: ((json['transactions'] as List?) ?? [])
          .map((e) =>
              SavingTransactionDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'saving_id': savingId,
        'product_name': productName,
        'customized_saving_no': customizedSavingNo,
        'opening_date': openingDate,
        'closing_date': closingDate,
        'is_open': isOpen,
        'total_deposit': totalDeposit,
        'total_withdraw': totalWithdraw,
        'current_balance': currentBalance,
        'transactions': transactions.map((e) => e.toJson()).toList(),
      };
}

class Transaction {
  final String transactionDate;
  final int transactionAmount;
  final double transactionPrincipalAmount;
  final double transactionInterestAmount;

  Transaction({
    required this.transactionDate,
    required this.transactionAmount,
    required this.transactionPrincipalAmount,
    required this.transactionInterestAmount,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      transactionDate: _asString(json['transaction_date']),
      transactionAmount: _asInt(json['transaction_amount']),
      transactionPrincipalAmount:
          _asDouble(json['transaction_principal_amount']),
      transactionInterestAmount: _asDouble(json['transaction_interest_amount']),
    );
  }

  Map<String, dynamic> toJson() => {
        'transaction_date': transactionDate,
        'transaction_amount': transactionAmount,
        'transaction_principal_amount': transactionPrincipalAmount,
        'transaction_interest_amount': transactionInterestAmount,
      };
}

class SavingTransactionDetail {
  final String transactionDate;
  final int depositAmount;
  final int withdrawAmount;
  final int balanceAfterTx;
  final String flag;

  SavingTransactionDetail({
    required this.transactionDate,
    required this.depositAmount,
    required this.withdrawAmount,
    required this.balanceAfterTx,
    required this.flag,
  });

  factory SavingTransactionDetail.fromJson(Map<String, dynamic> json) {
    return SavingTransactionDetail(
      transactionDate: _asString(json['transaction_date']),
      depositAmount: _asInt(json['deposit_amount']),
      withdrawAmount: _asInt(json['withdraw_amount']),
      balanceAfterTx: _asInt(json['balance_after_tx']),
      flag: _asString(json['flag']),
    );
  }

  Map<String, dynamic> toJson() => {
        'transaction_date': transactionDate,
        'deposit_amount': depositAmount,
        'withdraw_amount': withdrawAmount,
        'balance_after_tx': balanceAfterTx,
        'flag': flag,
      };
}

class UserLoan {
  final String loanId;
  final String customizedLoanNo;
  final String loanProductName;
  final String disburseDate;
  final String lastScheduleDate;
  final double loanAmount;
  final double totalPayableAmount;
  final double totalRecoveredAmount;
  final double outstandingAmount;
  final bool isOverdue;
  final double overdueAmount;
  final bool isOpen;

  UserLoan({
    required this.loanId,
    required this.customizedLoanNo,
    required this.loanProductName,
    required this.disburseDate,
    required this.lastScheduleDate,
    required this.loanAmount,
    required this.totalPayableAmount,
    required this.totalRecoveredAmount,
    required this.outstandingAmount,
    required this.isOverdue,
    required this.overdueAmount,
    required this.isOpen,
  });
}

class UserSaving {
  final String savingsId;
  final String code;
  final String? productName;
  final String openingDate;
  final String? closingDate;
  final double totalDeposit;
  final double totalWithdraw;
  final double netSavingAmount;
  final bool isOpen;

  UserSaving({
    required this.savingsId,
    required this.code,
    this.productName,
    required this.openingDate,
    this.closingDate,
    required this.totalDeposit,
    required this.totalWithdraw,
    required this.netSavingAmount,
    required this.isOpen,
  });
}

int _asInt(dynamic value, {int fallback = 0}) {
  if (value == null) return fallback;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is num) return value.toInt();
  return int.tryParse(value.toString()) ?? fallback;
}

double _asDouble(dynamic value, {double fallback = 0.0}) {
  if (value == null) return fallback;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString()) ?? fallback;
}

String _asString(dynamic value, {String fallback = ''}) {
  if (value == null) return fallback;
  return value.toString();
}
