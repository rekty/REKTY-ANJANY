import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/services/admin_service.dart';
import '../../../core/services/supabase_auth_service.dart';

class AdminDownloadFormPage extends StatefulWidget {
  final String? downloadId;

  const AdminDownloadFormPage({super.key, this.downloadId});

  @override
  State<AdminDownloadFormPage> createState() => _AdminDownloadFormPageState();
}

class _AdminDownloadFormPageState extends State<AdminDownloadFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _adminService = AdminService.instance;
  final _authService = SupabaseAuthService.instance;

  // Form controllers
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _versionController = TextEditingController();
  final _platformController = TextEditingController();
  final _fileSizeController = TextEditingController();
  final _fileUrlController = TextEditingController();
  final _downloadUrlController = TextEditingController();
  final _sourceUrlController = TextEditingController();
  final _iconController = TextEditingController();
  final _colorController = TextEditingController();
  final _featuresController = TextEditingController();

  bool _loading = false;
  bool _checkingAuth = true;
  bool get _isEdit => widget.downloadId != null;

  @override
  void initState() {
    super.initState();
    _checkAdminAccess();
  }

  Future<void> _checkAdminAccess() async {
    final user = _authService.currentUser;
    
    if (user == null) {
      if (mounted) context.go('/login');
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
            content: Text('Access denied'),
            backgroundColor: Colors.red,
          ),
        );
        context.go('/');
      }
      return;
    }

    setState(() => _checkingAuth = false);
    
    if (_isEdit) {
      _loadDownload();
    }
  }

  Future<void> _loadDownload() async {
    setState(() => _loading = true);
    try {
      final downloads = await _adminService.getDownloads();
      final download = downloads.firstWhere(
        (d) => d['id'] == widget.downloadId,
        orElse: () => {},
      );

      if (download.isNotEmpty && mounted) {
        _nameController.text = download['name'] ?? '';
        _descriptionController.text = download['description'] ?? '';
        _versionController.text = download['version'] ?? '';
        _platformController.text = download['platform'] ?? '';
        _fileSizeController.text = download['file_size'] ?? '';
        _fileUrlController.text = download['file_url'] ?? '';
        _downloadUrlController.text = download['download_url'] ?? '';
        _sourceUrlController.text = download['source_url'] ?? '';
        _iconController.text = download['icon'] ?? '';
        _colorController.text = download['color'] ?? '';
        
        if (download['features'] != null) {
          final features = download['features'];
          if (features is List) {
            _featuresController.text = features.join('\n');
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading download: $e')),
        );
      }
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _saveDownload() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      List<String> features = [];
      if (_featuresController.text.trim().isNotEmpty) {
        features = _featuresController.text
            .split('\n')
            .where((f) => f.trim().isNotEmpty)
            .map((f) => f.trim())
            .toList();
      }

      final data = {
        'name': _nameController.text.trim(),
        'description': _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
        'version': _versionController.text.trim(),
        'platform': _platformController.text.trim(),
        'file_size': _fileSizeController.text.trim().isEmpty ? null : _fileSizeController.text.trim(),
        'file_url': _fileUrlController.text.trim().isEmpty ? null : _fileUrlController.text.trim(),
        'download_url': _downloadUrlController.text.trim().isEmpty ? null : _downloadUrlController.text.trim(),
        'source_url': _sourceUrlController.text.trim().isEmpty ? null : _sourceUrlController.text.trim(),
        'icon': _iconController.text.trim().isEmpty ? null : _iconController.text.trim(),
        'color': _colorController.text.trim().isEmpty ? null : _colorController.text.trim(),
        'features': features.isEmpty ? null : features,
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (_isEdit) {
        await _adminService.updateDownload(widget.downloadId!, data);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Download updated successfully')),
          );
          context.go('/admin/downloads');
        }
      } else {
        await _adminService.createDownload(data);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Download created successfully')),
          );
          context.go('/admin/downloads');
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving download: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _versionController.dispose();
    _platformController.dispose();
    _fileSizeController.dispose();
    _fileUrlController.dispose();
    _downloadUrlController.dispose();
    _sourceUrlController.dispose();
    _iconController.dispose();
    _colorController.dispose();
    _featuresController.dispose();
    super.dispose();
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
                IconButton(
                  onPressed: () => context.go('/admin/downloads'),
                  icon: const Icon(Icons.arrow_back_rounded),
                  color: AppColors.textPrimary,
                ),
                const SizedBox(width: AppSpacing.md),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isEdit ? 'Edit Download' : 'Create New Download',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _isEdit ? 'Update download information' : 'Add a new downloadable file',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Form
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.xxxl),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildTextField(
                        controller: _nameController,
                        label: 'File Name',
                        hint: 'e.g., My App APK',
                        icon: Icons.file_download_rounded,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'File name is required';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: AppSpacing.xl),

                      _buildTextField(
                        controller: _descriptionController,
                        label: 'Description',
                        hint: 'Description of the file',
                        icon: Icons.description_rounded,
                        maxLines: 3,
                      ),

                      const SizedBox(height: AppSpacing.xl),

                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _versionController,
                              label: 'Version',
                              hint: 'e.g., 1.0.0',
                              icon: Icons.tag_rounded,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Required';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: AppSpacing.lg),
                          Expanded(
                            child: _buildTextField(
                              controller: _platformController,
                              label: 'Platform',
                              hint: 'e.g., Android',
                              icon: Icons.devices_rounded,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: AppSpacing.xl),

                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _fileSizeController,
                              label: 'File Size',
                              hint: 'e.g., 25 MB',
                              icon: Icons.storage_rounded,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.lg),
                          Expanded(
                            child: _buildTextField(
                              controller: _colorController,
                              label: 'Color (Hex)',
                              hint: '#FF5733',
                              icon: Icons.palette_rounded,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: AppSpacing.xl),

                      _buildTextField(
                        controller: _fileUrlController,
                        label: 'File URL (Storage)',
                        hint: 'https://storage.example.com/file.apk',
                        icon: Icons.cloud_upload_rounded,
                      ),

                      const SizedBox(height: AppSpacing.xl),

                      _buildTextField(
                        controller: _downloadUrlController,
                        label: 'Download URL (Public)',
                        hint: 'https://example.com/download',
                        icon: Icons.download_rounded,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Download URL is required';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: AppSpacing.xl),

                      _buildTextField(
                        controller: _sourceUrlController,
                        label: 'Source URL (Optional)',
                        hint: 'https://github.com/...',
                        icon: Icons.code_rounded,
                      ),

                      const SizedBox(height: AppSpacing.xl),

                      _buildTextField(
                        controller: _iconController,
                        label: 'Icon URL',
                        hint: 'https://example.com/icon.png',
                        icon: Icons.image_rounded,
                      ),

                      const SizedBox(height: AppSpacing.xl),

                      _buildTextField(
                        controller: _featuresController,
                        label: 'Features',
                        hint: 'Enter each feature on a new line',
                        icon: Icons.list_rounded,
                        maxLines: 5,
                      ),

                      const SizedBox(height: AppSpacing.xxxl),

                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _loading
                                  ? null
                                  : () => context.go('/admin/downloads'),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.all(AppSpacing.lg),
                                side: const BorderSide(color: AppColors.border),
                              ),
                              child: const Text('Cancel'),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.lg),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              onPressed: _loading ? null : _saveDownload,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(AppSpacing.lg),
                              ),
                              child: _loading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.black,
                                      ),
                                    )
                                  : Text(_isEdit ? 'Update' : 'Create'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          maxLines: maxLines,
          style: const TextStyle(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.textDisabled),
            prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
            filled: true,
            fillColor: AppColors.card,
            border: OutlineInputBorder(
              borderRadius: AppRadius.input,
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.input,
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadius.input,
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: AppRadius.input,
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: AppRadius.input,
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
