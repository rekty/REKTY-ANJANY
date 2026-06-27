import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_duration.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_shadow.dart';
import '../../../core/constants/app_spacing.dart';

class LoginButton extends StatefulWidget {
  const LoginButton({super.key});

  @override
  State<LoginButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: AppDuration.hover,
        decoration: BoxDecoration(
          borderRadius: AppRadius.button,
          boxShadow: _hover
              ? AppShadow.cyanGlowStrong
              : AppShadow.button,
        ),
        child: ElevatedButton.icon(
          onPressed: () {
            context.go('/login');
          },
          icon: const Icon(
            Icons.login_rounded,
            size: 20,
          ),
          label: const Text(
            'Login',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor:
                _hover ? AppColors.primaryHover : AppColors.primary,
            foregroundColor: Colors.black,
            elevation: 0,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xl,
              vertical: AppSpacing.lg,
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: AppRadius.button,
            ),
          ),
        ),
      ),
    );
  }
}