import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/features/splash_screen.dart';
import 'core/features/otp_screen.dart';
import 'core/features/home_screen.dart';
import 'core/features/sign_up.dart'; // added
import 'core/providers/member_provider.dart';
import 'core/providers/splash_provider.dart';
import 'dart:developer' as developer;
import 'core/database/db_helper.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showSplash = ref.watch(splashProvider);

    return MaterialApp(
      title: 'CDIP Connect',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: showSplash ? const SplashScreen() : const SplashOrLogin(),
      routes: {
        '/signup': (context) => const SignUpScreen(), // changed: signup route
        '/login': (context) => const OTPScreen(phone: '', msgId: ''),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}

// Simple local storage helper to avoid null LocalStorage reference
class LocalStorage {
  LocalStorage._();

  static Future<SharedPreferences> _prefs() async =>
      await SharedPreferences.getInstance();

  static Future<String?> getMemberId() async {
    final prefs = await _prefs();
    return prefs.getString('member_id');
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await _prefs();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  static Future<String?> getMemberJson() async {
    final prefs = await _prefs();
    return prefs.getString('member');
  }
}

// SplashOrLogin widget for auto-login
class SplashOrLogin extends ConsumerStatefulWidget {
  const SplashOrLogin({super.key});
  @override
  ConsumerState<SplashOrLogin> createState() => _SplashOrLoginState();
}

class _SplashOrLoginState extends ConsumerState<SplashOrLogin> {
  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  // Updated: check 'isLoggedIn' flag and navigate accordingly.
  // Also log SharedPreferences and latest DB member for debugging.
  Future<void> _checkLogin() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // 1) Log SharedPreferences contents (safe for dev)
      debugPrint('--- SharedPreferences keys: ${prefs.getKeys()}');
      debugPrint('isLoggedIn: ${prefs.getBool('isLoggedIn')}');
      debugPrint('member_id: ${prefs.getString('member_id')}');
      debugPrint('member_phone: ${prefs.getString('member_phone')}');
      debugPrint('member (json): ${prefs.getString('member')}');

      // 2) Log latest DB member row
      try {
        final latest = await DBHelper.getLatestMember();
        debugPrint('--- DB latest member row: $latest');
        if (latest != null && latest['data'] != null) {
          try {
            final data = jsonDecode(latest['data']);
            debugPrint(
                '--- DB latest member.data parsed.name: ${data['name']}');
          } catch (e) {
            debugPrint('DB member data parse error: $e');
          }
        }
      } catch (e) {
        debugPrint('DB access error: $e');
      }

      // 3) Decide navigation
      final loggedIn = prefs.getBool('isLoggedIn') ?? false;
      if (loggedIn) {
        // prefer member json name if available
        String memberName = '';
        final memberJson = prefs.getString('member');
        if (memberJson != null && memberJson.isNotEmpty) {
          try {
            final Map<String, dynamic> m = jsonDecode(memberJson);
            memberName = (m['name'] ?? '').toString();
          } catch (e) {
            debugPrint('member json parse error: $e');
          }
        }

        // navigate to Home and clear back stack
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen(memberName: memberName)),
        );
      } else {
        // go to sign up (phone input) for first-time or logged-out users
        Navigator.pushReplacementNamed(context, '/signup');
      }
    } catch (e) {
      debugPrint('SplashOrLogin _checkLogin error: $e');
      Navigator.pushReplacementNamed(context, '/signup');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
