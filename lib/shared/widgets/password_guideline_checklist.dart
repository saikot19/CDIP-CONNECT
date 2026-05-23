import 'package:flutter/material.dart';

class PasswordGuidelineChecklist extends StatelessWidget {
  final String password;
  final String? confirmPassword;
  final bool showMatchRule;

  const PasswordGuidelineChecklist({
    super.key,
    required this.password,
    this.confirmPassword,
    this.showMatchRule = false,
  });

  bool get _hasMinLength => password.length >= 6;
  bool get _hasNoSpaces => password.isNotEmpty && !password.contains(RegExp(r'\s'));
  bool get _hasUppercase => RegExp(r'[A-Z]').hasMatch(password);
  bool get _hasLowercase => RegExp(r'[a-z]').hasMatch(password);
  bool get _hasNumber => RegExp(r'\d').hasMatch(password);
  bool get _hasSpecial => RegExp(r'[^A-Za-z0-9]').hasMatch(password);
  bool get _matchesConfirm =>
      !showMatchRule ||
      (confirmPassword != null &&
          confirmPassword!.isNotEmpty &&
          password == confirmPassword);

  double get progress {
    final checks = [
      _hasMinLength,
      _hasNoSpaces,
      _hasUppercase,
      _hasLowercase,
      _hasNumber,
      _hasSpecial,
      if (showMatchRule) _matchesConfirm,
    ];
    return checks.where((item) => item).length / checks.length;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF17202A) : const Color(0xFFF4FAFE);
    final border = isDark ? const Color(0xFF254156) : const Color(0xFFE0F1FA);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: isDark ? const Color(0xFF2D3748) : const Color(0xFFE2E8F0),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0880C6)),
            ),
          ),
          const SizedBox(height: 10),
          _RuleRow(passed: _hasMinLength, text: 'At least 6 characters', requiredRule: true),
          _RuleRow(passed: _hasNoSpaces, text: 'No spaces', requiredRule: true),
          _RuleRow(passed: _hasUppercase, text: 'Uppercase letter recommended'),
          _RuleRow(passed: _hasLowercase, text: 'Lowercase letter recommended'),
          _RuleRow(passed: _hasNumber, text: 'Number recommended'),
          _RuleRow(passed: _hasSpecial, text: 'Special character recommended'),
          if (showMatchRule)
            _RuleRow(passed: _matchesConfirm, text: 'Passwords match', requiredRule: true),
        ],
      ),
    );
  }
}

class _RuleRow extends StatelessWidget {
  final bool passed;
  final String text;
  final bool requiredRule;

  const _RuleRow({
    required this.passed,
    required this.text,
    this.requiredRule = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final inactive = isDark ? const Color(0xFFCBD5E1) : const Color(0xFF64748B);
    final active = requiredRule ? const Color(0xFF0880C6) : const Color(0xFF05A300);
    final border = passed ? active : (isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8));

    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 17,
            height: 17,
            decoration: BoxDecoration(
              color: passed ? active : Colors.transparent,
              border: Border.all(color: border),
              shape: BoxShape.circle,
            ),
            child: passed
                ? const Icon(Icons.check, color: Colors.white, size: 12)
                : null,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: passed ? active : inactive,
                fontSize: 12,
                fontWeight: passed ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
