import 'package:flutter/material.dart';

/// Mesh Gradient Background
/// Modern, trendy background dengan multiple color spots
/// Inspired by iOS 18, macOS, Figma
/// STATIC - No animation, tidak mengganggu scroll
class MeshGradientBackground extends StatelessWidget {
  final Widget child;

  const MeshGradientBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0a0e27), // Deep dark blue-black (match with app background)
      ),
      child: Stack(
        children: [
          // All background glows wrapped in IgnorePointer
          IgnorePointer(
            child: Stack(
              children: [
                // Top-left glow (Purple/Violet) - DARKER
                Positioned(
                  top: 100,
                  left: -150,
                  child: Container(
                    width: 700,
                    height: 700,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFF8B5CF6).withValues(alpha: 0.12), // Violet - MUCH darker
                          const Color(0xFF8B5CF6).withValues(alpha: 0.06),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                ),

                // Top-right glow (Cyan/Blue) - DARKER
                Positioned(
                  top: 50,
                  right: -200,
                  child: Container(
                    width: 800,
                    height: 800,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFF06B6D4).withValues(alpha: 0.10), // Cyan - MUCH darker
                          const Color(0xFF06B6D4).withValues(alpha: 0.05),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                ),

                // Bottom-right glow (Blue) - DARKER
                Positioned(
                  bottom: 150,
                  right: -100,
                  child: Container(
                    width: 750,
                    height: 750,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFF3B82F6).withValues(alpha: 0.12), // Blue - MUCH darker
                          const Color(0xFF3B82F6).withValues(alpha: 0.06),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                ),

                // Bottom-left glow (Pink/Rose) - DARKER
                Positioned(
                  bottom: 100,
                  left: -150,
                  child: Container(
                    width: 700,
                    height: 700,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFFEC4899).withValues(alpha: 0.10), // Pink - MUCH darker
                          const Color(0xFFEC4899).withValues(alpha: 0.05),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                ),

                // Center glow (Indigo) - DARKER
                Positioned(
                  top: 200,
                  left: 100,
                  child: Container(
                    width: 600,
                    height: 600,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFF6366F1).withValues(alpha: 0.08), // Indigo - MUCH darker
                          const Color(0xFF6366F1).withValues(alpha: 0.04),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Subtle overlay for depth - also ignore pointer
          IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.3), // Darker overlay
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.4), // Darker overlay
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),

          // Content - can receive pointer events
          child,
        ],
      ),
    );
  }
}
