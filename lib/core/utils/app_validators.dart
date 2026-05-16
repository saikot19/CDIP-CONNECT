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
    if (password.contains(RegExp(r'\s'))) {
      return 'Password cannot contain spaces.';
    }
    return null;
  }

  static String? newPassword(String value) {
    final password = value.trim();
    if (password.isEmpty) return 'Please enter a new password.';
    if (password.length < 8) {
      return 'Password must be at least 8 characters for better security.';
    }
    if (password.length > 64) return 'Password is too long.';
    if (password.contains(RegExp(r'\s'))) {
      return 'Password cannot contain spaces.';
    }
    if (!RegExp(r'[A-Za-z]').hasMatch(password)) {
      return 'Password must contain at least one letter.';
    }
    if (!RegExp(r'\d').hasMatch(password)) {
      return 'Password must contain at least one number.';
    }
    if (RegExp(r'^(.)\1{7,}$').hasMatch(password)) {
      return 'Please use a stronger password.';
    }
    return null;
  }

  static String? confirmPassword(String password, String confirmPassword) {
    final passwordError = newPassword(password);
    if (passwordError != null) return passwordError;

    if (confirmPassword.trim().isEmpty) return 'Please confirm your password.';
    if (password.trim() != confirmPassword.trim()) {
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
