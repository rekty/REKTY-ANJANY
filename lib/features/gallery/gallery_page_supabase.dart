import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_radius.dart';
import '../../core/constants/app_shadow.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/config/supabase_config.dart';
import '../../core/services/seo_service.dart';
import '../../shared/layout/app_scaffold.dart';
import '../../shared/layout/responsive_container.dart';
import '../../shared/layout/section_title.dart';
import '../../shared/widgets/image/lazy_image.dart';
import '../../shared/widgets/loading/skeleton_loader.dart';

class GalleryPageSupabase extends StatefulWidget {
  const GalleryPageSupabase({super.key});

  @override
  State<GalleryPageSupabase> createState() => _GalleryPageSupabaseState();
}

class _GalleryPageSupabaseState extends State<GalleryPageSupabase> {
  List<Map<String, dynamic>> _items = [];
  bool _isLoading = true;
  String? _error;
  String _selectedCategory = 'all';

  final List<Map<String, String>> _categories = const [
    {'id': 'all', 'label': 'All'},
    {'id': 'ui', 'label': 'UI Design'},
    {'id': 'mobile', 'label': 'Mobile'},
    {'id': 'web', 'label': 'Web'},
    {'id': 'design', 'label': 'Design'},
  ];

  @override
  void initState() {
    super.initState();
    // Set SEO meta tags
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SeoService.instance.updatePageMeta(
        title: 'Gallery - Rekty Anjany',
        description: 'Explore our collection of designs, mockups, and creative work. Visual portfolio by Rekty Anjany.',
        keywords: 'gallery, portfolio, designs, mockups, UI, UX, creative work, Rekty Anjany',
        url: 'https://rekty-anjany-5a2eb.web.app/#/gallery',
        type: 'website',
      );
    });
    _loadItems();
  }

  Future<void> _loadItems() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await http.get(
        Uri.parse('${SupabaseConfig.supabaseUrl}/rest/v1/gallery_items?select=*&order=display_order.asc,created_at.desc'),
        headers: {
          'apikey': SupabaseConfig.supabaseAnonKey,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _items = data.cast<Map<String, dynamic>>();
          // Add 1 sample dummy data if empty
          if (_items.isEmpty) {
            _items = [
              {
                'id': 'sample-1',
                'title': 'Sample Gallery Image',
                'image_url': 'https://images.unsplash.com/photo-1498050108023-c5249f4df085?w=800&h=600&fit=crop',
                'category': 'Design',
                'description': 'This is a sample image. Add your own gallery items from admin panel!',
              }
            ];
          }
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load gallery items');
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _onCategoryChanged(String category) {
    setState(() => _selectedCategory = category);
    _loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.hero),
            child: ResponsiveContainer(
              child: Column(
                children: [
                  const SectionTitle(
                    title: 'Gallery',
                    subtitle:
                        'Explore our collection of designs, mockups, and creative work.',
                  ),
                  const SizedBox(height: AppSpacing.xxl),

                  // Category Filter
                  Wrap(
                    spacing: AppSpacing.md,
                    runSpacing: AppSpacing.md,
                    alignment: WrapAlignment.center,
                    children: _categories.map((cat) {
                      final isSelected = _selectedCategory == cat['id'];
                      return _CategoryChip(
                        label: cat['label']!,
                        isSelected: isSelected,
                        onTap: () => _onCategoryChanged(cat['id']!),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),

          // Content
          if (_isLoading)
            Expanded(
              child: ResponsiveContainer(
                child: SkeletonGrid(
                  itemCount: 6,
                  crossAxisCount: 3,
                ),
              ),
            )
          else if (_error != null)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 64, color: AppColors.error),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'Error: $_error',
                      style: const TextStyle(color: AppColors.error),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    ElevatedButton(
                      onPressed: _loadItems,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            )
          else if (_items.isEmpty)
            Expanded(
              child: Center(
                child: Text(
                  _selectedCategory == 'all'
                      ? 'No gallery items yet'
                      : 'No items in this category',
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
              ),
            )
          else
            ResponsiveContainer(
              child: Wrap(
                spacing: AppSpacing.xl,
                runSpacing: AppSpacing.xl,
                children: _items.map((item) => _GalleryCard(item: item)).toList(),
              ),
            ),

          const SizedBox(height: AppSpacing.hero),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.roundRadius,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : AppColors.surface,
          borderRadius: AppRadius.roundRadius,
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class _GalleryCard extends StatefulWidget {
  final Map<String, dynamic> item;

  const _GalleryCard({required this.item});

  @override
  State<_GalleryCard> createState() => _GalleryCardState();
}

class _GalleryCardState extends State<_GalleryCard> {
  bool _hover = false;
  
  // Helper method to parse color from hex string
  Color _parseColor(String? hexColor, Color defaultColor) {
    if (hexColor == null || hexColor.isEmpty) return defaultColor;
    try {
      return Color(int.parse(hexColor.replaceFirst('#', ''), radix: 16) + 0xFF000000);
    } catch (e) {
      return defaultColor;
    }
  }

  // Helper method to parse font weight from string
  FontWeight _parseFontWeight(String? fontWeightStr) {
    switch (fontWeightStr) {
      case 'light':
        return FontWeight.w300;
      case 'normal':
        return FontWeight.w400;
      case 'semibold':
        return FontWeight.w600;
      case 'bold':
        return FontWeight.w700;
      default:
        return FontWeight.w700;
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = widget.item['image_url'] as String?;
    final title = widget.item['title'] as String? ?? 'Untitled';
    final category = widget.item['category'] as String? ?? '';
    
    // Dynamic styling from database
    final titleColor = _parseColor(widget.item['title_color'] as String?, AppColors.textPrimary);
    final descriptionColor = _parseColor(widget.item['description_color'] as String?, AppColors.textSecondary);
    final fontWeight = _parseFontWeight(widget.item['font_weight'] as String?);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 340,
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: AppRadius.card,
          border: Border.all(
            color:
                _hover ? AppColors.primary.withValues(alpha: .35) : AppColors.border,
          ),
          boxShadow: _hover ? AppShadow.cyanGlow : AppShadow.card,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              child: AspectRatio(
                aspectRatio: 4 / 3,
                child: imageUrl != null
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: AppColors.surface,
                            child: const Center(
                              child: Icon(
                                Icons.broken_image_outlined,
                                size: 48,
                                color: AppColors.textDisabled,
                              ),
                            ),
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: AppColors.surface,
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                            ),
                          );
                        },
                      )
                    : Container(
                        color: AppColors.surface,
                        child: const Center(
                          child: Icon(
                            Icons.image_outlined,
                            size: 48,
                            color: AppColors.textDisabled,
                          ),
                        ),
                      ),
              ),
            ),

            // Info
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: titleColor,
                      fontSize: 18,
                      fontWeight: fontWeight,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: .12),
                          borderRadius: AppRadius.roundRadius,
                        ),
                        child: Text(
                          category.toUpperCase(),
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
