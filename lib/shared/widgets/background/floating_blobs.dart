import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class FloatingBlobs extends StatefulWidget {
  final Widget child;

  const FloatingBlobs({
    super.key,
    required this.child,
  });

  @override
  State<FloatingBlobs> createState() => _FloatingBlobsState();
}

class _FloatingBlobsState extends State<FloatingBlobs>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) {
        final value = _controller.value;

        return Stack(
          children: [

            Positioned(
              top: 60 + math.sin(value * math.pi * 2) * 30,
              left: 80,
              child: const _Blob(
                size: 180,
                color: AppColors.primary,
                opacity: .08,
              ),
            ),

            Positioned(
              bottom: 120 + math.cos(value * math.pi * 2) * 40,
              right: 100,
              child: const _Blob(
                size: 240,
                color: AppColors.accent,
                opacity: .06,
              ),
            ),

            Positioned(
              top: 320 + math.sin(value * math.pi * 4) * 25,
              right: 250,
              child: const _Blob(
                size: 120,
                color: AppColors.primary,
                opacity: .05,
              ),
            ),

            Positioned(
              bottom: 260 + math.cos(value * math.pi * 3) * 20,
              left: 280,
              child: const _Blob(
                size: 140,
                color: AppColors.accent,
                opacity: .05,
              ),
            ),

            if (child != null) child,
          ],
        );
      },
    );
  }
}

class _Blob extends StatelessWidget {
  final double size;
  final Color color;
  final double opacity;

  const _Blob({
    required this.size,
    required this.color,
    required this.opacity,
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
              color.withValues(alpha: opacity),
              color.withValues(alpha: opacity * .5),
              Colors.transparent,
            ],
            stops: const [
              0,
              .55,
              1,
            ],
          ),
        ),
      ),
    );
  }
}