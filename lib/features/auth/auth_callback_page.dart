import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/constants/app_colors.dart';
import '../../core/services/supabase_auth_service.dart';
import '../../shared/widgets/background/mesh_gradient_background.dart';

/// OAuth Callback Page
/// Handles redirect from OAuth providers (Google, GitHub, Facebook)
/// The Supabase Flutter SDK automatically parses the URL fragment
/// and establishes the session when this page loads
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
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('🔍 [AuthCallback] Starting OAuth callback handling');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      
      // Wait a moment for Supabase SDK to process the URL fragment
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Check if user is now authenticated
      final currentUser = _auth.user;
      
      print('📊 [AuthCallback] Auth check result:');
      print('   User authenticated: ${currentUser != null}');
      if (currentUser != null) {
        print('   User email: ${currentUser.email}');
        print('   User ID: ${currentUser.id}');
      }
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      
      if (currentUser != null) {
        print('✅ [AuthCallback] OAuth login successful');
        
        setState(() {
          _success = true;
          _processing = false;
          _message = 'Login successful! Redirecting...';
        });
        
        // Wait a bit then redirect
        await Future.delayed(const Duration(milliseconds: 1500));
        
        print('✅ [AuthCallback] Redirecting to admin...');
        
        // Redirect to admin (clean URL)
        if (mounted) {
          context.go('/admin');
        }
      } else {
        // No session found - OAuth may have failed
        print('❌ [AuthCallback] No user session found after OAuth');
        
        setState(() {
          _success = false;
          _processing = false;
          _message = 'Login failed. Please try again.';
        });
      }
    } catch (e) {
      print('❌ [AuthCallback] Error: $e');
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
                      onPressed: () => context.go('/'),
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
