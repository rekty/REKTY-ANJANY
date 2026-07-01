import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_duration.dart';
import '../../../core/constants/app_breakpoints.dart';

class NavLogo extends StatefulWidget {
  const NavLogo({super.key});

  @override
  State<NavLogo> createState() => _NavLogoState();
}

class _NavLogoState extends State<NavLogo> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    // Use screen width instead of device detection
    final screenWidth = MediaQuery.of(context).size.width;
    final useCompactLayout = screenWidth < 800;
    
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
                width: useCompactLayout ? 12 : 16,
                height: useCompactLayout ? 12 : 16,
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

              SizedBox(width: useCompactLayout ? 8 : 12),

              AnimatedDefaultTextStyle(
                duration: AppDuration.hover,
                style: TextStyle(
                  color: _hover
                      ? AppColors.primary
                      : AppColors.textPrimary,
                  fontSize: useCompactLayout ? 16 : 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: useCompactLayout ? 0.5 : 1.2,
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