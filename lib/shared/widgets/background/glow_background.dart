import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class GlowBackground extends StatelessWidget {
  final Widget child;

  const GlowBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [

        /// Top Right Glow
        Positioned(
          top: -250,
          right: -250,
          child: _Glow(
            size: 600,
            color: AppColors.primary.withValues(alpha: 0.15),
          ),
        ),

        /// Bottom Left Glow
        Positioned(
          bottom: -300,
          left: -250,
          child: _Glow(
            size: 700,
            color: AppColors.accent.withValues(alpha: 0.08),
          ),
        ),

        /// Center Glow
        Align(
          alignment: Alignment.center,
          child: _Glow(
            size: 500,
            color: AppColors.primary.withValues(alpha: 0.05),
          ),
        ),

        child,
      ],
    );
  }
}

class _Glow extends StatelessWidget {
  final double size;
  final Color color;

  const _Glow({
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color,
              color.withValues(alpha: 0.02),
              Colors.transparent,
            ],
            stops: const [
              0.0,
              0.6,
              1.0,
            ],
          ),
        ),
      ),
    );
  }
}