import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/services/admin_service.dart';
import '../../../core/services/supabase_auth_service.dart';

class AdminAboutPage extends StatefulWidget {
  const AdminAboutPage({super.key});

  @override
  State<AdminAboutPage> createState() => _AdminAboutPageState();
}

class _AdminAboutPageState extends State<AdminAboutPage> {
  final _formKey = GlobalKey<FormState>();
  final _adminService = AdminService.instance;
  final _authService = SupabaseAuthService.instance;

  // Form controllers
  final _titleController = TextEditingController();
  final _subtitleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _profileImageController = TextEditingController();
  final _cvUrlController = TextEditingController();
  final _skillsController = TextEditingController();
  final _socialLinksController = TextEditingController();

  bool _loading = false;
  bool _checkingAuth = true;
  String? _aboutId;

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
    _loadAbout();
  }

  Future<void> _loadAbout() async {
    setState(() => _loading = true);
    try {
      final aboutData = await _adminService.getAboutMe();
      
      if (aboutData != null && mounted) {
        _aboutId = aboutData['id'];
        _titleController.text = aboutData['title'] ?? '';
        _subtitleController.text = aboutData['subtitle'] ?? '';
        _descriptionController.text = aboutData['description'] ?? '';
        _profileImageController.text = aboutData['profile_image_url'] ?? '';
        _cvUrlController.text = aboutData['cv_url'] ?? '';
        
        // Parse JSON fields to text
        if (aboutData['skills'] != null) {
          _skillsController.text = json.encode(aboutData['skills']);
        }
        if (aboutData['social_links'] != null) {
          _socialLinksController.text = json.encode(aboutData['social_links']);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading data: $e')),
        );
      }
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _saveAbout() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      // Parse JSON fields
      Map<String, dynamic>? skills;
      Map<String, dynamic>? socialLinks;
      
      if (_skillsController.text.trim().isNotEmpty) {
        try {
          skills = json.decode(_skillsController.text);
        } catch (e) {
          throw 'Invalid JSON format for skills';
        }
      }
      
      if (_socialLinksController.text.trim().isNotEmpty) {
        try {
          socialLinks = json.decode(_socialLinksController.text);
        } catch (e) {
          throw 'Invalid JSON format for social links';
        }
      }

      final data = {
        'title': _titleController.text.trim(),
        'subtitle': _subtitleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'profile_image_url': _profileImageController.text.trim(),
        'cv_url': _cvUrlController.text.trim(),
        'skills': skills,
        'social_links': socialLinks,
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (_aboutId != null) {
        await _adminService.updateAboutMe(_aboutId!, data);
      } else {
        final result = await _adminService.createAboutMe(data);
        _aboutId = result['id'];
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('About Me updated successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving: $e'),
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
    _subtitleController.dispose();
    _descriptionController.dispose();
    _profileImageController.dispose();
    _cvUrlController.dispose();
    _skillsController.dispose();
    _socialLinksController.dispose();
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
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Edit About Me',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Update your personal information and bio',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: _loading ? null : _saveAbout,
                  icon: const Icon(Icons.save_rounded),
                  label: const Text('Save Changes'),
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

          // Form
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSpacing.xxxl),
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 800),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Title
                            _buildTextField(
                              controller: _titleController,
                              label: 'Title',
                              hint: 'e.g., Full Stack Developer',
                              icon: Icons.person_rounded,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Title is required';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: AppSpacing.xl),

                            // Subtitle
                            _buildTextField(
                              controller: _subtitleController,
                              label: 'Subtitle',
                              hint: 'Short tagline about yourself',
                              icon: Icons.short_text_rounded,
                            ),

                            const SizedBox(height: AppSpacing.xl),

                            // Description
                            _buildTextField(
                              controller: _descriptionController,
                              label: 'Description',
                              hint: 'Tell your story...',
                              icon: Icons.description_rounded,
                              maxLines: 6,
                            ),

                            const SizedBox(height: AppSpacing.xl),

                            // Profile Image & CV URL
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextField(
                                    controller: _profileImageController,
                                    label: 'Profile Image URL',
                                    hint: 'https://example.com/photo.jpg',
                                    icon: Icons.image_rounded,
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.lg),
                                Expanded(
                                  child: _buildTextField(
                                    controller: _cvUrlController,
                                    label: 'CV/Resume URL',
                                    hint: 'https://example.com/cv.pdf',
                                    icon: Icons.file_present_rounded,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: AppSpacing.xl),

                            // Skills (JSON)
                            _buildTextField(
                              controller: _skillsController,
                              label: 'Skills (JSON Format)',
                              hint: '{"languages": ["JavaScript", "Python"], "frameworks": ["Flutter", "React"]}',
                              icon: Icons.code_rounded,
                              maxLines: 6,
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Enter skills as valid JSON object',
                              style: TextStyle(
                                color: AppColors.textDisabled,
                                fontSize: 12,
                              ),
                            ),

                            const SizedBox(height: AppSpacing.xl),

                            // Social Links (JSON)
                            _buildTextField(
                              controller: _socialLinksController,
                              label: 'Social Links (JSON Format)',
                              hint: '{"github": "https://github.com/username", "linkedin": "https://linkedin.com/in/username"}',
                              icon: Icons.link_rounded,
                              maxLines: 6,
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Enter social links as valid JSON object',
                              style: TextStyle(
                                color: AppColors.textDisabled,
                                fontSize: 12,
                              ),
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
