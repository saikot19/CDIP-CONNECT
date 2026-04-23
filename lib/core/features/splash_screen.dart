import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      final isLoggedIn = await AuthService.isLoggedIn();

      if (!isLoggedIn) {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(builder: (_) => const SignUpScreen()),
        );
        return;
      }

      final LoginResponse? loginResponse = await AuthService.getLoginResponse();

      final hasValidCache = loginResponse != null &&
          loginResponse.status == 200 &&
          loginResponse.userData.id.isNotEmpty;

      if (hasValidCache) {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(builder: (_) => const HomeScreen()),
        );
      } else {
        await AuthService.logout();

        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(builder: (_) => const SignUpScreen()),
        );
      }
    } catch (e) {
      print('❌ Error in splash: $e');

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(builder: (_) => const SignUpScreen()),
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
                  'assets/logo/App Splash Screen-8.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
