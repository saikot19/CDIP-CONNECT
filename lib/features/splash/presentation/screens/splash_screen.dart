import 'package:cdip_connect/core/utils/app_navigation.dart';
import 'package:cdip_connect/features/auth/application/auth_service.dart';
import 'package:cdip_connect/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:cdip_connect/features/onboarding/presentation/screens/common_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

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
      await _checkStartupRoute();
    });
  }

  Future<void> _checkStartupRoute() async {
    await Future.delayed(const Duration(milliseconds: 3800));

    try {
      final rememberedPhone = await AuthService.getRememberedPhone();

      if (!mounted) return;

      if (rememberedPhone.isNotEmpty) {
        AppNavigation.replace(
          context,
          SignInScreen(phone: rememberedPhone),
        );
      } else {
        AppNavigation.replace(
          context,
          const CommonScreen(),
        );
      }
    } catch (e) {
      debugPrint('Error in splash: $e');
      if (!mounted) return;
      AppNavigation.replace(context, const CommonScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final logoWidth = (size.width * 0.52).clamp(170.0, 230.0);
    final logoHeight = logoWidth * 0.83;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.92, end: 1.0),
                duration: const Duration(milliseconds: 700),
                curve: Curves.easeOutBack,
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value.clamp(0.0, 1.0),
                    child: Transform.scale(
                      scale: value,
                      child: child,
                    ),
                  );
                },
                child: SizedBox(
                  width: logoWidth,
                  height: logoHeight,
                  child: Lottie.network(
                    'https://lottie.host/1f9dffdc-4151-4641-bf91-ea0663254005/GaUM85vBxQ.json',
                    repeat: false,
                    animate: true,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/logo/App Splash Screen-8.png',
                        fit: BoxFit.contain,
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
