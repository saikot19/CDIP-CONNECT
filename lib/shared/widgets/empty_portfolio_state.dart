import 'package:cdip_connect/core/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EmptyPortfolioState extends StatelessWidget {
  final String title;
  final String message;
  final IconData fallbackIcon;

  const EmptyPortfolioState({
    super.key,
    required this.title,
    required this.message,
    this.fallbackIcon = Icons.inbox_outlined,
  });

  static const String _emptyStateLottieUrl =
      'https://lottie.host/7eaea7b5-827f-498e-9006-0d7274b9a4f9/sQ7SJC8zki.json';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 180,
              height: 180,
              child: Lottie.network(
                _emptyStateLottieUrl,
                repeat: true,
                animate: true,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) =>
                    _FallbackAnimation(icon: fallbackIcon),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.textPrimary(context),
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.textSecondary(context),
                fontSize: 13,
                fontWeight: FontWeight.w400,
                height: 1.35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FallbackAnimation extends StatefulWidget {
  final IconData icon;

  const _FallbackAnimation({required this.icon});

  @override
  State<_FallbackAnimation> createState() => _FallbackAnimationState();
}

class _FallbackAnimationState extends State<_FallbackAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _scale = Tween<double>(begin: 0.92, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: Container(
        decoration: const ShapeDecoration(
          color: Color(0xFFEAF6FC),
          shape: OvalBorder(),
        ),
        child: Icon(
          widget.icon,
          color: const Color(0xFF0880C6),
          size: 72,
        ),
      ),
    );
  }
}
