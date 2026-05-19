import 'package:flutter/material.dart';

class AppBackButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Color color;
  final double size;
  final double touchSize;

  const AppBackButton({
    super.key,
    this.onTap,
    this.color = Colors.black,
    this.size = 26,
    this.touchSize = 44,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap ?? () => Navigator.maybePop(context),
        borderRadius: BorderRadius.circular(touchSize / 2),
        child: SizedBox(
          width: touchSize,
          height: touchSize,
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: color,
            size: size,
          ),
        ),
      ),
    );
  }
}
