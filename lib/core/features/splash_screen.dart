import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/database_helper.dart';
import '../models/login_response_model.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';
import 'sign_up.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _checkLoginStatus();
    });
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 2));

    try {
      print('🔄 Checking login status...');

      final isLoggedIn = await AuthService.isLoggedIn();

      if (isLoggedIn) {
        print('✅ User is logged in');

        final memberName = await AuthService.getMemberName();
        final allSummary = await AuthService.getUserAllSummary();

        print(
            '📊 Loaded: ${allSummary.loans.length} loans, ${allSummary.savings.length} savings');

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomeScreen(
              memberName: memberName,
              allSummary: allSummary,
            ),
          ),
        );
      } else {
        print('⚠️ User not logged in');

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const SignUpScreen()),
        );
      }
    } catch (e) {
      print('❌ Error in splash: $e');
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SignUpScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 412,
        height: 917,
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(color: Colors.white),
        child: Stack(
          children: [
            Positioned(
              left: 101,
              top: 372,
              child: SizedBox(
                width: 210,
                height: 173.94,
                child: Image.asset(
                  'assets/logo/Logo.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Center(
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}
