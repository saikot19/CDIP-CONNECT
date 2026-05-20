import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'app_toast.dart';
import 'app_theme.dart';

class AppFeedback {
  const AppFeedback._();

  static const String _logoutWarningLottie =
      'https://assets2.lottiefiles.com/packages/lf20_jbrw3hcz.json';
  static const String _exitWarningLottie =
      'https://assets2.lottiefiles.com/packages/lf20_jbrw3hcz.json';

  static void comingSoon(BuildContext context, String featureName) {
    AppToast.showInfo('$featureName is currently unavailable. It will be available in a future update.');
  }



  static Future<bool> confirmExit(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: AppTheme.elevatedSurface(context),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 118,
                  child: Lottie.network(
                    _exitWarningLottie,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.exit_to_app_rounded,
                      size: 70,
                      color: Color(0xFF0880C6),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Close CDIP Connect?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppTheme.textPrimary(context),
                    fontSize: 21,
                                        fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Are you sure you want to close the app?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppTheme.textSecondary(context),
                    fontSize: 14,
                                      ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context, false),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF21409A)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('Stay'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF21409A),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('Close'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    return result ?? false;
  }

  static Future<bool> confirmLogout(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: AppTheme.elevatedSurface(context),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 120,
                  child: Lottie.network(
                    _logoutWarningLottie,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.logout_rounded,
                      size: 70,
                      color: Color(0xFFFF5733),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Are you sure?',
                  style: TextStyle(
                    color: AppTheme.textPrimary(context),
                    fontSize: 22,
                                        fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'You will need to sign in again to access your account.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppTheme.textSecondary(context),
                    fontSize: 14,
                                      ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context, false),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF21409A)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF5733),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('Log Out'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    return result ?? false;
  }
}
