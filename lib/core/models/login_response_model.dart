// Models for API responses
class LoginResponse {
  final int status;
  final String message;
  final String appVersion;
  final String accessToken;
  final UserData userData;
  final List<LoanProduct> loanProducts;
  final AllSummary allSummary;
  final LoanTransaction loanTransaction;
  final SavingTransaction savingTransaction;
  final List<MarketingBanner> marketingBanners;

  LoginResponse({
    required this.status,
    required this.message,
    required this.appVersion,
    required this.accessToken,
    required this.userData,
    required this.loanProducts,
    required this.allSummary,
    required this.loanTransaction,
    required this.savingTransaction,
    required this.marketingBanners,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      appVersion: json['app_version'] ?? '',
      accessToken: json['access_token'] ?? '',
      userData: UserData.fromJson(json['user_data'] ?? {}),
      loanProducts: (json['loan_product'] as List?)
              ?.map((e) => LoanProduct.fromJson(e))
              .toList() ??
          [],
      allSummary: AllSummary.fromJson(json['all_summery'] ?? {}),
      loanTransaction: LoanTransaction.fromJson(json['loan_transaction'] ?? {}),
      savingTransaction:
          SavingTransaction.fromJson(json['savingTransaction'] ?? {}),
      marketingBanners: (json['marketing_bannar'] as List?)
              ?.map((e) => MarketingBanner.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'app_version': appVersion,
      'access_token': accessToken,
      'user_data': {
        'id': userData.id,
        'name': userData.name,
        'mobile_no': userData.mobileNo,
        'branch_name': userData.branchName,
        'smart_id': userData.smartId,
        'national_id': userData.nationalId,
        'samity_id': userData.samityId,
        'original_member_id': userData.originalMemberId,
        'branch_id': userData.branchId,
        'nick_name': userData.nickName,
      },
      'loan_product': loanProducts
          .map((p) => {
                'id': p.id,
                'name': p.name,
                'short_name': p.shortName,
                'code': p.code,
                'minimum_loan_amount': p.minimumLoanAmount,
                'maximum_loan_amount': p.maximumLoanAmount,
                'default_loan_amount': p.defaultLoanAmount,
                'grace_period': p.gracePeriod,
                'number_of_installment': p.numberOfInstallment,
                'repayment_frequency': p.repaymentFrequency,
              })
          .toList(),
      'all_summery': {
        'member_id': allSummary.memberId,
        'loan_count': allSummary.loanCount,
        'loans': allSummary.loans
            .map((l) => {
                  'loan_id': l.loanId,
                  'customized_loan_no': l.customizedLoanNo,
                  'loan_product_name': l.loanProductName,
                  'disburse_date': l.disburseDate,
                  'last_schedule_date': l.lastScheduleDate,
                  'loan_amount': l.loanAmount,
                  'total_payable_amount': l.totalPayableAmount,
                  'total_recovered_amount': l.totalRecoveredAmount,
                  'outstanding_amount': l.outstandingAmount,
                  'is_overdue': l.isOverdue,
                  'overdue_amount': l.overdueAmount,
                })
            .toList(),
        'saving_count': allSummary.savingCount,
        'savings': allSummary.savings
            .map((s) => {
                  'savings_id': s.savingsId,
                  'code': s.code,
                  'product_name': s.productName,
                  'opening_date': s.openingDate,
                  'total_deposit': s.totalDeposit,
                  'total_withdraw': s.totalWithdraw,
                  'net_saving_amount': s.netSavingAmount,
                })
            .toList(),
      },
      'loan_transaction': {
        'total_payable_amount': loanTransaction.totalPayableAmount,
        'total_transaction_amount': loanTransaction.totalTransactionAmount,
        'total_outstanding_after_transaction':
            loanTransaction.totalOutstandingAfterTransaction,
        'transactions': loanTransaction.transactions
            .map((t) => {
                  'transaction_date': t.transactionDate,
                  'transaction_amount': t.amount,
                  'outstanding_after_transaction': t.outstanding,
                })
            .toList(),
      },
      'savingTransaction': {
        'total_deposit_amount': savingTransaction.totalDepositAmount,
        'total_withdrawal_amount': savingTransaction.totalWithdrawalAmount,
        'final_balance': savingTransaction.finalBalance,
        'transactions': savingTransaction.transactions
            .map((t) => {
                  'transaction_date': t.transactionDate,
                  'deposit_amount': t.amount,
                  'balance': t.outstanding,
                })
            .toList(),
      },
      'marketing_bannar': marketingBanners.map((b) => b.toJson()).toList(),
    };
  }
}

class MarketingBanner {
  final String id;
  final String image;
  final String title;

