// lib/core/services/localization_service.dart
import 'package:cdip_connect/core/utils/app_formatters.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

final localizationProvider =
    StateNotifierProvider<LocalizationNotifier, String>((ref) {
  return LocalizationNotifier();
});

class LocalizationNotifier extends StateNotifier<String> {
  static const String _languageKey = 'language';
  static const String _legacyLanguageKey = 'language_code';

  LocalizationNotifier() : super('en') {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final lang = prefs.getString(_languageKey) ??
        prefs.getString(_legacyLanguageKey) ??
        'en';
    if (lang == 'bn' || lang == 'en') {
      state = lang;
    }
  }

  Future<void> changeLanguage(String lang) async {
    final normalized = lang == 'bn' ? 'bn' : 'en';
    state = normalized;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, normalized);
    await prefs.setString(_legacyLanguageKey, normalized);
  }

  bool get isBangla => state == 'bn';
  bool get isEnglish => state == 'en';
}

class AppLocalizations {
  final String locale;

  AppLocalizations(this.locale);

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // Common
      'app_name': 'CDIP Connect',
      'sign_up': 'SIGN UP',
      'proceed': 'PROCEED',
      'verify_now': 'VERIFY NOW',
      'sign_in': 'Sign In',
      'phone_number_label': 'Phone Number',
      'password': 'Password',
      'send_otp': 'SEND OTP',
      'powered_by': 'Powered By ',
      'already_have_account': 'Have already any account? ',
      'update_password': 'UPDATE PASSWORD',
      'continue_to_home': 'CONTINUE TO HOME PAGE',

      // Home Screen
      'good_morning': 'Good Morning,',
      'good_afternoon': 'Good Afternoon,',
      'good_evening': 'Good Evening,',
      'good_night': 'Good Night,',
      'app_up_to_date': 'App is up to date',
      'new_version_available': 'New version available. Please update!',
      'unable_to_load_portfolio': 'Unable to load portfolio data',
      'portfolio_summary': 'Your Portfolio Summary',
      'manage_portfolio': 'Manage Portfolio',
      'outstanding': 'Outstanding',
      'total_outstanding': 'Total Outstanding',
      'total_savings': 'Total Savings',
      'total_due_amount': 'Total Due Amount',
      'no_of_loans': 'No. of Loans',
      'no_of_savings': 'No. of Savings',
      'no_of_due_loans': 'No. of Due Loans',
      'overdue': 'Overdue',
      'savings': 'Savings',
      'loan': 'Loan',
      'referral': 'Referral',

      // Portfolio
      'loan_portfolio': 'Loan Portfolio',
      'savings_portfolio': 'Savings Portfolio',
      'active_loan': 'Active Loan',
      'closed_loan': 'Closed Loan',
      'active_savings': 'Active Savings',
      'closed_savings': 'Closed Savings',
      'transactions_last_updated_on': 'Transactions Last Updated on',
      'sync_pending': 'Sync pending',
      'no_active_loans_title': 'No active loans yet',
      'no_closed_loans_title': 'No closed loans yet',
      'no_active_savings_title': 'No active savings yet',
      'no_closed_savings_title': 'No closed savings yet',
      'no_active_loans_message': 'When you have an active loan, it will appear here.',
      'no_closed_loans_message': 'Closed loan records will appear here once available.',
      'no_active_savings_message': 'When you have an active savings account, it will appear here.',
      'no_closed_savings_message': 'Closed savings accounts will appear here once available.',
      'loan_product': 'Loan Product',
      'savings_product': 'Savings Product',
      'disbursement_date': 'Disbursement Date',
      'disbursement_amount': 'Disbursement Amount',
      'opening_date': 'Opening Date',
      'recovered': 'Recovered',
      'total_savings_amount': 'Total Savings Amount',
      'loan_portfolio_details': 'Loan Portfolio Details',
      'saving_portfolio_details': 'Saving Portfolio Details',
      'transaction_date': 'Transaction\nDate',
      'transaction_amount': 'Transaction\nAmount',
      'deposit_amount': 'Deposit\nAmount',
      'withdraw_amount': 'Withdraw\nAmount',
      'no_transactions_available': 'No transactions available',

