class AppValidators {
  const AppValidators._();

  static String? bangladeshPhone(String value) {
    final phone = value.trim();
    if (phone.isEmpty) return 'Please enter your phone number.';
    if (!RegExp(r'^01\d{9}$').hasMatch(phone)) {
      return 'Enter a valid 11-digit Bangladesh number starting with 01.';
    }
    return null;
  }

  static String? password(String value) {
    final password = value.trim();
    if (password.isEmpty) return 'Please enter your password.';
    if (password.length < 6) return 'Password must be at least 6 characters.';
    return null;
  }

  static String? otp(String value) {
    final code = value.trim();
    if (code.isEmpty) return 'Please enter the OTP code.';
    if (!RegExp(r'^\d{6}$').hasMatch(code)) {
      return 'Please enter the 6-digit OTP sent to your phone.';
    }
    return null;
  }
}
