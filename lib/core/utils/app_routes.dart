import 'dart:math' as math;

import 'package:flutter/material.dart';

enum AppTransitionType { ios, fadeSlide, scaleFade, modal }

class AppRoutes {
  const AppRoutes._();

  static Route<T> route<T>(
    Widget page, {
    AppTransitionType type = AppTransitionType.ios,
    Duration duration = const Duration(milliseconds: 430),
  }) {
    return PageRouteBuilder<T>(
      transitionDuration: duration,
      reverseTransitionDuration: const Duration(milliseconds: 330),
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );

        switch (type) {
          case AppTransitionType.fadeSlide:
            return FadeTransition(
              opacity: curved,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.05, 0.03),
                  end: Offset.zero,
                ).animate(curved),
                child: child,
              ),
            );
          case AppTransitionType.scaleFade:
            return FadeTransition(
              opacity: curved,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.96, end: 1).animate(curved),
                child: child,
              ),
            );
          case AppTransitionType.modal:
            return FadeTransition(
              opacity: curved,
              child: SlideTransition(
                position: Tween<Offset>(begin: const Offset(0, 0.10), end: Offset.zero).animate(curved),
                child: child,
              ),
            );
          case AppTransitionType.ios:
            final begin = Directionality.of(context) == TextDirection.rtl
                ? const Offset(-1, 0)
                : const Offset(1, 0);
            final slide = Tween<Offset>(begin: begin, end: Offset.zero).animate(curved);
            final parallax = Tween<Offset>(
              begin: Offset.zero,
              end: Offset(-begin.dx * 0.18, 0),
            ).animate(CurvedAnimation(parent: secondaryAnimation, curve: Curves.easeOutCubic));
            return SlideTransition(
              position: parallax,
              child: SlideTransition(
                position: slide,
                child: FadeTransition(
                  opacity: Tween<double>(begin: 0.92, end: 1).animate(curved),
                  child: child,
                ),
              ),
            );
        }
      },
    );
  }

  static Route<T> randomPremium<T>(Widget page) {
    final values = AppTransitionType.values;
    final index = DateTime.now().millisecondsSinceEpoch % values.length;
    return route<T>(page, type: values[math.max(0, index)]);
  }
}
