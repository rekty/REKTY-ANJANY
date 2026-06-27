import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_radius.dart';
import '../../core/constants/app_shadow.dart';
import '../../core/constants/app_spacing.dart';
import '../../shared/layout/app_scaffold.dart';
import '../../shared/layout/responsive_container.dart';
import '../../shared/layout/section_title.dart';

class StorePage extends StatelessWidget {
  const StorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      child: Column(
        children: [
          _StoreHeader(),
          _StoreGrid(),
          SizedBox(height: AppSpacing.hero),
        ],
      ),
    );
  }
}

class _StoreHeader extends StatelessWidget {
  const _StoreHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.hero),
      child: const ResponsiveContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionTitle(
              title: 'Marketplace',
              subtitle:
                  'Premium Flutter templates, UI kits, and full source codes to accelerate your development.',
            ),
          ],
        ),
      ),
    );
  }
}

class _StoreGrid extends StatelessWidget {
  const _StoreGrid();

  static const List<_StoreItem> items = [
    _StoreItem(
      icon: Icons.dashboard_customize_rounded,
      title: 'Flutter UI Kit',
      category: 'UI Component',
      description:
          'Premium Flutter component library with 100+ customizable widgets. Perfect for building modern mobile and web apps.',
      price: '\$29',
      originalPrice: '\$49',
      badge: 'BESTSELLER',
      badgeColor: Color(0xFFFBBF24),
      color: Color(0xFF54C5F8),
      rating: '4.9',
      sales: '240+',
    ),
    _StoreItem(
      icon: Icons.smart_toy_rounded,
      title: 'AI Integration Pack',
      category: 'Package',
      description:
          'Plug-and-play AI features for Flutter: chat, image generation, speech-to-text, and more — ready to use.',
      price: '\$49',
      originalPrice: null,
      badge: 'NEW',
      badgeColor: Color(0xFF34D399),
      color: Color(0xFFA78BFA),
      rating: '4.8',
      sales: '85+',
    ),
    _StoreItem(
      icon: Icons.point_of_sale_rounded,
      title: 'POS Source Code',
      category: 'Full Source',
      description:
          'Complete Flutter POS app source code with inventory, transactions, receipt printing and admin panel.',
      price: '\$99',
      originalPrice: '\$149',
      badge: 'PREMIUM',
      badgeColor: Color(0xFFA78BFA),
      color: Color(0xFF34D399),
      rating: '5.0',
      sales: '60+',
    ),
    _StoreItem(
      icon: Icons.web_rounded,
      title: 'Portfolio Website Template',
      category: 'Template',
      description:
          'A sleek Flutter Web portfolio template with animations, responsive layout and customizable sections.',
      price: '\$19',
      originalPrice: null,
      badge: 'POPULAR',
      badgeColor: Color(0xFFF472B6),
      color: Color(0xFFFBBF24),
      rating: '4.7',
      sales: '310+',
    ),
    _StoreItem(
      icon: Icons.analytics_rounded,
      title: 'Admin Dashboard Kit',
      category: 'Template',
      description:
          'Modern Flutter admin dashboard with charts, tables, analytics widgets and dark/light themes.',
      price: '\$39',
      originalPrice: '\$59',
      badge: 'HOT',
      badgeColor: Color(0xFFF87171),
      color: Color(0xFFF472B6),
      rating: '4.8',
      sales: '170+',
    ),
    _StoreItem(
      icon: Icons.chat_bubble_rounded,
      title: 'Chat App Template',
      category: 'Template',
      description:
          'Complete Flutter chat application template with Firebase integration, media sharing and group chat.',
      price: '\$34',
      originalPrice: null,
      badge: 'NEW',
      badgeColor: Color(0xFF34D399),
      color: Color(0xFF54C5F8),
      rating: '4.6',
      sales: '45+',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ResponsiveContainer(
      child: Wrap(
        spacing: AppSpacing.xxl,
        runSpacing: AppSpacing.xxl,
        children: items.map((item) => _StoreCard(item: item)).toList(),
      ),
    );
  }
}

class _StoreItem {
  final IconData icon;
  final String title;
  final String category;
  final String description;
  final String price;
  final String? originalPrice;
  final String badge;
  final Color badgeColor;
  final Color color;
  final String rating;
  final String sales;

  const _StoreItem({
    required this.icon,
    required this.title,
    required this.category,
    required this.description,
    required this.price,
    required this.originalPrice,
    required this.badge,
    required this.badgeColor,
    required this.color,
    required this.rating,
    required this.sales,
  });
}

class _StoreCard extends StatefulWidget {
  final _StoreItem item;

  const _StoreCard({required this.item});

  @override
  State<_StoreCard> createState() => _StoreCardState();
}

class _StoreCardState extends State<_StoreCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 360,
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: AppRadius.card,
          border: Border.all(
            color: _hover
                ? widget.item.color.withValues(alpha: .35)
                : AppColors.border,
          ),
          boxShadow: _hover
              ? AppShadow.glow(color: widget.item.color)
              : AppShadow.card,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: widget.item.color.withValues(alpha: .12),
                    borderRadius: AppRadius.card,
                    border: Border.all(
                        color: widget.item.color.withValues(alpha: .25)),
                  ),
                  child: Icon(widget.item.icon,
                      color: widget.item.color, size: 26),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: widget.item.badgeColor.withValues(alpha: .12),
                    borderRadius: AppRadius.roundRadius,
                    border: Border.all(
                        color: widget.item.badgeColor.withValues(alpha: .30)),
                  ),
                  child: Text(
                    widget.item.badge,
                    style: TextStyle(
                      color: widget.item.badgeColor,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.lg),

            // Category
            Text(
              widget.item.category,
              style: TextStyle(
                color: widget.item.color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: .5,
              ),
            ),

            const SizedBox(height: AppSpacing.sm),

            // Title
            Text(
              widget.item.title,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            // Description
            Text(
              widget.item.description,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                height: 1.7,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: AppSpacing.xl),

            // Stats
            Row(
              children: [
                const Icon(Icons.star_rounded,
                    size: 16, color: Color(0xFFFBBF24)),
                const SizedBox(width: 4),
                Text(
                  widget.item.rating,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                const Icon(Icons.shopping_bag_rounded,
                    size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(
                  '${widget.item.sales} sales',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.xl),

            // Price + Button
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.item.originalPrice != null)
                      Text(
                        widget.item.originalPrice!,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    Text(
                      widget.item.price,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.shopping_cart_rounded, size: 16),
                  label: const Text('Buy'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
