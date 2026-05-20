import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static bool isDark(BuildContext context) => Theme.of(context).brightness == Brightness.dark;

  static Color scaffold(BuildContext context) =>
      isDark(context) ? const Color(0xFF101418) : const Color(0xFFF6F6F6);

  static Color authScaffold(BuildContext context) =>
      isDark(context) ? const Color(0xFF101418) : Colors.white;

  static Color surface(BuildContext context) =>
      isDark(context) ? const Color(0xFF171C22) : Colors.white;

  static Color elevatedSurface(BuildContext context) =>
      isDark(context) ? const Color(0xFF1F2630) : Colors.white;

  static Color textPrimary(BuildContext context) =>
      isDark(context) ? const Color(0xFFF2F4F7) : const Color(0xFF1E1E1E);

  static Color textSecondary(BuildContext context) =>
      isDark(context) ? const Color(0xFFD0D5DD) : const Color(0xFF3A3A3A);

  static Color mutedText(BuildContext context) =>
      isDark(context) ? const Color(0xFFA9B2C0) : const Color(0xFF6B7280);

  static Color divider(BuildContext context) =>
      isDark(context) ? const Color(0xFF313A46) : const Color(0xFFE5E7EB);

  static Color inputFill(BuildContext context) =>
      isDark(context) ? const Color(0xFF171C22) : Colors.white;

  static BoxShadow cardShadow(BuildContext context) => BoxShadow(
        color: isDark(context) ? Colors.black.withOpacity(0.30) : const Color(0x19000000),
        blurRadius: 18,
        offset: const Offset(0, 4),
      );
}
