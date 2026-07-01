import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_radius.dart';
import '../../core/constants/app_shadow.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/services/supabase_auth_service.dart';
import '../../shared/widgets/background/animated_background.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = SupabaseAuthService.instance;
  bool _obscure = true;
  bool _loading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final response = await _auth.signInWithEmail(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (response['success'] == true) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login successful! Welcome back.'),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
            ),
          );
          
          // Check for redirect parameter in URL
          final uri = GoRouterState.of(context).uri;
          final redirectPath = uri.queryParameters['redirect'];
          
          // If there's a redirect parameter, use it; otherwise go to admin
          if (redirectPath != null && redirectPath.isNotEmpty) {
            context.go(redirectPath);
          } else {
            context.go('/admin');
          }
        }
      } else {
        setState(() {
          _errorMessage = response['message'] ?? 'Login failed';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
      });
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final response = await _auth.signInWithOAuth('google');
      if (response['success'] != true) {
        setState(() {
          _errorMessage = response['message'] ?? 'Google login failed';
        });
        if (mounted) {
          setState(() => _loading = false);
        }
      }
      // On web, signInWithOAuth automatically redirects, so no need to set window.location
    } catch (e) {
      setState(() {
        _errorMessage = 'Google login failed: $e';
      });
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _signInWithGitHub() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final response = await _auth.signInWithOAuth('github');
      if (response['success'] != true) {
        setState(() {
          _errorMessage = response['message'] ?? 'GitHub login failed';
        });
        if (mounted) {
          setState(() => _loading = false);
        }
      }
      // On web, signInWithOAuth automatically redirects, so no need to set window.location
    } catch (e) {
      setState(() {
        _errorMessage = 'GitHub login failed: $e';
      });
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _signInWithFacebook() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final response = await _auth.signInWithOAuth('facebook');
      if (response['success'] != true) {
        setState(() {
          _errorMessage = response['message'] ?? 'Facebook login failed';
        });
        if (mounted) {
          setState(() => _loading = false);
        }
      }
      // On web, signInWithOAuth automatically redirects, so no need to set window.location
    } catch (e) {
      setState(() {
        _errorMessage = 'Facebook login failed: $e';
      });
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const _LoginLogo(),
                  const SizedBox(height: AppSpacing.massive),
                  _LoginCard(
                    formKey: _formKey,
                    emailController: _emailController,
                    passwordController: _passwordController,
                    obscure: _obscure,
                    loading: _loading,
                    errorMessage: _errorMessage,
                    onToggleObscure: () =>
                        setState(() => _obscure = !_obscure),
                    onLogin: _login,
                    onGoogleLogin: _signInWithGoogle,
                    onGitHubLogin: _signInWithGitHub,
                    onFacebookLogin: _signInWithFacebook,
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  TextButton.icon(
                    onPressed: () => context.go('/'),
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    label: const Text(
                      'Back to Home',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginLogo extends StatelessWidget {
  const _LoginLogo();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: .12),
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primary.withValues(alpha: .30)),
            boxShadow: AppShadow.cyanGlow,
          ),
          child: const Icon(
            Icons.flutter_dash,
            color: AppColors.primary,
            size: 38,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        const Text(
          'REKTY ANJANY',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        const Text(
          'Sign in to your account',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.3),
            ),
          ),
          child: const Column(
            children: [
              Text(
                '👤 Public: Login via OAuth',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '🔐 Admin: Email/Password or OAuth',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LoginCard extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscure;
  final bool loading;
  final String? errorMessage;
  final VoidCallback onToggleObscure;
  final VoidCallback onLogin;
  final VoidCallback onGoogleLogin;
  final VoidCallback onGitHubLogin;
  final VoidCallback onFacebookLogin;

  const _LoginCard({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.obscure,
    required this.loading,
    this.errorMessage,
    required this.onToggleObscure,
    required this.onLogin,
    required this.onGoogleLogin,
    required this.onGitHubLogin,
    required this.onFacebookLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxxl),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: AppRadius.card,
        border: Border.all(
          color: AppColors.primary.withValues(alpha: .15),
        ),
        boxShadow: AppShadow.cyanGlow,
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Login',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.xxxl),
            if (errorMessage != null) ...[
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: .1),
                  borderRadius: AppRadius.card,
                  border: Border.all(
                    color: AppColors.error.withValues(alpha: .3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline_rounded,
                        color: AppColors.error, size: 20),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        errorMessage!,
                        style: const TextStyle(
                          color: AppColors.error,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
            TextFormField(
              controller: emailController,
              style: const TextStyle(color: AppColors.textPrimary),
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: AppColors.textSecondary),
                hintText: 'your@email.com',
                hintStyle: TextStyle(color: AppColors.textDisabled),
                prefixIcon: Icon(
                  Icons.email_outlined,
                  color: AppColors.textSecondary,
                ),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Email is required';
                if (!v.contains('@')) return 'Enter a valid email';
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.xl),
            TextFormField(
              controller: passwordController,
              style: const TextStyle(color: AppColors.textPrimary),
              obscureText: obscure,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: const TextStyle(color: AppColors.textSecondary),
                hintText: '••••••••',
                hintStyle: const TextStyle(color: AppColors.textDisabled),
                prefixIcon: const Icon(
                  Icons.lock_outline_rounded,
                  color: AppColors.textSecondary,
                ),
                suffixIcon: IconButton(
                  onPressed: onToggleObscure,
                  icon: Icon(
                    obscure
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Password is required';
                if (v.length < 6) return 'Minimum 6 characters';
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.md),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: loading ? null : onLogin,
                icon: loading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.black,
                        ),
                      )
                    : const Icon(Icons.login_rounded),
                label: Text(loading ? 'Signing in...' : 'Sign In'),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            const Row(
              children: [
                Expanded(
                    child: Divider(color: AppColors.border, height: 1)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: Text(
                    'or continue with',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ),
                Expanded(
                    child: Divider(color: AppColors.border, height: 1)),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            Row(
              children: [
                Expanded(
                  child: _OAuthButton(
                    icon: Icons.g_mobiledata_rounded,
                    label: 'Google',
                    onPressed: loading ? null : onGoogleLogin,
                    color: const Color(0xFFEA4335),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _OAuthButton(
                    icon: Icons.code_rounded,
                    label: 'GitHub',
                    onPressed: loading ? null : onGitHubLogin,
                    color: const Color(0xFF24292E),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: _OAuthButton(
                icon: Icons.facebook_rounded,
                label: 'Continue with Facebook',
                onPressed: loading ? null : onFacebookLogin,
                color: const Color(0xFF1877F2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OAuthButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final Color color;

  const _OAuthButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.color,
  });

  @override
  State<_OAuthButton> createState() => _OAuthButtonState();
}

class _OAuthButtonState extends State<_OAuthButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: OutlinedButton(
          onPressed: widget.onPressed,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            side: BorderSide(
              color: _hover
                  ? widget.color.withValues(alpha: .5)
                  : AppColors.border,
              width: 1.5,
            ),
            backgroundColor: _hover
                ? widget.color.withValues(alpha: .05)
                : Colors.transparent,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.icon,
                color: widget.color,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: TextStyle(
                  color: _hover ? widget.color : AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