      // Profile
      'my_profile': 'My Profile',
      'member_code': 'Member Code',
      'branch_name': 'Branch Name',
      'my_portfolio': 'My Portfolio',
      'change_language': 'Change Language',
      'application_history': 'Application History',
      'manage_address': 'Manage Address',
      'rate_us': 'Rate Us',
      'share_app': 'Share App',
      'about_us': 'About Us',
      'privacy_policy': 'Privacy Policy',
      'terms_condition': 'Terms & Condition',
      'logout': 'Logout',

      // Auth
      'otp_verification': 'OTP Verification',
      'set_password': 'Set Your Password',
      'reset_password': 'Reset Password',
      'password_reset': 'Password Reset',
      'type_password': 'Type Password',
      'current_password': 'Current Password',
      'new_password': 'New Password',
      'confirm_password': 'Confirm New Password',
      'forgot_password': 'Forgot Password?',
      'reset_password_link': 'Reset Password',
      'phone_number': 'Give Your Phone Number',
      'have_account': 'Have already any account ?',
      'resend_code': 'Resend Code',
      'seconds_remaining': 'seconds remaining',
      'password_reset_success': 'Your password has been reset successfully',

      // Common Words
      'bdt': 'BDT',
    },
    'bn': {
      // Common
      'app_name': 'সিডিআইপি কানেক্ট',
      'sign_up': 'সাইন আপ',
      'proceed': 'এগিয়ে যান',
      'sign_in': 'সাইন ইন',
      'phone_number_label': 'ফোন নম্বর',
      'password': 'পাসওয়ার্ড',
      'send_otp': 'ওটিপি পাঠান',
      'powered_by': 'পাওয়ার্ড বাই ',
      'already_have_account': 'ইতিমধ্যে অ্যাকাউন্ট আছে? ',
      'verify_now': 'এখনই যাচাই করুন',
      'update_password': 'পাসওয়ার্ড আপডেট করুন',
      'continue_to_home': 'হোম পেজে চলুন',

      // Home Screen
      'good_morning': 'সুপ্রভাত,',
      'good_afternoon': 'শুভ অপরাহ্ন,',
      'good_evening': 'শুভ সন্ধ্যা,',
      'good_night': 'শুভ রাত্রি,',
      'app_up_to_date': 'অ্যাপ আপডেটেড আছে',
      'new_version_available': 'নতুন ভার্সন পাওয়া যাচ্ছে। অনুগ্রহ করে আপডেট করুন।',
      'unable_to_load_portfolio': 'পোর্টফোলিও তথ্য লোড করা যায়নি',
      'portfolio_summary': 'আপনার পোর্টফোলিও সারাংশ',
      'manage_portfolio': 'পোর্টফোলিও পরিচালনা',
      'outstanding': 'বকেয়া',
      'total_outstanding': 'মোট বকেয়া',
      'total_savings': 'মোট সঞ্চয়',
      'total_due_amount': 'মোট বকেয়া পরিমাণ',
      'no_of_loans': 'ঋণের সংখ্যা',
      'no_of_savings': 'সঞ্চয়ের সংখ্যা',
      'no_of_due_loans': 'বকেয়া ঋণের সংখ্যা',
      'overdue': 'অতিবাহিত',
      'savings': 'সঞ্চয়',
      'loan': 'ঋণ',
      'referral': 'রেফারেল',

      // Portfolio
      'loan_portfolio': 'ঋণ পোর্টফোলিও',
      'savings_portfolio': 'সঞ্চয় পোর্টফোলিও',
      'active_loan': 'সক্রিয় ঋণ',
      'closed_loan': 'বন্ধ ঋণ',
      'active_savings': 'সক্রিয় সঞ্চয়',
      'closed_savings': 'বন্ধ সঞ্চয়',
      'transactions_last_updated_on': 'লেনদেন সর্বশেষ আপডেট',
      'sync_pending': 'সিঙ্ক অপেক্ষমাণ',
      'no_active_loans_title': 'কোনো সক্রিয় ঋণ নেই',
      'no_closed_loans_title': 'কোনো বন্ধ ঋণ নেই',
      'no_active_savings_title': 'কোনো সক্রিয় সঞ্চয় নেই',
      'no_closed_savings_title': 'কোনো বন্ধ সঞ্চয় নেই',
      'no_active_loans_message': 'আপনার সক্রিয় ঋণ থাকলে এখানে দেখাবে।',
      'no_closed_loans_message': 'বন্ধ ঋণের তথ্য পাওয়া গেলে এখানে দেখাবে।',
      'no_active_savings_message': 'আপনার সক্রিয় সঞ্চয় থাকলে এখানে দেখাবে।',
      'no_closed_savings_message': 'বন্ধ সঞ্চয়ের তথ্য পাওয়া গেলে এখানে দেখাবে।',
      'loan_product': 'ঋণ পণ্য',
      'savings_product': 'সঞ্চয় পণ্য',
      'disbursement_date': 'বিতরণের তারিখ',
      'disbursement_amount': 'বিতরণের পরিমাণ',
      'opening_date': 'খোলার তারিখ',
      'recovered': 'পুনরুদ্ধার',
      'total_savings_amount': 'মোট সঞ্চয় পরিমাণ',
      'loan_portfolio_details': 'ঋণ পোর্টফোলিও বিস্তারিত',
      'saving_portfolio_details': 'সঞ্চয় পোর্টফোলিও বিস্তারিত',
      'transaction_date': 'লেনদেনের\nতারিখ',
      'transaction_amount': 'লেনদেনের\nপরিমাণ',
      'deposit_amount': 'জমার\nপরিমাণ',
      'withdraw_amount': 'উত্তোলনের\nপরিমাণ',
      'no_transactions_available': 'কোনো লেনদেন নেই',

      // Profile
      'my_profile': 'আমার প্রোফাইল',
      'member_code': 'সদস্য কোড',
      'branch_name': 'শাখার নাম',
      'my_portfolio': 'আমার পোর্টফোলিও',
      'change_language': 'ভাষা পরিবর্তন করুন',
      'application_history': 'আবেদন ইতিহাস',
      'manage_address': 'ঠিকানা পরিচালনা',
      'rate_us': 'আমাদের রেট করুন',
      'share_app': 'অ্যাপ শেয়ার করুন',
      'about_us': 'আমাদের সম্পর্কে',
      'privacy_policy': 'গোপনীয়তা নীতি',
      'terms_condition': 'নিয়ম এবং শর্ত',
      'logout': 'লগআউট',

      // Auth
      'otp_verification': 'OTP যাচাইকরণ',
      'set_password': 'আপনার পাসওয়ার্ড সেট করুন',
      'reset_password': 'পাসওয়ার্ড রিসেট করুন',
      'password_reset': 'পাসওয়ার্ড রিসেট',
      'type_password': 'পাসওয়ার্ড টাইপ করুন',
      'current_password': 'বর্তমান পাসওয়ার্ড',
      'new_password': 'নতুন পাসওয়ার্ড',
      'confirm_password': 'নতুন পাসওয়ার্ড নিশ্চিত করুন',
      'forgot_password': 'পাসওয়ার্ড ভুলে গেছেন?',
      'reset_password_link': 'পাসওয়ার্ড রিসেট করুন',
      'phone_number': 'আপনার ফোন নম্বর দিন',
      'have_account': 'ইতিমধ্যে একটি অ্যাকাউন্ট আছে?',
      'resend_code': 'কোড পুনরায় পাঠান',
      'seconds_remaining': 'সেকেন্ড বাকি',
      'password_reset_success': 'আপনার পাসওয়ার্ড সফলভাবে রিসেট করা হয়েছে',

      // Common Words
      'bdt': 'টাকা',
    },
  };

  static var delegate;

  String translate(String key) {
    return _localizedValues[locale]?[key] ?? key;
  }

  String get appName => translate('app_name');
  String get signUp => translate('sign_up');
  String get signIn => translate('sign_in');
  String get proceed => translate('proceed');
  String get verifyNow => translate('verify_now');
  String get updatePassword => translate('update_password');
  String get phoneNumberLabel => translate('phone_number_label');
  String get password => translate('password');
  String get sendOtp => translate('send_otp');
  String get poweredBy => translate('powered_by');
  String get alreadyHaveAccount => translate('already_have_account');
  String get forgotPassword => translate('forgot_password');
  String get otpVerification => translate('otp_verification');
  String get resendCode => translate('resend_code');
  String get setPassword => translate('set_password');
  String get typePassword => translate('type_password');
  String get resetPassword => translate('reset_password');
  String get newPassword => translate('new_password');
  String get confirmPassword => translate('confirm_password');

  // Home
  String get goodMorning => translate('good_morning');
  String get goodAfternoon => translate('good_afternoon');
  String get goodEvening => translate('good_evening');
  String get goodNight => translate('good_night');
  String get appUpToDate => translate('app_up_to_date');
  String get newVersionAvailable => translate('new_version_available');
  String get unableToLoadPortfolio => translate('unable_to_load_portfolio');
  String get portfolioSummary => translate('portfolio_summary');
  String get managePortfolio => translate('manage_portfolio');
  String get outstanding => translate('outstanding');
  String get totalOutstanding => translate('total_outstanding');
  String get totalSavings => translate('total_savings');
  String get totalDueAmount => translate('total_due_amount');
  String get noOfLoans => translate('no_of_loans');
  String get noOfSavings => translate('no_of_savings');
  String get noOfDueLoans => translate('no_of_due_loans');
  String get overdue => translate('overdue');
  String get savings => translate('savings');
  String get loan => translate('loan');
  String get referral => translate('referral');

  // Portfolio
  String get loanPortfolio => translate('loan_portfolio');
  String get savingsPortfolio => translate('savings_portfolio');
  String get activeLoan => translate('active_loan');
  String get closedLoan => translate('closed_loan');
  String get activeSavings => translate('active_savings');
  String get closedSavings => translate('closed_savings');
  String get transactionsLastUpdatedOn => translate('transactions_last_updated_on');
  String get syncPending => translate('sync_pending');
  String get noActiveLoansTitle => translate('no_active_loans_title');
  String get noClosedLoansTitle => translate('no_closed_loans_title');
  String get noActiveSavingsTitle => translate('no_active_savings_title');
  String get noClosedSavingsTitle => translate('no_closed_savings_title');
  String get noActiveLoansMessage => translate('no_active_loans_message');
  String get noClosedLoansMessage => translate('no_closed_loans_message');
  String get noActiveSavingsMessage => translate('no_active_savings_message');
  String get noClosedSavingsMessage => translate('no_closed_savings_message');
  String get loanProduct => translate('loan_product');
  String get savingsProduct => translate('savings_product');
  String get disbursementDate => translate('disbursement_date');
  String get disbursementAmount => translate('disbursement_amount');
  String get openingDate => translate('opening_date');
  String get recovered => translate('recovered');
  String get totalSavingsAmount => translate('total_savings_amount');
  String get loanPortfolioDetails => translate('loan_portfolio_details');
  String get savingPortfolioDetails => translate('saving_portfolio_details');
  String get transactionDate => translate('transaction_date');
  String get transactionAmount => translate('transaction_amount');
  String get depositAmount => translate('deposit_amount');
  String get withdrawAmount => translate('withdraw_amount');
  String get noTransactionsAvailable => translate('no_transactions_available');

  // Profile
  String get myProfile => translate('my_profile');
  String get memberCode => translate('member_code');
  String get branchName => translate('branch_name');
  String get myPortfolio => translate('my_portfolio');
  String get changeLanguage => translate('change_language');
  String get applicationHistory => translate('application_history');
  String get manageAddress => translate('manage_address');
  String get rateUs => translate('rate_us');
  String get shareApp => translate('share_app');
  String get aboutUs => translate('about_us');
  String get privacyPolicy => translate('privacy_policy');
  String get termsCondition => translate('terms_condition');
  String get logout => translate('logout');

  String get bdt => translate('bdt');
  String get fontFamily => locale == 'bn' ? 'Anek Bangla' : 'Proxima Nova';

  String digits(dynamic value) => AppFormatters.digits(value);

  String transactionCountNote(int count) {
    if (locale == 'bn') {
      return 'শেষ ${AppFormatters.digits(count)}টি লেনদেন দেখানো হচ্ছে।';
    }
    final noun = count == 1 ? 'transaction is' : 'transactions are';
    return 'Last ${AppFormatters.digits(count)} $noun showing.';
  }
}

