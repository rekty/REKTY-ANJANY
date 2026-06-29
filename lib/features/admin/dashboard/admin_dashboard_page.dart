import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/services/admin_service.dart';
import '../../../core/services/supabase_auth_service.dart';
import 'package:go_router/go_router.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  final _adminService = AdminService.instance;
  final _authService = SupabaseAuthService.instance;
  Map<String, dynamic> _stats = {};
  bool _loading = true;
  bool _checkingAuth = true;

  @override
  void initState() {
    super.initState();
    _checkAdminAccess();
  }

  Future<void> _checkAdminAccess() async {
    print('🔍 [DEBUG] Starting admin access check...');
    
    // TEMPORARY: Skip auth check for testing
    print('⚠️ [DEBUG] SKIPPING AUTH CHECK FOR TESTING');
    setState(() => _checkingAuth = false);
    _loadStats();
    return;
    
    /* Original auth check - commented out for testing
    // Check if user is logged in
    final user = _authService.currentUser;
    print('🔍 [DEBUG] Current user: $user');
    
    if (user == null) {
      print('❌ [DEBUG] No user found, redirecting to login');
      // Not logged in, redirect to login
      if (mounted) {
        context.go('/login?redirect=/admin');
      }
      return;
    }

    // Set access token
    final token = _authService.accessToken;
    print('🔍 [DEBUG] Access token: ${token?.substring(0, 20)}...');
    
    if (token != null) {
      _adminService.setAccessToken(token);
    } else {
      print('⚠️ [DEBUG] No access token found!');
    }

    // Check if user is admin
    final userEmail = user['email'] ?? '';
    print('🔍 [DEBUG] Checking if email is admin: $userEmail');
    
    final isAdmin = await _adminService.isAdmin(userEmail);
    print('🔍 [DEBUG] isAdmin result: $isAdmin');
    
    if (!isAdmin) {
      print('❌ [DEBUG] User is NOT admin, redirecting to home');
      // Not admin, redirect to home
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Access denied: Admin privileges required'),
            backgroundColor: Colors.red,
          ),
        );
        context.go('/');
      }
      return;
    }

    print('✅ [DEBUG] User is admin! Loading stats...');
    // User is admin, load stats
    setState(() => _checkingAuth = false);
    _loadStats();
    */
  }

  Future<void> _loadStats() async {
    setState(() => _loading = true);
    try {
      final stats = await _adminService.getDashboardStats();
      setState(() {
        _stats = stats;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading stats: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_checkingAuth) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xxxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dashboard',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Welcome to your admin panel',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  onPressed: _loadStats,
                  icon: const Icon(Icons.refresh_rounded, color: AppColors.primary),
                  tooltip: 'Refresh',
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.xxxl),

            // Stats Cards
            if (_loading)
              const Center(child: CircularProgressIndicator())
            else
              Wrap(
                spacing: AppSpacing.xl,
                runSpacing: AppSpacing.xl,
                children: [
                  _StatCard(
                    icon: Icons.apps_rounded,
                    label: 'Total Apps',
                    value: _stats['apps_count']?.toString() ?? '0',
                    color: const Color(0xFF818CF8),
                  ),
                  _StatCard(
                    icon: Icons.download_rounded,
                    label: 'Downloads',
                    value: _stats['downloads_count']?.toString() ?? '0',
                    color: const Color(0xFF34D399),
                  ),
                  _StatCard(
                    icon: Icons.store_rounded,
                    label: 'Products',
                    value: _stats['products_count']?.toString() ?? '0',
                    color: const Color(0xFFF59E0B),
                  ),
                  _StatCard(
                    icon: Icons.photo_library_rounded,
                    label: 'Gallery Items',
                    value: _stats['gallery_count']?.toString() ?? '0',
                    color: const Color(0xFFEC4899),
                  ),
                  _StatCard(
                    icon: Icons.article_rounded,
                    label: 'Blog Posts',
                    value: _stats['blog_count']?.toString() ?? '0',
                    color: const Color(0xFF8B5CF6),
                  ),
                  _StatCard(
                    icon: Icons.mail_rounded,
                    label: 'Messages',
                    value: _stats['messages_count']?.toString() ?? '0',
                    color: const Color(0xFF06B6D4),
                    badge: _stats['unread_messages'] > 0
                        ? _stats['unread_messages'].toString()
                        : null,
                  ),
                ],
              ),

            const SizedBox(height: AppSpacing.xxxl),

            // Quick Actions
            const Text(
              'Quick Actions',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            Wrap(
              spacing: AppSpacing.lg,
              runSpacing: AppSpacing.lg,
              children: [
                _ActionButton(
                  icon: Icons.add_rounded,
                  label: 'New App',
                  onTap: () {
                    // TODO: Navigate to create app
                  },
                ),
                _ActionButton(
                  icon: Icons.upload_rounded,
                  label: 'Upload File',
                  onTap: () {
                    // TODO: Navigate to upload
                  },
                ),
                _ActionButton(
                  icon: Icons.edit_rounded,
                  label: 'New Blog Post',
                  onTap: () {
                    // TODO: Navigate to create blog
                  },
                ),
                _ActionButton(
                  icon: Icons.image_rounded,
                  label: 'Add Image',
                  onTap: () {
                    // TODO: Navigate to gallery upload
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final String? badge;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.badge,
  });

  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 220,
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: AppRadius.card,
          border: Border.all(
            color: _hover ? widget.color.withValues(alpha: 0.5) : AppColors.border,
          ),
          boxShadow: _hover
              ? [
                  BoxShadow(
                    color: widget.color.withValues(alpha: 0.1),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: widget.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    widget.icon,
                    color: widget.color,
                    size: 24,
                  ),
                ),
                if (widget.badge != null) ...[
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      widget.badge!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              widget.value,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: _hover ? AppColors.primary : AppColors.card,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _hover ? AppColors.primary : AppColors.border,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                color: _hover ? Colors.black : AppColors.textPrimary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: TextStyle(
                  color: _hover ? Colors.black : AppColors.textPrimary,
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