  MarketingBanner({required this.id, required this.image, required this.title});

  factory MarketingBanner.fromJson(Map<String, dynamic> json) {
    return MarketingBanner(
      id: json['id']?.toString() ?? '',
      image: json['image'] ?? '',
      title: json['title'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'title': title,
    };
  }
}

class UserData {
  final String id;
  final String name;
  final String mobileNo;
  final String branchName;
  final String smartId;
  final String nationalId;
  final String samityId;
  final String originalMemberId;
  final String branchId;
  final String nickName;

  UserData({
    required this.id,
    required this.name,
    required this.mobileNo,
    required this.branchName,
    required this.smartId,
    required this.nationalId,
    required this.samityId,
    required this.originalMemberId,
    required this.branchId,
    required this.nickName,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      mobileNo: json['mobile_no'] ?? '',
      branchName: json['branch_name'] ?? '',
      smartId: json['smart_id'] ?? '',
      nationalId: json['national_id'] ?? '',
      samityId: json['samity_id']?.toString() ?? '',
      originalMemberId: json['original_member_id']?.toString() ?? '',
      branchId: json['branch_id']?.toString() ?? '',
      nickName: json['nick_name'] ?? '',
    );
  }
}

class LoanProduct {
  final String id;
  final String name;
  final String shortName;
  final String code;
  final String minimumLoanAmount;
  final String maximumLoanAmount;
  final String defaultLoanAmount;
  final String gracePeriod;
  final String numberOfInstallment;
  final String repaymentFrequency;

  LoanProduct({
    required this.id,
    required this.name,
    required this.shortName,
    required this.code,
    required this.minimumLoanAmount,
    required this.maximumLoanAmount,
    required this.defaultLoanAmount,
    required this.gracePeriod,
    required this.numberOfInstallment,
    required this.repaymentFrequency,
  });

  factory LoanProduct.fromJson(Map<String, dynamic> json) {
    return LoanProduct(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      shortName: json['short_name'] ?? '',
      code: json['code'] ?? '',
      minimumLoanAmount: json['minimum_loan_amount']?.toString() ?? '',
      maximumLoanAmount: json['maximum_loan_amount']?.toString() ?? '',
      defaultLoanAmount: json['default_loan_amount']?.toString() ?? '',
      gracePeriod: json['grace_period'] ?? '',
      numberOfInstallment: json['number_of_installment']?.toString() ?? '',
      repaymentFrequency: json['repayment_frequency'] ?? '',
    );
  }
}

class AllSummary {
  final String memberId;
  final int loanCount;
  final List<UserLoan> loans;
  final int savingCount;
  final List<UserSaving> savings;

  AllSummary({
    required this.memberId,
    required this.loanCount,
    required this.loans,
    required this.savingCount,
    required this.savings,
    required List<dynamic> marketingBanners,
  });

  factory AllSummary.fromJson(Map<String, dynamic> json) {
    return AllSummary(
      memberId: json['member_id']?.toString() ?? '',
      loanCount: json['loan_count'] ?? 0,
      loans:
          (json['loans'] as List?)?.map((e) => UserLoan.fromJson(e)).toList() ??
              [],
      savingCount: json['saving_count'] ?? 0,
      savings: (json['savings'] as List?)
              ?.map((e) => UserSaving.fromJson(e))
              .toList() ??
          [],
      marketingBanners: (json['marketing_banners'] as List?)
              ?.map((e) => MarketingBanner.fromJson(e))
              .toList() ??
          [],
    );
  }
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
  });

