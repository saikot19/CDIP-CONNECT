import 'package:cdip_connect/core/services/localization_service.dart';
import 'package:cdip_connect/core/utils/app_formatters.dart';
import 'package:cdip_connect/features/onboarding/presentation/screens/common_screen.dart';
import 'package:cdip_connect/features/splash/application/splash_provider.dart';
import 'package:cdip_connect/features/splash/presentation/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CdipConnectApp extends ConsumerWidget {
  const CdipConnectApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showSplash = ref.watch(splashProvider);
    final languageCode = ref.watch(localizationProvider);
    AppFormatters.setLocale(languageCode);
    final appFontFamily = AppFormatters.appFontFamily;

    return MaterialApp(
      title: 'CDIP Connect',
      locale: Locale(languageCode),
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      builder: (context, child) {
        return DefaultTextStyle.merge(
          style: TextStyle(fontFamily: appFontFamily),
          child: child ?? const SizedBox.shrink(),
        );
      },
      theme: ThemeData(
        fontFamily: appFontFamily,
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        fontFamily: appFontFamily,
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0880C6),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF101418),
        useMaterial3: true,
      ),
      home: showSplash ? const SplashScreen() : const CommonScreen(),
    );
  }
}
