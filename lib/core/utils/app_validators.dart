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
    if (value.isEmpty) return 'Please enter your password.';
    if (value.length < 6) return 'Password must be at least 6 characters.';
    if (value.length > 64) return 'Password is too long.';
    if (value.contains(RegExp(r'\s'))) {
      return 'Password cannot contain spaces.';
    }
    return null;
  }

  static String? newPassword(String value) {
    if (value.isEmpty) return 'Please enter a new password.';
    if (value.length < 6) return 'Password must be at least 6 characters.';
    if (value.length > 64) return 'Password is too long.';
    if (value.contains(RegExp(r'\s'))) {
      return 'Password cannot contain spaces.';
    }
    return null;
  }

  static String? confirmPassword(String password, String confirmPassword) {
    final passwordError = newPassword(password);
    if (passwordError != null) return passwordError;

    if (confirmPassword.isEmpty) return 'Please confirm your password.';
    if (password != confirmPassword) {
      return 'Password and confirm password do not match.';
    }
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
