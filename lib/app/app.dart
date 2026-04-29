import 'package:cdip_connect/features/onboarding/presentation/screens/common_screen.dart';
import 'package:cdip_connect/features/splash/application/splash_provider.dart';
import 'package:cdip_connect/features/splash/presentation/screens/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CdipConnectApp extends ConsumerWidget {
  const CdipConnectApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showSplash = ref.watch(splashProvider);

    return MaterialApp(
      title: 'CDIP Connect',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: showSplash ? const SplashScreen() : const CommonScreen(),
    );
  }
}
