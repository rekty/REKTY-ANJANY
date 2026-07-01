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

class AdminContactPage extends StatefulWidget {
  const AdminContactPage({super.key});

  @override
  State<AdminContactPage> createState() => _AdminContactPageState();
}

class _AdminContactPageState extends State<AdminContactPage> {
  final _formKey = GlobalKey<FormState>();
  final _adminService = AdminService.instance;
  final _authService = SupabaseAuthService.instance;

  // Form controllers
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _socialMediaController = TextEditingController();
  
  // Styling controllers
  final _titleColorController = TextEditingController();
  final _descriptionColorController = TextEditingController();
  final _fontWeightController = TextEditingController();

  bool _loading = false;
  bool _checkingAuth = true;
  String? _contactId;

  @override
  void initState() {
    super.initState();
    // Set default styling values
    _titleColorController.text = '#FFFFFF';
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
    _loadContactInfo();
  }

  Future<void> _loadContactInfo() async {
    setState(() => _loading = true);
    try {
      final contactData = await _adminService.getContactInfo();
      
      if (contactData != null && mounted) {
        _contactId = contactData['id'];
        _emailController.text = contactData['email'] ?? '';
        _phoneController.text = contactData['phone'] ?? '';
        _addressController.text = contactData['address'] ?? '';
        
        // Load styling fields
        _titleColorController.text = contactData['title_color'] ?? '#FFFFFF';
        _descriptionColorController.text = contactData['description_color'] ?? '#94A3B8';
        _fontWeightController.text = contactData['font_weight'] ?? 'bold';
        
        // Parse JSON field to text
        if (contactData['social_media'] != null) {
          _socialMediaController.text = json.encode(contactData['social_media']);
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

  Future<void> _saveContactInfo() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      // Parse JSON field
      Map<String, dynamic>? socialMedia;
      
      if (_socialMediaController.text.trim().isNotEmpty) {
        try {
          socialMedia = json.decode(_socialMediaController.text);
        } catch (e) {
          throw 'Invalid JSON format for social media';
        }
      }

      final data = {
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'address': _addressController.text.trim(),
        'social_media': socialMedia,
        // Styling fields
        'title_color': _titleColorController.text.trim(),
        'description_color': _descriptionColorController.text.trim(),
        'font_weight': _fontWeightController.text.trim(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (_contactId != null) {
        await _adminService.updateContactInfo(_contactId!, data);
      } else {
        final result = await _adminService.createContactInfo(data);
        _contactId = result['id'];
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Contact info updated successfully')),
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
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _socialMediaController.dispose();
    // Styling controllers
    _titleColorController.dispose();
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
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Edit Contact Information',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Update your contact details and social media links',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: _loading ? null : _saveContactInfo,
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
                            // Email
                            _buildTextField(
                              controller: _emailController,
                              label: 'Email Address',
                              hint: 'your.email@example.com',
                              icon: Icons.email_rounded,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Email is required';
                                }
                                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                    .hasMatch(value)) {
                                  return 'Enter a valid email address';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: AppSpacing.xl),

                            // Phone
                            _buildTextField(
                              controller: _phoneController,
                              label: 'Phone Number',
                              hint: '+1 (234) 567-8900',
                              icon: Icons.phone_rounded,
                            ),

                            const SizedBox(height: AppSpacing.xl),

                            // Address
                            _buildTextField(
                              controller: _addressController,
                              label: 'Address',
                              hint: 'City, State, Country',
                              icon: Icons.location_on_rounded,
                              maxLines: 3,
                            ),

                            const SizedBox(height: AppSpacing.xl),

                            // Social Media (JSON)
                            _buildTextField(
                              controller: _socialMediaController,
                              label: 'Social Media Links (JSON Format)',
                              hint: '{"twitter": "https://twitter.com/username", "facebook": "https://facebook.com/username", "instagram": "https://instagram.com/username"}',
                              icon: Icons.share_rounded,
                              maxLines: 8,
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Enter social media links as valid JSON object with platform names as keys and URLs as values',
                              style: TextStyle(
                                color: AppColors.textDisabled,
                                fontSize: 12,
                              ),
                            ),

                            const SizedBox(height: AppSpacing.xl),

                            // Info Card
                            Container(
                              padding: const EdgeInsets.all(AppSpacing.lg),
                              decoration: BoxDecoration(
                                color: const Color(0xFF3B82F6).withValues(alpha: 0.1),
                                borderRadius: AppRadius.card,
                                border: Border.all(
                                  color: const Color(0xFF3B82F6).withValues(alpha: 0.2),
                                ),
                              ),
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.info_rounded,
                                    color: Color(0xFF3B82F6),
                                    size: 24,
                                  ),
                                  SizedBox(width: AppSpacing.md),
                                  Expanded(
                                    child: Text(
                                      'This information will be displayed on your contact page. Make sure all details are accurate and up-to-date.',
                                      style: TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
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
                              'Customize text colors and font weight for contact cards',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                              ),
                            ),

                            const SizedBox(height: AppSpacing.xl),

                            // Title Color (for card labels like "Email", "Website")
                            ColorPickerField(
                              label: 'Label Color',
                              value: _titleColorController.text,
                              onChanged: (color) {
                                setState(() => _titleColorController.text = color);
                              },
                            ),

                            const SizedBox(height: AppSpacing.xl),

                            // Description Color (for card values)
                            ColorPickerField(
                              label: 'Value Color',
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
