import 'package:cdip_connect/core/utils/app_navigation.dart';
import 'package:cdip_connect/features/auth/application/auth_service.dart';
import 'package:cdip_connect/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:cdip_connect/features/dashboard/presentation/screens/home_screen.dart';
import 'package:cdip_connect/features/onboarding/presentation/screens/common_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _splashController;

  bool _hasNavigated = false;
  bool _animationLoaded = false;

  @override
  void initState() {
    super.initState();

    _splashController = AnimationController(vsync: this);

    // Fallback: if Lottie fails to load or takes too long,
    // the app will still continue.
    Future.delayed(const Duration(seconds: 5), () {
      if (!_hasNavigated && mounted) {
        _goToNextScreen();
      }
    });
  }

  Future<void> _playSplashOnceAndNavigate(Duration animationDuration) async {
    if (_animationLoaded || _hasNavigated) return;

    _animationLoaded = true;

    _splashController
      ..duration = animationDuration
      ..reset();

    try {
      await _splashController.forward();
    } catch (_) {
      // Ignore animation controller errors if widget is disposed.
    }

    if (!mounted || _hasNavigated) return;

    await _goToNextScreen();
  }

  Future<void> _goToNextScreen() async {
    if (_hasNavigated) return;

    _hasNavigated = true;

    try {
      final rememberedPhone = await AuthService.getRememberedPhone();
      final shouldRestoreDashboard =
          await AuthService.shouldRestoreDashboardAfterBackground();

      if (!mounted) return;

      if (shouldRestoreDashboard) {
        AppNavigation.replace(
          context,
          const HomeScreen(),
        );
      } else if (rememberedPhone.isNotEmpty) {
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

      AppNavigation.replace(
        context,
        const CommonScreen(),
      );
    }
  }

  @override
  void dispose() {
    _splashController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final logoWidth = (size.width * 0.52).clamp(170.0, 230.0);
    final logoHeight = logoWidth * 0.83;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
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
                'https://lottie.host/50a87ce1-a6d2-4d33-b5bb-f52ac305509f/Y50TJfZ6y0.json',
                controller: _splashController,
                repeat: false,
                animate: false,
                fit: BoxFit.contain,
                onLoaded: (composition) {
                  _playSplashOnceAndNavigate(composition.duration);
                },
                errorBuilder: (context, error, stackTrace) {
                  Future.delayed(const Duration(milliseconds: 1800), () {
                    if (!_hasNavigated && mounted) {
                      _goToNextScreen();
                    }
                  });

                  return Image.asset(
                    'assets/logo/App Splash Screen-8.png',
                    fit: BoxFit.contain,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
