import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';

class AdminLayout extends StatelessWidget {
  final Widget child;

  const AdminLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          const _AdminSidebar(),
          
          // Main content
          Expanded(
            child: Container(
              color: AppColors.background,
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminSidebar extends StatelessWidget {
  const _AdminSidebar();

  @override
  Widget build(BuildContext context) {
    final currentPath = GoRouterState.of(context).uri.path;

    return Container(
      width: 260,
      color: AppColors.card,
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.admin_panel_settings_rounded,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Admin Panel',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Rekty Anjany',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(color: AppColors.border, height: 1),

          // Menu Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                _MenuItem(
                  icon: Icons.dashboard_rounded,
                  label: 'Dashboard',
                  path: '/admin',
                  isActive: currentPath == '/admin',
                ),
                const SizedBox(height: 4),
                _MenuItem(
                  icon: Icons.apps_rounded,
                  label: 'Apps',
                  path: '/admin/apps',
                  isActive: currentPath.startsWith('/admin/apps'),
                ),
                const SizedBox(height: 4),
                _MenuItem(
                  icon: Icons.download_rounded,
                  label: 'Downloads',
                  path: '/admin/downloads',
                  isActive: currentPath.startsWith('/admin/downloads'),
                ),
                const SizedBox(height: 4),
                _MenuItem(
                  icon: Icons.store_rounded,
                  label: 'Store',
                  path: '/admin/store',
                  isActive: currentPath.startsWith('/admin/store'),
                ),
                const SizedBox(height: 4),
                _MenuItem(
                  icon: Icons.photo_library_rounded,
                  label: 'Gallery',
                  path: '/admin/gallery',
                  isActive: currentPath.startsWith('/admin/gallery'),
                ),
                const SizedBox(height: 4),
                _MenuItem(
                  icon: Icons.article_rounded,
                  label: 'Blog',
                  path: '/admin/blog',
                  isActive: currentPath.startsWith('/admin/blog'),
                ),
                const SizedBox(height: 4),
                _MenuItem(
                  icon: Icons.person_rounded,
                  label: 'About',
                  path: '/admin/about',
                  isActive: currentPath.startsWith('/admin/about'),
                ),
                const SizedBox(height: 4),
                _MenuItem(
                  icon: Icons.mail_rounded,
                  label: 'Messages',
                  path: '/admin/messages',
                  isActive: currentPath.startsWith('/admin/messages'),
                ),
                const SizedBox(height: 4),
                _MenuItem(
                  icon: Icons.contact_page_rounded,
                  label: 'Contact Info',
                  path: '/admin/contact',
                  isActive: currentPath.startsWith('/admin/contact'),
                ),
              ],
            ),
          ),

          const Divider(color: AppColors.border, height: 1),

          // Footer
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                _MenuItem(
                  icon: Icons.home_rounded,
                  label: 'Back to Website',
                  path: '/',
                  isActive: false,
                ),
                const SizedBox(height: 4),
                _MenuItem(
                  icon: Icons.logout_rounded,
                  label: 'Logout',
                  path: '/logout',
                  isActive: false,
                  isLogout: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final String path;
  final bool isActive;
  final bool isLogout;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.path,
    required this.isActive,
    this.isLogout = false,
  });

  @override
  State<_MenuItem> createState() => _MenuItemState();
}

class _MenuItemState extends State<_MenuItem> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.isActive
        ? AppColors.primary
        : _hover
            ? AppColors.textPrimary
            : AppColors.textSecondary;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: () {
          if (widget.isLogout) {
            // TODO: Handle logout
            context.go('/login');
          } else {
            context.go(widget.path);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: widget.isActive
                ? AppColors.primary.withValues(alpha: 0.1)
                : _hover
                    ? AppColors.surface
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                widget.icon,
                size: 20,
                color: color,
              ),
              const SizedBox(width: AppSpacing.md),
              Text(
                widget.label,
                style: TextStyle(
                  color: color,
                  fontSize: 14,
                  fontWeight: widget.isActive ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