  factory UserLoan.fromJson(Map<String, dynamic> json) {
    return UserLoan(
      loanId: json['loan_id']?.toString() ?? '',
      customizedLoanNo: json['customized_loan_no'] ?? '',
      loanProductName: json['loan_product_name'] ?? '',
      disburseDate: json['disburse_date'] ?? '',
      lastScheduleDate: json['last_schedule_date'] ?? '',
      loanAmount: double.tryParse(json['loan_amount']?.toString() ?? '0') ?? 0,
      totalPayableAmount:
          double.tryParse(json['total_payable_amount']?.toString() ?? '0') ?? 0,
      totalRecoveredAmount:
          double.tryParse(json['total_recovered_amount']?.toString() ?? '0') ??
              0,
      outstandingAmount:
          double.tryParse(json['outstanding_amount']?.toString() ?? '0') ?? 0,
      isOverdue: json['is_overdue'] ?? false,
      overdueAmount:
          double.tryParse(json['overdue_amount']?.toString() ?? '0') ?? 0,
    );
  }
}

class UserSaving {
  final String savingsId;
  final String code;
  final String? productName;
  final String openingDate;
  final double totalDeposit;
  final double totalWithdraw;
  final double netSavingAmount;

  UserSaving({
    required this.savingsId,
    required this.code,
    this.productName,
    required this.openingDate,
    required this.totalDeposit,
    required this.totalWithdraw,
    required this.netSavingAmount,
  });

  factory UserSaving.fromJson(Map<String, dynamic> json) {
    return UserSaving(
      savingsId: json['savings_id']?.toString() ?? '',
      code: json['code'] ?? '',
      productName: json['product_name'],
      openingDate: json['opening_date'] ?? '',
      totalDeposit:
          double.tryParse(json['total_deposit']?.toString() ?? '0') ?? 0,
      totalWithdraw:
          double.tryParse(json['total_withdraw']?.toString() ?? '0') ?? 0,
      netSavingAmount:
          double.tryParse(json['net_saving_amount']?.toString() ?? '0') ?? 0,
    );
  }
}

class LoanTransaction {
  final String totalPayableAmount;
  final String totalTransactionAmount;
  final String totalOutstandingAfterTransaction;
  final List<Transaction> transactions;

  LoanTransaction({
    required this.totalPayableAmount,
    required this.totalTransactionAmount,
    required this.totalOutstandingAfterTransaction,
    required this.transactions,
  });

  factory LoanTransaction.fromJson(Map<String, dynamic> json) {
    return LoanTransaction(
      totalPayableAmount: json['total_payable_amount']?.toString() ?? '0',
      totalTransactionAmount:
          json['total_transaction_amount']?.toString() ?? '0',
      totalOutstandingAfterTransaction:
          json['total_outstanding_after_transaction']?.toString() ?? '0',
      transactions: (json['transactions'] as List?)
              ?.map((e) => Transaction.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class SavingTransaction {
  final String totalDepositAmount;
  final String totalWithdrawalAmount;
  final String finalBalance;
  final List<Transaction> transactions;

  SavingTransaction({
    required this.totalDepositAmount,
    required this.totalWithdrawalAmount,
    required this.finalBalance,
    required this.transactions,
  });

  factory SavingTransaction.fromJson(Map<String, dynamic> json) {
    return SavingTransaction(
      totalDepositAmount: json['total_deposit_amount']?.toString() ?? '0',
      totalWithdrawalAmount: json['total_withdrawal_amount']?.toString() ?? '0',
      finalBalance: json['final_balance']?.toString() ?? '0',
      transactions: (json['transactions'] as List?)
              ?.map((e) => Transaction.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class Transaction {
  final String transactionDate;
  final String amount;
  final String outstanding;
  final String type;

  Transaction({
    required this.transactionDate,
    required this.amount,
    required this.outstanding,
    this.type = 'loan',
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      transactionDate: json['transaction_date'] ?? '',
      amount: json['transaction_amount']?.toString() ??
          json['deposit_amount']?.toString() ??
          '0',
      outstanding: json['outstanding_after_transaction']?.toString() ??
          json['balance']?.toString() ??
          '0',
      type: 'loan',
    );
  }
}
