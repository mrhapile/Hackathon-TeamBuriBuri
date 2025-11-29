import 'package:flutter/material.dart';
import '../theme.dart';

class SoftCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  const SoftCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin,
        padding: padding ?? const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: UniRankTheme.cardBg,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [UniRankTheme.softShadow],
        ),
        child: child,
      ),
    );
  }
}
