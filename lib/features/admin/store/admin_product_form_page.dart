import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/services/admin_service.dart';
import '../../../core/services/supabase_auth_service.dart';
import '../../../shared/widgets/form/color_picker_field.dart';
import '../../../shared/widgets/form/font_weight_field.dart';

class AdminProductFormPage extends StatefulWidget {
  final String? productId;

  const AdminProductFormPage({super.key, this.productId});

  @override
  State<AdminProductFormPage> createState() => _AdminProductFormPageState();
}

class _AdminProductFormPageState extends State<AdminProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _adminService = AdminService.instance;
  final _authService = SupabaseAuthService.instance;

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _originalPriceController = TextEditingController();
  final _iconController = TextEditingController();
  final _badgeController = TextEditingController();
  
  // Styling controllers
  final _titleColorController = TextEditingController();
  final _descriptionColorController = TextEditingController();
  final _fontWeightController = TextEditingController();

  bool _loading = false;
  bool _checkingAuth = true;
  bool _isActive = true;
  bool get _isEdit => widget.productId != null;

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
          const SnackBar(content: Text('Access denied'), backgroundColor: Colors.red),
        );
        context.go('/');
      }
      return;
    }

    setState(() => _checkingAuth = false);
    if (_isEdit) _loadProduct();
  }

  Future<void> _loadProduct() async {
    setState(() => _loading = true);
    try {
      final products = await _adminService.getProducts();
      final product = products.firstWhere((p) => p['id'] == widget.productId, orElse: () => {});

      if (product.isNotEmpty && mounted) {
        _nameController.text = product['name'] ?? '';
        _descriptionController.text = product['description'] ?? '';
        _priceController.text = product['price']?.toString() ?? '';
        _originalPriceController.text = product['original_price']?.toString() ?? '';
        _iconController.text = product['icon'] ?? '';
        _badgeController.text = product['badge'] ?? '';
        _isActive = product['is_active'] ?? true;
        
        // Load styling fields
        _titleColorController.text = product['title_color'] ?? '#FFFFFF';
        _descriptionColorController.text = product['description_color'] ?? '#94A3B8';
        _fontWeightController.text = product['font_weight'] ?? 'bold';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading product: $e')),
        );
      }
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      final data = {
        'name': _nameController.text.trim(),
        'description': _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
        'price': double.tryParse(_priceController.text.trim()) ?? 0,
        'original_price': _originalPriceController.text.trim().isEmpty 
            ? null 
            : double.tryParse(_originalPriceController.text.trim()),
        'icon': _iconController.text.trim().isEmpty ? null : _iconController.text.trim(),
        'badge': _badgeController.text.trim().isEmpty ? null : _badgeController.text.trim(),
        'is_active': _isActive,
        // Styling fields
        'title_color': _titleColorController.text.trim(),
        'description_color': _descriptionColorController.text.trim(),
        'font_weight': _fontWeightController.text.trim(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (_isEdit) {
        await _adminService.updateProduct(widget.productId!, data);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product updated successfully')),
          );
          context.go('/admin/store');
        }
      } else {
        await _adminService.createProduct(data);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product created successfully')),
          );
          context.go('/admin/store');
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
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
    _priceController.dispose();
    _originalPriceController.dispose();
    _iconController.dispose();
    _badgeController.dispose();
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
        body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xxxl),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => context.go('/admin/store'),
                  icon: const Icon(Icons.arrow_back_rounded),
                  color: AppColors.textPrimary,
                ),
                const SizedBox(width: AppSpacing.md),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isEdit ? 'Edit Product' : 'Create New Product',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

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
                        label: 'Product Name',
                        hint: 'Enter product name',
                        icon: Icons.store_rounded,
                        validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      
                      _buildTextField(
                        controller: _descriptionController,
                        label: 'Description',
                        hint: 'Product description',
                        icon: Icons.description_rounded,
                        maxLines: 3,
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _priceController,
                              label: 'Price',
                              hint: '0.00',
                              icon: Icons.attach_money_rounded,
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) return 'Required';
                                if (double.tryParse(v) == null) return 'Invalid number';
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: AppSpacing.lg),
                          Expanded(
                            child: _buildTextField(
                              controller: _originalPriceController,
                              label: 'Original Price',
                              hint: 'Optional',
                              icon: Icons.money_off_rounded,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _iconController,
                              label: 'Icon URL',
                              hint: 'https://...',
                              icon: Icons.image_rounded,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.lg),
                          Expanded(
                            child: _buildTextField(
                              controller: _badgeController,
                              label: 'Badge (Optional)',
                              hint: 'e.g., NEW, SALE',
                              icon: Icons.label_rounded,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      CheckboxListTile(
                        title: const Text('Active', style: TextStyle(color: AppColors.textPrimary)),
                        subtitle: const Text('Product is visible in store', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                        value: _isActive,
                        onChanged: (v) => setState(() => _isActive = v ?? true),
                        activeColor: AppColors.primary,
                        tileColor: AppColors.card,
                        shape: RoundedRectangleBorder(borderRadius: AppRadius.input),
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

                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _loading ? null : () => context.go('/admin/store'),
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
                              onPressed: _loading ? null : _saveProduct,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(AppSpacing.lg),
                              ),
                              child: _loading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
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
        Text(label, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
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
            border: OutlineInputBorder(borderRadius: AppRadius.input, borderSide: const BorderSide(color: AppColors.border)),
            enabledBorder: OutlineInputBorder(borderRadius: AppRadius.input, borderSide: const BorderSide(color: AppColors.border)),
            focusedBorder: OutlineInputBorder(borderRadius: AppRadius.input, borderSide: const BorderSide(color: AppColors.primary, width: 2)),
            errorBorder: OutlineInputBorder(borderRadius: AppRadius.input, borderSide: const BorderSide(color: Colors.red)),
            focusedErrorBorder: OutlineInputBorder(borderRadius: AppRadius.input, borderSide: const BorderSide(color: Colors.red, width: 2)),
          ),
        ),
      ],
    );
  }
}
