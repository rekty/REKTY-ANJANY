import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_radius.dart';
import '../../core/constants/app_shadow.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/services/supabase_service.dart';
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
  final _supabase = SupabaseService.instance;
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
      final response = await _supabase.signInWithEmail(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (response.user != null) {
        // Login berhasil
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login successful! Welcome back.'),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
            ),
          );
          context.go('/');
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = _getErrorMessage(e.toString());
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_errorMessage!),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 4),
          ),
        );
      }
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
      await _supabase.client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'https://your-website.com/', // Ganti dengan URL website kamu
      );
      // OAuth akan redirect otomatis
    } catch (e) {
      setState(() {
        _errorMessage = 'Google login failed: ${e.toString()}';
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_errorMessage!),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
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
      await _supabase.client.auth.signInWithOAuth(
        OAuthProvider.github,
        redirectTo: 'https://your-website.com/', // Ganti dengan URL website kamu
      );
      // OAuth akan redirect otomatis
    } catch (e) {
      setState(() {
        _errorMessage = 'GitHub login failed: ${e.toString()}';
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_errorMessage!),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
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
      await _supabase.client.auth.signInWithOAuth(
        OAuthProvider.facebook,
        redirectTo: 'https://your-website.com/', // Ganti dengan URL website kamu
      );
      // OAuth akan redirect otomatis
    } catch (e) {
      setState(() {
        _errorMessage = 'Facebook login failed: ${e.toString()}';
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_errorMessage!),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  String _getErrorMessage(String error) {
    if (error.contains('Invalid login credentials')) {
      return 'Email atau password salah';
    } else if (error.contains('Email not confirmed')) {
      return 'Email belum dikonfirmasi. Cek inbox email kamu.';
    } else if (error.contains('User not found')) {
      return 'Akun tidak ditemukan. Silakan register terlebih dahulu.';
    } else if (error.contains('network')) {
      return 'Koneksi internet bermasalah';
    }
    return 'Login gagal: ${error.replaceAll('Exception:', '').trim()}';
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    const _LoginLogo(),

                    const SizedBox(height: AppSpacing.massive),

                    // Card
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

                    // Back to Home
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

            // Error message
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

            // Email
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

            // Password
            TextFormField(
              controller: passwordController,
              style: const TextStyle(color: AppColors.textPrimary),
              obscureText: obscure,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle:
                    const TextStyle(color: AppColors.textSecondary),
                hintText: '••••••••',
                hintStyle:
                    const TextStyle(color: AppColors.textDisabled),
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

            // Forgot password
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

            // Login button
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

            // Divider
            const Row(
              children: [
                Expanded(
                    child: Divider(color: AppColors.border, height: 1)),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.md),
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

            // OAuth buttons - Row 1
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

            // OAuth buttons - Row 2 (Facebook)
            SizedBox(
              width: double.infinity,
              child: _OAuthButton(
                icon: Icons.facebook_rounded,
                label: 'Continue with Facebook',
                onPressed: loading ? null : onFacebookLogin,
                color: const Color(0xFF1877F2),
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // Register
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account? ",
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                GestureDetector(
                  onTap: () {},
                  child: const Text(
                    'Register',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
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
