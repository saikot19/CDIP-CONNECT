// Models for API responses
class LoginResponse {
  final int status;
  final String message;
  final String appVersion;
  final String accessToken;
  final UserData userData;
  final List<LoanProduct> loanProducts;
  final LoanTransaction loanTransaction;
  final SavingTransaction savingTransaction;

  LoginResponse({
    required this.status,
    required this.message,
    required this.appVersion,
    required this.accessToken,
    required this.userData,
    required this.loanProducts,
    required this.loanTransaction,
    required this.savingTransaction,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: json['status'] ?? 200,
      message: json['message'] ?? '',
      appVersion: json['app_version'] ?? '',
      accessToken: json['access_token'] ?? '',
      userData: UserData.fromJson(json['user_data'] ?? {}),
      loanProducts: (json['loan_product'] as List?)
              ?.map((e) => LoanProduct.fromJson(e))
              .toList() ??
          [],
      loanTransaction: LoanTransaction.fromJson(json['loan_transaction'] ?? {}),
      savingTransaction:
          SavingTransaction.fromJson(json['savingTransaction'] ?? {}),
    );
  }
}

class UserData {
  final String id;
  final String originalMemberId;
  final String branchId;
  final String samityId;
  final String name;
  final String nickName;
  final String mobileNo;
  final String smartId;
  final String nationalId;
  final String branchName;

  UserData({
    required this.id,
    required this.originalMemberId,
    required this.branchId,
    required this.samityId,
    required this.name,
    required this.nickName,
    required this.mobileNo,
    required this.smartId,
    required this.nationalId,
    required this.branchName,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id']?.toString() ?? '',
      originalMemberId: json['original_member_id']?.toString() ?? '',
      branchId: json['branch_id']?.toString() ?? '',
      samityId: json['samity_id']?.toString() ?? '',
      name: json['name'] ?? '',
      nickName: json['nick_name'] ?? '',
      mobileNo: json['mobile_no'] ?? '',
      smartId: json['smart_id'] ?? '',
      nationalId: json['national_id'] ?? '',
      branchName: json['branch_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'original_member_id': originalMemberId,
      'branch_id': branchId,
      'samity_id': samityId,
      'name': name,
      'nick_name': nickName,
      'mobile_no': mobileNo,
      'smart_id': smartId,
      'national_id': nationalId,
      'branch_name': branchName,
    };
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'short_name': shortName,
      'code': code,
      'minimum_loan_amount': minimumLoanAmount,
      'maximum_loan_amount': maximumLoanAmount,
      'default_loan_amount': defaultLoanAmount,
      'grace_period': gracePeriod,
      'number_of_installment': numberOfInstallment,
      'repayment_frequency': repaymentFrequency,
    };
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
      totalPayableAmount: json['total_payable_amount']?.toString() ?? '',
      totalTransactionAmount:
          json['total_transaction_amount']?.toString() ?? '',
      totalOutstandingAfterTransaction:
          json['total_outstanding_after_transaction']?.toString() ?? '',
      transactions: (json['transactions'] as List?)
              ?.map((e) => Transaction.fromJson(e, 'loan'))
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
      totalDepositAmount: json['total_deposit_amount']?.toString() ?? '',
      totalWithdrawalAmount: json['total_withdrawal_amount']?.toString() ?? '',
      finalBalance: json['final_balance']?.toString() ?? '',
      transactions: (json['transactions'] as List?)
              ?.map((e) => Transaction.fromJson(e, 'saving'))
              .toList() ??
          [],
    );
  }
}

class Transaction {
  final String transactionDate;
  final String amount;
  final String outstanding;
  final String type; // 'loan' or 'saving'

  Transaction({
    required this.transactionDate,
    required this.amount,
    required this.outstanding,
    required this.type,
  });

  factory Transaction.fromJson(Map<String, dynamic> json, String type) {
    if (type == 'loan') {
      return Transaction(
        transactionDate: json['transaction_date'] ?? '',
        amount: json['transaction_amount']?.toString() ?? '',
        outstanding: json['outstanding_after_transaction']?.toString() ?? '',
        type: type,
      );
    } else {
      return Transaction(
        transactionDate: json['transaction_date'] ?? '',
        amount: json['deposit_amount']?.toString() ?? '',
        outstanding: json['balance']?.toString() ?? '',
        type: type,
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'transaction_date': transactionDate,
      'amount': amount,
      'outstanding': outstanding,
      'type': type,
    };
  }
}
