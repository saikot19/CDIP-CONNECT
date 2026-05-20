import 'package:cdip_connect/core/providers/theme_mode_provider.dart';
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
    final themeMode = ref.watch(appThemeModeProvider);
    AppFormatters.setLocale(languageCode);
    final appFontFamily = AppFormatters.appFontFamily;

    return MaterialApp(
      title: 'CDIP Connect',
      locale: Locale(languageCode),
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      builder: (context, child) {
        return DefaultTextStyle.merge(
          style: TextStyle(fontFamily: appFontFamily),
          child: child ?? const SizedBox.shrink(),
        );
      },
      theme: ThemeData(
        fontFamily: appFontFamily,
        scaffoldBackgroundColor: const Color(0xFFF6F6F6),
        cardColor: Colors.white,
        dialogBackgroundColor: Colors.white,
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(color: Color(0xFF3A3A3A)),
          hintStyle: TextStyle(color: Color(0xFF6B7280)),
        ),
        textTheme: ThemeData.light().textTheme.apply(
              fontFamily: appFontFamily,
              bodyColor: const Color(0xFF1E1E1E),
              displayColor: const Color(0xFF1E1E1E),
            ),
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
        scaffoldBackgroundColor: const Color(0xFF101418),
        cardColor: const Color(0xFF171C22),
        dialogBackgroundColor: const Color(0xFF1F2630),
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(color: Color(0xFFD0D5DD)),
          hintStyle: TextStyle(color: Color(0xFFA9B2C0)),
        ),
        textTheme: ThemeData.dark().textTheme.apply(
              fontFamily: appFontFamily,
              bodyColor: const Color(0xFFF2F4F7),
              displayColor: const Color(0xFFF2F4F7),
            ),
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
        useMaterial3: true,
      ),
      home: showSplash ? const SplashScreen() : const CommonScreen(),
    );
  }
}
