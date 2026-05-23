class PasswordHasher {
  const PasswordHasher._();

  /// The backend expects the password as the exact user-entered string.
  /// Keep this method as a no-op for backward compatibility with older imports.
  static String forApi(String password) => password;
}
