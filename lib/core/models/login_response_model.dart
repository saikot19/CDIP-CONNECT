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
    final loanTransactions = (json['loan_transaction'] as List?)
            ?.map((e) => LoanTransaction.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    final savingAccounts = (json['savingTransaction'] as List?)
            ?.map((e) => SavingAccount.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    final allSummary = AllSummary.fromApi(
      loanTransactions: loanTransactions,
      savingAccounts: savingAccounts,
      memberId: json['user_data']?['id']?.toString() ?? '',
    );

    return LoginResponse(
      status: json['status'] as int? ?? 0,
      message: json['message'] as String? ?? '',
      appVersion: json['app_version'] as String? ?? '',
      accessToken: json['access_token'] as String? ?? '',
      lastUpdated: json['last_updated'] as String? ?? '',
      userData:
          UserData.fromJson(json['user_data'] as Map<String, dynamic>? ?? {}),
      dashboardSummary: DashboardSummary.fromJson(
          json['dashboard_summery'] as Map<String, dynamic>? ?? {}),
      marketingBanners: (json['marketing_bannar'] as List?)
              ?.map((e) => MarketingBanner.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      loanTransactions: loanTransactions,
      savingAccounts: savingAccounts,
      loanProducts: (json['loan_product'] as List?)
              ?.map((e) => LoanProduct.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
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
      'savingTransaction': savingAccounts.map((e) => e.toJson()).toList(),
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

    final userSavings = savingAccounts.map((sa) {
      return UserSaving(
        savingsId: sa.savingId,
        code: sa.customizedSavingNo,
        productName: sa.productName,
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
      marketingBanners: [],
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
      loanCount: json['loan_count'] as int? ?? 0,
      loanOutstanding: (json['loan_outstanding'] as num?)?.toDouble() ?? 0.0,
      savingsCount: json['savings_count'] as int? ?? 0,
      savingsOutstanding:
          (json['savings_outstanding'] as num?)?.toDouble() ?? 0.0,
      dueLoanCount: json['due_loan_count'] as int? ?? 0,
      dueLoanAmount: (json['due_loan_amount'] as num?)?.toDouble() ?? 0.0,
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

  MarketingBanner({required this.id, required this.image, required this.title});

  factory MarketingBanner.fromJson(Map<String, dynamic> json) {
    return MarketingBanner(
      id: json['id']?.toString() ?? '',
      image: json['image'] as String? ?? '',
      title: json['title'] as String? ?? '',
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
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      nickName: json['nick_name'] as String?,
      mobileNo: json['mobile_no'] as String? ?? '',
      branchName: json['branch_name'] as String? ?? '',
      smartId: json['smart_id'] as String? ?? '',
      nationalId: json['national_id'] as String? ?? '',
      samityId: json['samity_id']?.toString() ?? '',
      originalMemberId: json['original_member_id']?.toString() ?? '',
      branchId: json['branch_id']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
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
  final String name;

  LoanProduct({required this.id, required this.name});

  factory LoanProduct.fromJson(Map<String, dynamic> json) {
    return LoanProduct(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
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
      loanId: json['loan_id']?.toString() ?? '',
      productName: json['product_name'] as String? ?? '',
      customizedLoanNo: json['customized_loan_no'] as String? ?? '',
      disburseDate: json['disburse_date'] as String? ?? '',
      loanFullyPaidDate: json['loan_fully_paid_date'] as String? ?? '',
      isLoanFullyPaid: json['is_loan_fully_paid'] as String? ?? '0',
      isOpen: json['is_open'] as String? ?? '0',
      totalPayableAmount: json['total_payable_amount'] as int? ?? 0,
      totalTransactionAmount: json['total_transaction_amount'] as int? ?? 0,
      totalOverdueTransactionAmount:
          json['total_overdue_transaction_amount'] as int? ?? 0,
      totalOutstandingAfterTransaction:
          json['total_outstanding_after_transaction'] as int? ?? 0,
      transactions: (json['transactions'] as List?)
              ?.map((e) => Transaction.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
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
      savingId: json['saving_id']?.toString() ?? '',
      productName: json['product_name'] as String? ?? '',
      customizedSavingNo: json['customized_saving_no'] as String? ?? '',
      openingDate: json['opening_date'] as String? ?? '',
      closingDate: json['closing_date'] as String?,
      isOpen: json['is_open'] as int? ?? 0,
      totalDeposit: json['total_deposit'] as int? ?? 0,
      totalWithdraw: json['total_withdraw'] as int? ?? 0,
      currentBalance: json['current_balance'] as int? ?? 0,
      transactions: (json['transactions'] as List? ?? [])
          .map((e) => SavingTransactionDetail.fromJson(e))
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
      transactionDate: json['transaction_date'] as String? ?? '',
      transactionAmount: json['transaction_amount'] as int? ?? 0,
      transactionPrincipalAmount:
          (json['transaction_principal_amount'] as num?)?.toDouble() ?? 0.0,
      transactionInterestAmount:
          (json['transaction_interest_amount'] as num?)?.toDouble() ?? 0.0,
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
      transactionDate: json['transaction_date'] as String? ?? '',
      depositAmount: json['deposit_amount'] as int? ?? 0,
      withdrawAmount: json['withdraw_amount'] as int? ?? 0,
      balanceAfterTx: json['balance_after_tx'] as int? ?? 0,
      flag: json['flag']?.toString() ?? '',
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
