import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppToast {
  const AppToast._();

  static void showError(String message) => _show(
        message,
        backgroundColor: Colors.red,
      );

  static void showSuccess(String message) => _show(
        message,
        backgroundColor: const Color(0xFF05A300),
      );

  static void showInfo(String message) => _show(
        message,
        backgroundColor: const Color(0xFF21409A),
      );


  static void showComingSoon(String featureName) => showInfo(
        '$featureName is coming soon. This feature will be available in a future update.',
      );

  static void _show(
    String message, {
    required Color backgroundColor,
  }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: backgroundColor,
      textColor: Colors.white,
      fontSize: 14,
    );
  }
}
