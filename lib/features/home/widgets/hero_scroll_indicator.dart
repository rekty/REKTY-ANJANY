import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';

class HeroScrollIndicator extends StatefulWidget {
  const HeroScrollIndicator({super.key});

  @override
  State<HeroScrollIndicator> createState() =>
      _HeroScrollIndicatorState();
}

class _HeroScrollIndicatorState
    extends State<HeroScrollIndicator>
    with SingleTickerProviderStateMixin {

  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0,
      end: 12,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _scrollDown() {
    // Scroll to next section (approximately one viewport height)
    final scrollController = PrimaryScrollController.of(context);
    
    // Debug log
    debugPrint('🔵 Scroll Down clicked!');
    
    if (scrollController != null && scrollController.hasClients) {
      final viewportHeight = MediaQuery.of(context).size.height;
      final targetPosition = viewportHeight * 0.9;
      
      debugPrint('🔵 Scrolling to: $targetPosition');
      
      scrollController.animateTo(
        targetPosition,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    } else {
      debugPrint('❌ ScrollController not available');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          debugPrint('🔵 InkWell tapped!');
          _scrollDown();
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: AnimatedBuilder(
            animation: _animation,
            builder: (_, __) {
              return Transform.translate(
                offset: Offset(
                  0,
                  _animation.value,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Scroll Down",
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                        letterSpacing: 1.2,
                      ),
                    ),

                    const SizedBox(
                      height: AppSpacing.sm,
                    ),

                    Icon(
                      Icons.keyboard_double_arrow_down_rounded,
                      color: AppColors.primary.withValues(alpha: .85),
                      size: 34,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}