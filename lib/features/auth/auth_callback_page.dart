import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:html' as html;

import '../../core/constants/app_colors.dart';
import '../../core/services/supabase_auth_service.dart';
import '../../shared/widgets/background/mesh_gradient_background.dart';

/// OAuth Callback Page
/// Handles redirect from OAuth providers (Google, GitHub, Facebook)
/// Parses access_token from URL and saves session
class AuthCallbackPage extends StatefulWidget {
  const AuthCallbackPage({super.key});

  @override
  State<AuthCallbackPage> createState() => _AuthCallbackPageState();
}

class _AuthCallbackPageState extends State<AuthCallbackPage> {
  bool _processing = true;
  String _message = 'Memproses login...';
  bool _success = false;
  final _auth = SupabaseAuthService.instance;

  @override
  void initState() {
    super.initState();
    _handleCallback();
  }

  Future<void> _handleCallback() async {
    setState(() {
      _processing = true;
      _message = 'Processing login...';
    });

    try {
      // Parse URL untuk access_token
      final currentUrl = html.window.location.href;
      final uri = Uri.parse(currentUrl);
      
      String? accessToken;
      String? refreshToken;
      
      // Parse fragment (hash) parameters
      if (uri.fragment.isNotEmpty) {
        final fragmentParams = Uri.splitQueryString(uri.fragment);
        accessToken = fragmentParams['access_token'];
        refreshToken = fragmentParams['refresh_token'];
      }
      
      // Save session if token found
      if (accessToken != null && accessToken.isNotEmpty) {
        await _auth.saveOAuthSession(accessToken);
        
        setState(() {
          _success = true;
          _processing = false;
          _message = 'Login successful! Redirecting...';
        });
        
        // Wait a bit then redirect
        await Future.delayed(const Duration(milliseconds: 1500));
        
        // Redirect to home using go_router
        if (mounted) {
          context.go('/');
        }
      } else {
        // No token found
        setState(() {
          _success = false;
          _processing = false;
          _message = 'No authentication token found. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        _success = false;
        _processing = false;
        _message = 'Error processing login: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MeshGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 480),
          padding: const EdgeInsets.all(32),
          child: Card(
            color: AppColors.card,
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: _success 
                    ? AppColors.success.withValues(alpha: 0.3)
                    : _processing
                        ? AppColors.primary.withValues(alpha: 0.3)
                        : AppColors.error.withValues(alpha: 0.3),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(48),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon
                  if (_processing)
                    const SizedBox(
                      width: 64,
                      height: 64,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: AppColors.primary,
                      ),
                    )
                  else if (_success)
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.success,
                        size: 48,
                      ),
                    )
                  else
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.error_rounded,
                        color: AppColors.error,
                        size: 48,
                      ),
                    ),
                  
                  const SizedBox(height: 32),
                  
                  // Title
                  Text(
                    _processing 
                        ? 'Memproses Login'
                        : _success
                            ? 'Login Berhasil!'
                            : 'Login Gagal',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Message
                  Text(
                    _message,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  if (!_processing) ...[
                    const SizedBox(height: 32),
                    
                    // Manual redirect button
                    TextButton(
                      onPressed: () {
                        html.window.location.href = 'https://rekty-anjany-5a2eb.web.app/#/';
                      },
                      child: const Text(
                        'Go to Home',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    ),
    );
  }
}
