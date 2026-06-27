import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_duration.dart';

class NavLogo extends StatefulWidget {
  const NavLogo({super.key});

  @override
  State<NavLogo> createState() => _NavLogoState();
}

class _NavLogoState extends State<NavLogo> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: () => context.go('/'),
        child: AnimatedScale(
          duration: AppDuration.hover,
          scale: _hover ? 1.05 : 1.0,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: AppDuration.hover,
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  boxShadow: _hover
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.7),
                            blurRadius: 20,
                            spreadRadius: 3,
                          ),
                        ]
                      : [],
                ),
              ),

              const SizedBox(width: 12),

              AnimatedDefaultTextStyle(
                duration: AppDuration.hover,
                style: TextStyle(
                  color: _hover
                      ? AppColors.primary
                      : AppColors.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
                child: const Text("REKTY ANJANY"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}