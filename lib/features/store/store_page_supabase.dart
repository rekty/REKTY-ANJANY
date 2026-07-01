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
import '../../shared/widgets/loading/skeleton_loader.dart';

class StorePageSupabase extends StatefulWidget {
  const StorePageSupabase({super.key});

  @override
  State<StorePageSupabase> createState() => _StorePageSupabaseState();
}

class _StorePageSupabaseState extends State<StorePageSupabase> {
  List<Map<String, dynamic>> _products = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    // Set SEO meta tags
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SeoService.instance.updatePageMeta(
        title: 'Store - Rekty Anjany',
        description: 'Premium digital products, tools, and resources for developers and creators. Shop quality products from Rekty Anjany.',
        keywords: 'store, shop, digital products, tools, resources, premium, Rekty Anjany',
        url: 'https://rekty-anjany-5a2eb.web.app/#/store',
        type: 'website',
      );
    });
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await http.get(
        Uri.parse('${SupabaseConfig.supabaseUrl}/rest/v1/products?select=*&is_active=eq.true&order=created_at.desc'),
        headers: {
          'apikey': SupabaseConfig.supabaseAnonKey,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _products = data.cast<Map<String, dynamic>>();
          // Add 1 sample dummy data if empty
          if (_products.isEmpty) {
            _products = [
              {
                'id': 'sample-1',
                'name': 'Sample Product',
                'description': 'This is a sample product. Add your own products from admin panel!',
                'price': 49.0,
                'original_price': 79.0,
                'icon': 'shopping_bag_rounded',
                'badge': 'SAMPLE',
                'rating': 5.0,
                'sales_count': 0,
              }
            ];
          }
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
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
            child: const ResponsiveContainer(
              child: SectionTitle(
                title: 'Store',
                subtitle:
                    'Premium digital products, tools, and resources for developers and creators.',
              ),
            ),
          ),

          // Content
          if (_isLoading)
            Expanded(
              child: ResponsiveContainer(
                child: SkeletonGrid(itemCount: 6, crossAxisCount: 3),
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
                      onPressed: _loadProducts,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            )
          else if (_products.isEmpty)
            const Expanded(
              child: Center(
                child: Text(
                  'No products available yet',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            )
          else
            ResponsiveContainer(
              child: Wrap(
                spacing: AppSpacing.xxl,
                runSpacing: AppSpacing.xxl,
                children:
                    _products.map((product) => _ProductCard(product: product)).toList(),
              ),
            ),

          const SizedBox(height: AppSpacing.hero),
        ],
      ),
    );
  }
}

class _ProductCard extends StatefulWidget {
  final Map<String, dynamic> product;

  const _ProductCard({required this.product});

  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> {
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

  IconData _getIcon() {
    final iconStr = widget.product['icon'] as String?;
    switch (iconStr) {
      case 'auto_awesome_rounded':
        return Icons.auto_awesome_rounded;
      case 'point_of_sale_rounded':
        return Icons.point_of_sale_rounded;
      case 'palette_rounded':
        return Icons.palette_rounded;
      case 'code_rounded':
        return Icons.code_rounded;
      case 'phone_android_rounded':
        return Icons.phone_android_rounded;
      case 'web_rounded':
        return Icons.web_rounded;
      default:
        return Icons.shopping_bag_rounded;
    }
  }

  Widget _buildIconWidget() {
    final iconStr = widget.product['icon'] as String?;
    final isImageUrl = iconStr != null && (iconStr.startsWith('http://') || iconStr.startsWith('https://'));

    if (isImageUrl) {
      return ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: Image.network(
          iconStr!,
          width: double.infinity,
          height: 180,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              _getIcon(),
              size: 72,
              color: AppColors.primary.withValues(alpha: .4),
            );
          },
        ),
      );
    }

    return Icon(
      _getIcon(),
      size: 72,
      color: AppColors.primary.withValues(alpha: .4),
    );
  }

  Color _getBadgeColor(String? badge) {
    switch (badge?.toLowerCase()) {
      case 'new':
        return const Color(0xFF34D399);
      case 'sale':
        return const Color(0xFFF59E0B);
      case 'hot':
        return const Color(0xFFEF4444);
      case 'featured':
        return AppColors.primary;
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final price = widget.product['price'] as num?;
    final originalPrice = widget.product['original_price'] as num?;
    final badge = widget.product['badge'] as String?;
    final rating = widget.product['rating'] as num? ?? 5.0;
    final salesCount = widget.product['sales_count'] as int? ?? 0;
    
    // Dynamic styling from database
    final titleColor = _parseColor(widget.product['title_color'] as String?, AppColors.textPrimary);
    final descriptionColor = _parseColor(widget.product['description_color'] as String?, AppColors.textSecondary);
    final fontWeight = _parseFontWeight(widget.product['font_weight'] as String?);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 360,
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
            // Icon
            Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: .08),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: _buildIconWidget(),
                  ),
                  if (badge != null)
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _getBadgeColor(badge),
                          borderRadius: AppRadius.roundRadius,
                        ),
                        child: Text(
                          badge.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(AppSpacing.cardPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    widget.product['name'] ?? '',
                    style: TextStyle(
                      color: titleColor,
                      fontSize: 20,
                      fontWeight: fontWeight,
                    ),
                  ),

                  const SizedBox(height: AppSpacing.sm),

                  // Description
                  Text(
                    widget.product['description'] ?? '',
                    style: TextStyle(
                      color: descriptionColor,
                      fontSize: 14,
                      height: 1.6,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // Rating & Sales
                  Row(
                    children: [
                      const Icon(Icons.star_rounded,
                          size: 16, color: Color(0xFFFBBF24)),
                      const SizedBox(width: 4),
                      Text(
                        rating.toStringAsFixed(1),
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Text(
                        '$salesCount sales',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // Price & Button
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (originalPrice != null && originalPrice > price!)
                            Text(
                              '\$${originalPrice.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: AppColors.textDisabled,
                                fontSize: 13,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          Text(
                            '\$${price?.toStringAsFixed(2) ?? '0.00'}',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: const Text('Buy Now'),
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
