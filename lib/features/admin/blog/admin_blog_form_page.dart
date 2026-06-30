import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/services/admin_service.dart';
import '../../../core/services/supabase_auth_service.dart';

class AdminBlogFormPage extends StatefulWidget {
  final String? postId;

  const AdminBlogFormPage({super.key, this.postId});

  @override
  State<AdminBlogFormPage> createState() => _AdminBlogFormPageState();
}

class _AdminBlogFormPageState extends State<AdminBlogFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _adminService = AdminService.instance;
  final _authService = SupabaseAuthService.instance;

  // Form controllers
  final _titleController = TextEditingController();
  final _slugController = TextEditingController();
  final _excerptController = TextEditingController();
  final _contentController = TextEditingController();
  final _tagController = TextEditingController();
  final _tagColorController = TextEditingController();
  final _iconController = TextEditingController();
  final _readTimeController = TextEditingController(text: '5');
  
  bool _isPublished = false;
  bool _loading = false;
  bool _checkingAuth = true;
  bool get _isEdit => widget.postId != null;

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
      _loadPost();
    }
  }

  Future<void> _loadPost() async {
    setState(() => _loading = true);
    try {
      final posts = await _adminService.getBlogPosts();
      final post = posts.firstWhere(
        (p) => p['id'] == widget.postId,
        orElse: () => {},
      );

      if (post.isNotEmpty && mounted) {
        _titleController.text = post['title'] ?? '';
        _slugController.text = post['slug'] ?? '';
        _excerptController.text = post['excerpt'] ?? '';
        _contentController.text = post['content'] ?? '';
        _tagController.text = post['tag'] ?? '';
        _tagColorController.text = post['tag_color'] ?? '';
        _iconController.text = post['icon'] ?? '';
        _readTimeController.text = (post['read_time'] ?? 5).toString();
        _isPublished = post['is_published'] == true;
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading post: $e')),
        );
      }
    } finally {
      setState(() => _loading = false);
    }
  }

  void _generateSlug() {
    final title = _titleController.text.trim();
    if (title.isNotEmpty) {
      final slug = title
          .toLowerCase()
          .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
          .replaceAll(RegExp(r'-+'), '-')
          .replaceAll(RegExp(r'^-|-$'), '');
      _slugController.text = slug;
    }
  }

  Future<void> _savePost() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      final data = {
        'title': _titleController.text.trim(),
        'slug': _slugController.text.trim(),
        'excerpt': _excerptController.text.trim().isEmpty ? null : _excerptController.text.trim(),
        'content': _contentController.text.trim(),
        'tag': _tagController.text.trim().isEmpty ? null : _tagController.text.trim(),
        'tag_color': _tagColorController.text.trim().isEmpty ? null : _tagColorController.text.trim(),
        'icon': _iconController.text.trim().isEmpty ? null : _iconController.text.trim(),
        'read_time': int.tryParse(_readTimeController.text) ?? 5,
        'is_published': _isPublished,
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (_isEdit) {
        await _adminService.updateBlogPost(widget.postId!, data);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Blog post updated successfully')),
          );
          context.go('/admin/blog');
        }
      } else {
        await _adminService.createBlogPost(data);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Blog post created successfully')),
          );
          context.go('/admin/blog');
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving post: $e'),
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
    _titleController.dispose();
    _slugController.dispose();
    _excerptController.dispose();
    _contentController.dispose();
    _tagController.dispose();
    _tagColorController.dispose();
    _iconController.dispose();
    _readTimeController.dispose();
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
                  onPressed: () => context.go('/admin/blog'),
                  icon: const Icon(Icons.arrow_back_rounded),
                  color: AppColors.textPrimary,
                ),
                const SizedBox(width: AppSpacing.md),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isEdit ? 'Edit Blog Post' : 'Write New Post',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _isEdit
                          ? 'Update blog post content'
                          : 'Create a new article for your blog',
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
                constraints: const BoxConstraints(maxWidth: 1000),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Title
                      _buildTextField(
                        controller: _titleController,
                        label: 'Title',
                        hint: 'Enter post title',
                        icon: Icons.title_rounded,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Title is required';
                          }
                          return null;
                        },
                        onChanged: (_) {
                          if (!_isEdit || _slugController.text.isEmpty) {
                            _generateSlug();
                          }
                        },
                      ),

                      const SizedBox(height: AppSpacing.xl),

                      // Slug with generate button
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _slugController,
                              label: 'URL Slug',
                              hint: 'url-friendly-slug',
                              icon: Icons.link_rounded,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Slug is required';
                                }
                                if (!RegExp(r'^[a-z0-9-]+$').hasMatch(value)) {
                                  return 'Slug must contain only lowercase letters, numbers, and hyphens';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          ElevatedButton.icon(
                            onPressed: _generateSlug,
                            icon: const Icon(Icons.auto_awesome_rounded, size: 16),
                            label: const Text('Generate'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.lg,
                                vertical: 16,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: AppSpacing.xl),

                      // Excerpt
                      _buildTextField(
                        controller: _excerptController,
                        label: 'Excerpt',
                        hint: 'Short description (shown in preview)',
                        icon: Icons.short_text_rounded,
                        maxLines: 2,
                      ),

                      const SizedBox(height: AppSpacing.xl),

                      // Content
                      _buildTextField(
                        controller: _contentController,
                        label: 'Content',
                        hint: 'Write your blog post content here...',
                        icon: Icons.article_rounded,
                        maxLines: 12,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Content is required';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: AppSpacing.xl),

                      // Tag, Tag Color, Icon (Row)
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _tagController,
                              label: 'Tag',
                              hint: 'e.g., Tutorial',
                              icon: Icons.label_rounded,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.lg),
                          Expanded(
                            child: _buildTextField(
                              controller: _tagColorController,
                              label: 'Tag Color',
                              hint: '#3B82F6',
                              icon: Icons.palette_rounded,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.lg),
                          Expanded(
                            child: _buildTextField(
                              controller: _iconController,
                              label: 'Icon',
                              hint: 'Icon name',
                              icon: Icons.star_rounded,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: AppSpacing.xl),

                      // Read Time & Published Status
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _readTimeController,
                              label: 'Read Time (minutes)',
                              hint: '5',
                              icon: Icons.schedule_rounded,
                              validator: (value) {
                                if (value != null &&
                                    value.isNotEmpty &&
                                    int.tryParse(value) == null) {
                                  return 'Must be a number';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: AppSpacing.xl),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Publish Status',
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.card,
                                    borderRadius: AppRadius.input,
                                    border: Border.all(color: AppColors.border),
                                  ),
                                  child: CheckboxListTile(
                                    value: _isPublished,
                                    onChanged: (value) {
                                      setState(() => _isPublished = value ?? false);
                                    },
                                    title: const Text(
                                      'Published',
                                      style: TextStyle(color: AppColors.textPrimary),
                                    ),
                                    subtitle: Text(
                                      _isPublished
                                          ? 'Post is visible to public'
                                          : 'Post is saved as draft',
                                      style: const TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 12,
                                      ),
                                    ),
                                    activeColor: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: AppSpacing.xxxl),

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _loading
                                  ? null
                                  : () => context.go('/admin/blog'),
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
                              onPressed: _loading ? null : _savePost,
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
                                  : Text(_isEdit ? 'Update Post' : 'Create Post'),
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
    Function(String)? onChanged,
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
          onChanged: onChanged,
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
