import 'package:flutter/material.dart';

class PasswordGuidelines extends StatelessWidget {
  final String password;
  final String? confirmPassword;

  const PasswordGuidelines({
    super.key,
    required this.password,
    this.confirmPassword,
  });

  @override
  Widget build(BuildContext context) {
    final checks = <_PasswordCheck>[
      _PasswordCheck('At least 6 characters', password.length >= 6, requiredRule: true),
      _PasswordCheck('No spaces', password.isNotEmpty && !password.contains(RegExp(r'\s')), requiredRule: true),
      _PasswordCheck('Uppercase letter recommended', RegExp(r'[A-Z]').hasMatch(password)),
      _PasswordCheck('Lowercase letter recommended', RegExp(r'[a-z]').hasMatch(password)),
      _PasswordCheck('Number recommended', RegExp(r'\d').hasMatch(password)),
      _PasswordCheck('Special character recommended', RegExp(r'[^A-Za-z0-9]').hasMatch(password)),
      if (confirmPassword != null)
        _PasswordCheck('Passwords match', password.isNotEmpty && password == confirmPassword, requiredRule: true),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: checks.map((check) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: check.passed ? const Color(0xFF05A300) : Colors.transparent,
                  border: Border.all(
                    color: check.passed ? const Color(0xFF05A300) : const Color(0xFFBDBDBD),
                  ),
                  shape: BoxShape.circle,
                ),
                child: check.passed
                    ? const Icon(Icons.check, size: 13, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  check.label,
                  style: TextStyle(
                    color: check.passed ? const Color(0xFF05A300) : const Color(0xFF6A6A6A),
                    fontSize: 12,
                    fontWeight: check.requiredRule ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _PasswordCheck {
  final String label;
  final bool passed;
  final bool requiredRule;

  const _PasswordCheck(this.label, this.passed, {this.requiredRule = false});
}
