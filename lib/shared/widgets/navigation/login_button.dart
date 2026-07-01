import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_duration.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_shadow.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_breakpoints.dart';
import '../../../core/services/supabase_auth_service.dart';

class LoginButton extends StatefulWidget {
  const LoginButton({super.key});

  @override
  State<LoginButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> {
  bool _hover = false;
  bool _isLoggedIn = false;
  final _auth = SupabaseAuthService.instance;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() {
    setState(() {
      _isLoggedIn = _auth.isAuthenticated;
    });
  }

  Future<void> _logout() async {
    try {
      await _auth.signOut();
      if (mounted) {
        setState(() {
          _isLoggedIn = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Logout successful'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
        context.go('/');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logout failed: $e'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use screen width instead of device detection
    final screenWidth = MediaQuery.of(context).size.width;
    final useCompactLayout = screenWidth < 800;
    
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
          onPressed: _isLoggedIn
              ? _logout
              : () {
                  context.go('/login');
                },
          icon: Icon(
            _isLoggedIn ? Icons.logout_rounded : Icons.login_rounded,
            size: useCompactLayout ? 16 : 20,
          ),
          label: Text(
            _isLoggedIn ? 'Logout' : 'Login',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: useCompactLayout ? 13 : 15,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor:
                _hover ? AppColors.primaryHover : AppColors.primary,
            foregroundColor: Colors.black,
            elevation: 0,
            padding: EdgeInsets.symmetric(
              horizontal: useCompactLayout ? AppSpacing.md : AppSpacing.xl,
              vertical: useCompactLayout ? AppSpacing.sm : AppSpacing.lg,
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