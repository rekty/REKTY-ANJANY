import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_radius.dart';
import '../../core/constants/app_shadow.dart';
import '../../core/constants/app_spacing.dart';
// import '../../core/services/supabase_service.dart'; // TEMPORARILY DISABLED
import '../../shared/layout/app_scaffold.dart';
import '../../shared/layout/responsive_container.dart';
import '../../shared/layout/section_title.dart';

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
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      // final products = await SupabaseService.instance.getProducts(limit: 50); // TEMPORARILY DISABLED
      // Dummy data for now
      final products = <Map<String, dynamic>>[
        {
          'id': '1',
          'name': 'Flutter UI Kit Pro',
          'description': 'Premium collection of 100+ Flutter widgets and components with dark mode support, animations, and responsive layouts ready for production.',
          'price': 49.0,
          'original_price': 79.0,
          'icon': 'auto_awesome_rounded',
          'badge': 'SALE',
          'rating': 4.9,
          'sales_count': 234,
        },
        {
          'id': '2',
          'name': 'AI Integration Pack',
          'description': 'Complete AI toolkit for Flutter including chat interfaces, image generation, voice recognition, and pre-built AI model integrations.',
          'price': 69.0,
          'icon': 'smart_toy_rounded',
          'badge': 'NEW',
          'rating': 5.0,
          'sales_count': 89,
        },
        {
          'id': '3',
          'name': 'POS Source Code',
          'description': 'Full source code of professional Point of Sale system with inventory management, sales analytics, customer database, and receipt printing.',
          'price': 149.0,
          'icon': 'point_of_sale_rounded',
          'badge': 'FEATURED',
          'rating': 4.8,
          'sales_count': 156,
        },
        {
          'id': '4',
          'name': 'Developer Course Bundle',
          'description': 'Comprehensive development course covering Flutter, React, Node.js, and Firebase with 50+ hours of video content and project files.',
          'price': 99.0,
          'original_price': 149.0,
          'icon': 'school_rounded',
          'badge': 'HOT',
          'rating': 4.9,
          'sales_count': 421,
        },
      ];
      setState(() {
        _products = products;
        _isLoading = false;
      });
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
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(color: AppColors.primary),
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
                    child: Icon(
                      _getIcon(),
                      size: 72,
                      color: AppColors.primary,
                    ),
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
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: AppSpacing.sm),

                  // Description
                  Text(
                    widget.product['description'] ?? '',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
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
