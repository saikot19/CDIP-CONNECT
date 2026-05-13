import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cdip_connect/shared/widgets/pre_auth_branding.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cdip_connect/features/auth/application/auth_service.dart';
import 'package:cdip_connect/features/dashboard/presentation/screens/home_screen.dart';
import 'package:cdip_connect/features/onboarding/presentation/screens/common_screen.dart';
import 'package:cdip_connect/shared/models/login_response_model.dart';

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
          CupertinoPageRoute(builder: (_) => const CommonScreen()),
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
          CupertinoPageRoute(builder: (_) => const CommonScreen()),
        );
      }
    } catch (e) {
      print('Error in splash: $e');

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(builder: (_) => const CommonScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(color: Colors.white),
        child: Stack(
          children: [
            const Positioned(
              right: 20,
              top: 32,
              child: PreAuthBranding(
                logoWidth: 52,
                logoHeight: 42,
                buttonWidth: 81,
                buttonHeight: 39,
              ),
            ),
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
