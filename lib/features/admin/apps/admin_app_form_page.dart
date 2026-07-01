import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/services/admin_service.dart';
import '../../../core/services/supabase_auth_service.dart';
import '../../../shared/widgets/form/color_picker_field.dart';
import '../../../shared/widgets/form/font_weight_field.dart';

class AdminAppFormPage extends StatefulWidget {
  final String? appId;

  const AdminAppFormPage({super.key, this.appId});

  @override
  State<AdminAppFormPage> createState() => _AdminAppFormPageState();
}

class _AdminAppFormPageState extends State<AdminAppFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _adminService = AdminService.instance;
  final _authService = SupabaseAuthService.instance;

  // Form controllers
  final _nameController = TextEditingController();
  final _taglineController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _versionController = TextEditingController();
  final _platformController = TextEditingController();
  final _iconController = TextEditingController();
  final _colorController = TextEditingController();
  final _downloadUrlController = TextEditingController();
  final _featuresController = TextEditingController();
  
  // Styling controllers
  final _titleColorController = TextEditingController();
  final _taglineColorController = TextEditingController();
  final _descriptionColorController = TextEditingController();
  final _fontWeightController = TextEditingController();

  bool _loading = false;
  bool _checkingAuth = true;
  bool get _isEdit => widget.appId != null;

  @override
  void initState() {
    super.initState();
    // Set default styling values
    _titleColorController.text = '#FFFFFF';
    _taglineColorController.text = '#54C5F8';
    _descriptionColorController.text = '#94A3B8';
    _fontWeightController.text = 'bold';
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
            content: Text('Access denied: Admin privileges required'),
            backgroundColor: Colors.red,
          ),
        );
        context.go('/');
      }
      return;
    }

    setState(() => _checkingAuth = false);
    
    if (_isEdit) {
      _loadApp();
    }
  }

  Future<void> _loadApp() async {
    setState(() => _loading = true);
    try {
      final apps = await _adminService.getApps();
      final app = apps.firstWhere(
        (a) => a['id'] == widget.appId,
        orElse: () => {},
      );

      if (app.isNotEmpty && mounted) {
        _nameController.text = app['name'] ?? '';
        _taglineController.text = app['tagline'] ?? '';
        _descriptionController.text = app['description'] ?? '';
        _versionController.text = app['version'] ?? '';
        _platformController.text = app['platform'] ?? '';
        _iconController.text = app['icon'] ?? '';
        _colorController.text = app['color'] ?? '';
        _downloadUrlController.text = app['download_url'] ?? '';
        
        // Load styling fields
        _titleColorController.text = app['title_color'] ?? '#FFFFFF';
        _taglineColorController.text = app['tagline_color'] ?? '#54C5F8';
        _descriptionColorController.text = app['description_color'] ?? '#94A3B8';
        _fontWeightController.text = app['font_weight'] ?? 'bold';
        
        // Parse features JSON to text
        if (app['features'] != null) {
          final features = app['features'];
          if (features is List) {
            _featuresController.text = features.join('\n');
          } else if (features is Map) {
            _featuresController.text = json.encode(features);
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading app: $e')),
        );
      }
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _saveApp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      // Parse features from text (optional field)
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
        'tagline': _taglineController.text.trim().isEmpty ? null : _taglineController.text.trim(),
        'description': _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
        'version': _versionController.text.trim(),
        'platform': _platformController.text.trim(),
        'icon': _iconController.text.trim().isEmpty ? null : _iconController.text.trim(),
        'color': _colorController.text.trim().isEmpty ? null : _colorController.text.trim(),
        'download_url': _downloadUrlController.text.trim().isEmpty ? null : _downloadUrlController.text.trim(),
        'features': features.isEmpty ? null : features,
        // Styling fields
        'title_color': _titleColorController.text.trim(),
        'tagline_color': _taglineColorController.text.trim(),
        'description_color': _descriptionColorController.text.trim(),
        'font_weight': _fontWeightController.text.trim(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (_isEdit) {
        await _adminService.updateApp(widget.appId!, data);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('App updated successfully')),
          );
          context.go('/admin/apps');
        }
      } else {
        await _adminService.createApp(data);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('App created successfully')),
          );
          context.go('/admin/apps');
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving app: $e'),
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
    _taglineController.dispose();
    _descriptionController.dispose();
    _versionController.dispose();
    _platformController.dispose();
    _iconController.dispose();
    _colorController.dispose();
    _downloadUrlController.dispose();
    _featuresController.dispose();
    // Styling controllers
    _titleColorController.dispose();
    _taglineColorController.dispose();
    _descriptionColorController.dispose();
    _fontWeightController.dispose();
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
                  onPressed: () => context.go('/admin/apps'),
                  icon: const Icon(Icons.arrow_back_rounded),
                  color: AppColors.textPrimary,
                ),
                const SizedBox(width: AppSpacing.md),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isEdit ? 'Edit App' : 'Create New App',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _isEdit
                          ? 'Update application information'
                          : 'Fill in the details below',
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
                      // App Name
                      _buildTextField(
                        controller: _nameController,
                        label: 'App Name',
                        hint: 'e.g., My Awesome App',
                        icon: Icons.apps_rounded,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'App name is required';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: AppSpacing.xl),

                      // Tagline
                      _buildTextField(
                        controller: _taglineController,
                        label: 'Tagline',
                        hint: 'Short catchy description',
                        icon: Icons.short_text_rounded,
                      ),

                      const SizedBox(height: AppSpacing.xl),

                      // Description
                      _buildTextField(
                        controller: _descriptionController,
                        label: 'Description',
                        hint: 'Detailed description of your app',
                        icon: Icons.description_rounded,
                        maxLines: 4,
                      ),

                      const SizedBox(height: AppSpacing.xl),

                      // Version & Platform (Row)
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
                                  return 'Version is required';
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
                              hint: 'e.g., Android, iOS, Web',
                              icon: Icons.devices_rounded,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Platform is required';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: AppSpacing.xl),

                      // Icon URL & Color (Row)
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _iconController,
                              label: 'Icon URL',
                              hint: 'https://example.com/icon.png',
                              icon: Icons.image_rounded,
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

                      // Download URL
                      _buildTextField(
                        controller: _downloadUrlController,
                        label: 'Download URL',
                        hint: 'https://example.com/download',
                        icon: Icons.download_rounded,
                      ),

                      const SizedBox(height: AppSpacing.xl),

                      // Features
                      _buildTextField(
                        controller: _featuresController,
                        label: 'Features (Optional)',
                        hint: 'Enter each feature on a new line:\nFast Performance\nModern UI Design\nCloud Sync\nOffline Mode',
                        icon: Icons.list_rounded,
                        maxLines: 6,
                        validator: (value) {
                          if (value != null && value.trim().isNotEmpty) {
                            // Check if contains markdown symbols
                            if (value.contains('**') || value.contains('##') || value.contains('```')) {
                              return 'Please enter simple features list only (no markdown)';
                            }
                            // Check if lines are too long
                            final lines = value.split('\n');
                            for (var line in lines) {
                              if (line.trim().length > 100) {
                                return 'Each feature should be short (max 100 characters per line)';
                              }
                            }
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '💡 Tip: Enter one feature per line, or leave empty',
                        style: TextStyle(
                          color: AppColors.textDisabled,
                          fontSize: 12,
                        ),
                      ),

                      const SizedBox(height: AppSpacing.xxxl),

                      // === STYLING SECTION ===
                      const Divider(color: AppColors.border),
                      const SizedBox(height: AppSpacing.xl),

                      const Text(
                        '🎨 Styling Options',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Customize text colors and font weight',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),

                      const SizedBox(height: AppSpacing.xl),

                      // Title Color
                      ColorPickerField(
                        label: 'Title Color',
                        value: _titleColorController.text,
                        onChanged: (color) {
                          setState(() => _titleColorController.text = color);
                        },
                      ),

                      const SizedBox(height: AppSpacing.xl),

                      // Tagline Color
                      ColorPickerField(
                        label: 'Tagline Color',
                        value: _taglineColorController.text,
                        onChanged: (color) {
                          setState(() => _taglineColorController.text = color);
                        },
                      ),

                      const SizedBox(height: AppSpacing.xl),

                      // Description Color
                      ColorPickerField(
                        label: 'Description Color',
                        value: _descriptionColorController.text,
                        onChanged: (color) {
                          setState(() => _descriptionColorController.text = color);
                        },
                      ),

                      const SizedBox(height: AppSpacing.xl),

                      // Font Weight
                      FontWeightField(
                        label: 'Font Weight',
                        value: _fontWeightController.text,
                        onChanged: (value) {
                          setState(() => _fontWeightController.text = value ?? 'bold');
                        },
                      ),

                      const SizedBox(height: AppSpacing.xxxl),

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _loading
                                  ? null
                                  : () => context.go('/admin/apps'),
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
                              onPressed: _loading ? null : _saveApp,
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
                                  : Text(_isEdit ? 'Update App' : 'Create App'),
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
