import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum RouteTransitionStyle {
  adaptive,
  cupertino,
  fadeScale,
  softRise,
  slideUp,
  modalSheet,
}

class AppNavigation {
  AppNavigation._();

  static int _transitionCursor = 0;

  static RouteTransitionStyle _resolveStyle(RouteTransitionStyle style) {
    if (style != RouteTransitionStyle.adaptive) return style;

    final styles = <RouteTransitionStyle>[
      RouteTransitionStyle.cupertino,
      RouteTransitionStyle.fadeScale,
      RouteTransitionStyle.softRise,
    ];

    final selected = styles[_transitionCursor % styles.length];
    _transitionCursor++;
    return selected;
  }

  static Route<T> smoothRoute<T>({
    required WidgetBuilder builder,
    RouteSettings? settings,
    RouteTransitionStyle style = RouteTransitionStyle.adaptive,
    bool fullscreenDialog = false,
  }) {
    final resolvedStyle = _resolveStyle(style);

    return PageRouteBuilder<T>(
      settings: settings,
      opaque: true,
      fullscreenDialog: fullscreenDialog,
      transitionDuration: _durationFor(resolvedStyle),
      reverseTransitionDuration: _reverseDurationFor(resolvedStyle),
      pageBuilder: (context, animation, secondaryAnimation) => builder(context),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return _buildTransition(
          resolvedStyle,
          animation,
          secondaryAnimation,
          child,
        );
      },
    );
  }

  static Duration _durationFor(RouteTransitionStyle style) {
    switch (style) {
      case RouteTransitionStyle.cupertino:
        return const Duration(milliseconds: 430);
      case RouteTransitionStyle.fadeScale:
        return const Duration(milliseconds: 360);
      case RouteTransitionStyle.softRise:
        return const Duration(milliseconds: 420);
      case RouteTransitionStyle.slideUp:
        return const Duration(milliseconds: 420);
      case RouteTransitionStyle.modalSheet:
        return const Duration(milliseconds: 460);
      case RouteTransitionStyle.adaptive:
        return const Duration(milliseconds: 400);
    }
  }

  static Duration _reverseDurationFor(RouteTransitionStyle style) {
    switch (style) {
      case RouteTransitionStyle.modalSheet:
        return const Duration(milliseconds: 280);
      default:
        return const Duration(milliseconds: 260);
    }
  }

  static Widget _buildTransition(
    RouteTransitionStyle style,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    switch (style) {
      case RouteTransitionStyle.cupertino:
        return CupertinoPageTransition(
          primaryRouteAnimation: animation,
          secondaryRouteAnimation: secondaryAnimation,
          linearTransition: false,
          child: child,
        );

      case RouteTransitionStyle.fadeScale:
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );
        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.975, end: 1).animate(curved),
            child: child,
          ),
        );

      case RouteTransitionStyle.softRise:
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutQuint,
          reverseCurve: Curves.easeInCubic,
        );
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.035),
              end: Offset.zero,
            ).animate(curved),
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.985, end: 1).animate(curved),
              child: child,
            ),
          ),
        );

      case RouteTransitionStyle.slideUp:
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.10),
            end: Offset.zero,
          ).animate(curved),
          child: FadeTransition(opacity: curved, child: child),
        );

      case RouteTransitionStyle.modalSheet:
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.16),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        );

      case RouteTransitionStyle.adaptive:
        return child;
    }
  }

  static Future<T?> push<T>(
    BuildContext context,
    Widget page, {
    RouteTransitionStyle style = RouteTransitionStyle.adaptive,
  }) {
    return Navigator.push<T>(
      context,
      smoothRoute<T>(builder: (_) => page, style: style),
    );
  }

  static Future<T?> replace<T, TO>(
    BuildContext context,
    Widget page, {
    RouteTransitionStyle style = RouteTransitionStyle.fadeScale,
  }) {
    return Navigator.pushReplacement<T, TO>(
      context,
      smoothRoute<T>(builder: (_) => page, style: style),
    );
  }

  static Future<T?> resetTo<T>(
    BuildContext context,
    Widget page, {
    RouteTransitionStyle style = RouteTransitionStyle.fadeScale,
  }) {
    return Navigator.pushAndRemoveUntil<T>(
      context,
      smoothRoute<T>(builder: (_) => page, style: style),
      (route) => false,
    );
  }
}
