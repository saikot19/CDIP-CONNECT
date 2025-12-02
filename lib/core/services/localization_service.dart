// lib/core/services/localization_service.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final localizationProvider =
    StateNotifierProvider<LocalizationNotifier, String>((ref) {
  return LocalizationNotifier();
});

class LocalizationNotifier extends StateNotifier<String> {
  final _storage = const FlutterSecureStorage();

  LocalizationNotifier() : super('en') {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final lang = await _storage.read(key: 'language');
    if (lang != null) {
      state = lang;
    }
  }

  Future<void> changeLanguage(String lang) async {
    state = lang;
    await _storage.write(key: 'language', value: lang);
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
      'update_password': 'UPDATE PASSWORD',
      'continue_to_home': 'CONTINUE TO HOME PAGE',

      // Home Screen
      'good_morning': 'Good Morning,',
      'portfolio_summary': 'Your Portfolio Summary',
      'manage_portfolio': 'Manage Portfolio',
      'outstanding': 'Outstanding',
      'overdue': 'Overdue',
      'savings': 'Savings',
      'loan': 'Loan',
      'referral': 'Referral',

      // Portfolio
      'loan_portfolio': 'Loan Portfolio',
      'savings_portfolio': 'Savings Portfolio',
      'loan_product': 'Loan Product',
      'savings_product': 'Savings Product',
      'disbursement_date': 'Disbursement Date',
      'disbursement_amount': 'Disbursement Amount',
      'opening_date': 'Opening Date',
      'recovered': 'Recovered',
      'total_savings_amount': 'Total Savings Amount',

      // Profile
      'my_profile': 'My Profile',
      'member_code': 'Member Code',
      'branch_name': 'Branch Name',
      'my_portfolio': 'My Portfolio',
      'change_language': 'Change Language',
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
      'verify_now': 'এখনই যাচাই করুন',
      'update_password': 'পাসওয়ার্ড আপডেট করুন',
      'continue_to_home': 'হোম পেজে চলুন',

      // Home Screen
      'good_morning': 'সুপ্রভাত,',
      'portfolio_summary': 'আপনার পোর্টফোলিও সারাংশ',
      'manage_portfolio': 'পোর্টফোলিও পরিচালনা',
      'outstanding': 'বকেয়া',
      'overdue': 'অতিবাহিত',
      'savings': 'সঞ্চয়',
      'loan': 'ঋণ',
      'referral': 'রেফারেল',

      // Portfolio
      'loan_portfolio': 'ঋণ পোর্টফোলিও',
      'savings_portfolio': 'সঞ্চয় পোর্টফোলিও',
      'loan_product': 'ঋণ পণ্য',
      'savings_product': 'সঞ্চয় পণ্য',
      'disbursement_date': 'বিতরণের তারিখ',
      'disbursement_amount': 'বিতরণের পরিমাণ',
      'opening_date': 'খোলার তারিখ',
      'recovered': 'পুনরুদ্ধার',
      'total_savings_amount': 'মোট সঞ্চয় পরিমাণ',

      // Profile
      'my_profile': 'আমার প্রোফাইল',
      'member_code': 'সদস্য কোড',
      'branch_name': 'শাখার নাম',
      'my_portfolio': 'আমার পোর্টফোলিও',
      'change_language': 'ভাষা পরিবর্তন করুন',
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
  String get proceed => translate('proceed');
  String get verifyNow => translate('verify_now');

  // Home
  String get goodMorning => translate('good_morning');
  String get portfolioSummary => translate('portfolio_summary');
  String get managePortfolio => translate('manage_portfolio');
  String get outstanding => translate('outstanding');
  String get overdue => translate('overdue');
  String get savings => translate('savings');
  String get loan => translate('loan');
  String get referral => translate('referral');

  // Portfolio
  String get loanPortfolio => translate('loan_portfolio');
  String get savingsPortfolio => translate('savings_portfolio');
  String get loanProduct => translate('loan_product');
  String get savingsProduct => translate('savings_product');
  String get disbursementDate => translate('disbursement_date');
  String get disbursementAmount => translate('disbursement_amount');
  String get openingDate => translate('opening_date');
  String get recovered => translate('recovered');
  String get totalSavingsAmount => translate('total_savings_amount');

  // Profile
  String get myProfile => translate('my_profile');
  String get memberCode => translate('member_code');
  String get branchName => translate('branch_name');
  String get myPortfolio => translate('my_portfolio');
  String get changeLanguage => translate('change_language');
  String get manageAddress => translate('manage_address');
  String get rateUs => translate('rate_us');
  String get shareApp => translate('share_app');
  String get aboutUs => translate('about_us');
  String get privacyPolicy => translate('privacy_policy');
  String get termsCondition => translate('terms_condition');
  String get logout => translate('logout');

  String get bdt => translate('bdt');
}
