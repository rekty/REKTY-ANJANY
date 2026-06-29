import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/services/admin_service.dart';
import '../../../core/services/supabase_auth_service.dart';
import 'package:go_router/go_router.dart';

class AdminDownloadsPage extends StatefulWidget {
  const AdminDownloadsPage({super.key});

  @override
  State<AdminDownloadsPage> createState() => _AdminDownloadsPageState();
}

class _AdminDownloadsPageState extends State<AdminDownloadsPage> {
  final _adminService = AdminService.instance;
  final _authService = SupabaseAuthService.instance;
  List<Map<String, dynamic>> _downloads = [];
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
      if (mounted) context.go('/login?redirect=/admin/downloads');
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
    _loadDownloads();
  }

  Future<void> _loadDownloads() async {
    setState(() => _loading = true);
    try {
      final downloads = await _adminService.getDownloads();
      setState(() {
        _downloads = downloads;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading downloads: $e')),
        );
      }
    }
  }

  Future<void> _deleteDownload(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        title: const Text('Delete Download', style: TextStyle(color: AppColors.textPrimary)),
        content: const Text(
          'Are you sure you want to delete this download?',
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
        await _adminService.deleteDownload(id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Download deleted successfully')),
          );
        }
        _loadDownloads();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting download: $e')),
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
                      'Manage Downloads',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Upload and manage downloadable files',
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Upload form coming soon')),
                    );
                  },
                  icon: const Icon(Icons.upload_rounded),
                  label: const Text('Upload File'),
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
                : _downloads.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.download_rounded,
                              size: 64,
                              color: AppColors.textDisabled,
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            const Text(
                              'No downloads yet',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.upload_rounded),
                              label: const Text('Upload First File'),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(AppSpacing.xxxl),
                        itemCount: _downloads.length,
                        itemBuilder: (context, index) {
                          final download = _downloads[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                            child: _DownloadCard(
                              download: download,
                              onEdit: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Edit form coming soon')),
                                );
                              },
                              onDelete: () => _deleteDownload(download['id']),
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

class _DownloadCard extends StatefulWidget {
  final Map<String, dynamic> download;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _DownloadCard({
    required this.download,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<_DownloadCard> createState() => _DownloadCardState();
}

class _DownloadCardState extends State<_DownloadCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final name = widget.download['name'] ?? 'Untitled';
    final version = widget.download['version'] ?? 'v1.0.0';
    final platform = widget.download['platform'] ?? 'Unknown';
    final fileSize = widget.download['file_size'] ?? '';
    final downloadCount = widget.download['download_count'] ?? 0;
    
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
                color: const Color(0xFF34D399).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.download_rounded,
                color: Color(0xFF34D399),
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
                  Row(
                    children: [
                      Text(
                        platform,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                      if (fileSize.isNotEmpty) ...[
                        const Text(
                          ' • ',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                        Text(
                          fileSize,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                      const Text(
                        ' • ',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                      Text(
                        '$downloadCount downloads',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
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
