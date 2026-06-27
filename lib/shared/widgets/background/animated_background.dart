// Animated background wrapper
import 'package:flutter/material.dart';

import 'floating_blobs.dart';
import 'glow_background.dart';
import 'grid_background.dart';

class AnimatedBackground extends StatelessWidget {
  final Widget child;

  const AnimatedBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GlowBackground(
      child: FloatingBlobs(
        child: GridBackground(
          child: child,
        ),
      ),
    );
  }
}