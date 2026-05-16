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

  bool get _hasMinLength => password.trim().length >= 8;
  bool get _hasNoSpaces => password.isNotEmpty && !password.contains(RegExp(r'\s'));
  bool get _hasNumber => RegExp(r'\d').hasMatch(password);
  bool get _hasLetter => RegExp(r'[A-Za-z]').hasMatch(password);
  bool get _isNotRepeated => password.isNotEmpty && !RegExp(r'^(.)\1{7,}$').hasMatch(password);
  bool get _matchesConfirm =>
      !showMatchRule ||
      (confirmPassword != null &&
          confirmPassword!.trim().isNotEmpty &&
          password.trim() == confirmPassword!.trim());

  double get progress {
    final total = showMatchRule ? 6 : 5;
    final passed = [
      _hasMinLength,
      _hasLetter,
      _hasNumber,
      _hasNoSpaces,
      _isNotRepeated,
      if (showMatchRule) _matchesConfirm,
    ].where((item) => item).length;
    return passed / total;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF4FAFE),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE0F1FA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: const Color(0xFFE2E8F0),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0880C6)),
            ),
          ),
          const SizedBox(height: 10),
          _RuleRow(passed: _hasMinLength, text: 'At least 8 characters'),
          _RuleRow(passed: _hasLetter, text: 'Contains a letter'),
          _RuleRow(passed: _hasNumber, text: 'Contains a number'),
          _RuleRow(passed: _hasNoSpaces, text: 'No spaces'),
          _RuleRow(passed: _isNotRepeated, text: 'Not a repeated sequence'),
          if (showMatchRule)
            _RuleRow(passed: _matchesConfirm, text: 'Passwords match'),
        ],
      ),
    );
  }
}

class _RuleRow extends StatelessWidget {
  final bool passed;
  final String text;

  const _RuleRow({required this.passed, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 17,
            height: 17,
            decoration: BoxDecoration(
              color: passed ? const Color(0xFF0880C6) : Colors.transparent,
              border: Border.all(
                color: passed ? const Color(0xFF0880C6) : const Color(0xFF94A3B8),
              ),
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
                color: passed ? const Color(0xFF0880C6) : const Color(0xFF64748B),
                fontSize: 12,
                fontFamily: 'Proxima Nova',
                fontWeight: passed ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
