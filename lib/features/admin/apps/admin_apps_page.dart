import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/services/admin_service.dart';
import '../../../core/services/supabase_auth_service.dart';
import 'package:go_router/go_router.dart';

class AdminAppsPage extends StatefulWidget {
  const AdminAppsPage({super.key});

  @override
  State<AdminAppsPage> createState() => _AdminAppsPageState();
}

class _AdminAppsPageState extends State<AdminAppsPage> {
  final _adminService = AdminService.instance;
  final _authService = SupabaseAuthService.instance;
  List<Map<String, dynamic>> _apps = [];
  bool _loading = true;
  bool _checkingAuth = true;

  @override
  void initState() {
    super.initState();
    _checkAdminAccess();
  }

  Future<void> _checkAdminAccess() async {
    final user = _authService.currentUser;
    
    if (user == null) {
      if (mounted) context.go('/login?redirect=/admin/apps');
      return;
    }

    if (_authService.accessToken != null) {
      _adminService.setAccessToken(_authService.accessToken!);
    }

    final isAdmin = await _adminService.isAdmin(user['email'] ?? '');
    
    if (!isAdmin) {
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

    setState(() => _checkingAuth = false);
    _loadApps();
  }

  Future<void> _loadApps() async {
    setState(() => _loading = true);
    try {
      final apps = await _adminService.getApps();
      setState(() {
        _apps = apps;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading apps: $e')),
        );
      }
    }
  }

  Future<void> _deleteApp(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        title: const Text('Delete App', style: TextStyle(color: AppColors.textPrimary)),
        content: const Text(
          'Are you sure you want to delete this app?',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _adminService.deleteApp(id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('App deleted successfully')),
          );
        }
        _loadApps();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting app: $e')),
          );
        }
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
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(AppSpacing.xxxl),
            child: Row(
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Manage Apps',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Create, edit and manage your applications',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Navigate to create app page
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Create app form coming soon')),
                    );
                  },
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('New App'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xl,
                      vertical: AppSpacing.md,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _apps.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.apps_rounded,
                              size: 64,
                              color: AppColors.textDisabled,
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            const Text(
                              'No apps yet',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            ElevatedButton.icon(
                              onPressed: () {
                                // TODO: Navigate to create
                              },
                              icon: const Icon(Icons.add_rounded),
                              label: const Text('Create First App'),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(AppSpacing.xxxl),
                        itemCount: _apps.length,
                        itemBuilder: (context, index) {
                          final app = _apps[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                            child: _AppCard(
                              app: app,
                              onEdit: () {
                                // TODO: Navigate to edit page
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Edit form coming soon')),
                                );
                              },
                              onDelete: () => _deleteApp(app['id']),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class _AppCard extends StatefulWidget {
  final Map<String, dynamic> app;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _AppCard({
    required this.app,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<_AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<_AppCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final name = widget.app['name'] ?? 'Untitled';
    final version = widget.app['version'] ?? 'v1.0.0';
    final platform = widget.app['platform'] ?? 'Unknown';
    final description = widget.app['description'] ?? '';
    
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: AppRadius.card,
          border: Border.all(
            color: _hover ? AppColors.primary.withValues(alpha: 0.3) : AppColors.border,
          ),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.apps_rounded,
                color: AppColors.primary,
                size: 28,
              ),
            ),

            const SizedBox(width: AppSpacing.lg),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          version,
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    platform,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  if (description.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),

            // Actions
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: widget.onEdit,
                  icon: const Icon(Icons.edit_rounded),
                  color: AppColors.primary,
                  tooltip: 'Edit',
                ),
                IconButton(
                  onPressed: widget.onDelete,
                  icon: const Icon(Icons.delete_rounded),
                  color: const Color(0xFFEF4444),
                  tooltip: 'Delete',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
