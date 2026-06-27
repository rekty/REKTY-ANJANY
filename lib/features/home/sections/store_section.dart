import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_shadow.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../shared/layout/responsive_container.dart';
import '../../../shared/layout/section_title.dart';

class StoreSection extends StatelessWidget {
  const StoreSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.hero,
      ),
      child: const ResponsiveContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionTitle(
              title: 'Marketplace',
              subtitle:
                  'Browse and purchase premium digital products, templates and tools.',
            ),

            SizedBox(height: AppSpacing.massive),

            Wrap(
              spacing: AppSpacing.xxl,
              runSpacing: AppSpacing.xxl,
              children: [
                _StoreCard(
                  icon: Icons.dashboard_customize_rounded,
                  title: 'Flutter UI Kit',
                  description:
                      'Premium Flutter component library with 100+ ready-to-use widgets.',
                  price: '\$29',
                  badge: 'BESTSELLER',
                  badgeColor: Color(0xFFFBBF24),
                ),
                _StoreCard(
                  icon: Icons.smart_toy_rounded,
                  title: 'AI Integration Pack',
                  description:
                      'Plug-and-play AI features for Flutter: chat, image gen, and more.',
                  price: '\$49',
                  badge: 'NEW',
                  badgeColor: Color(0xFF34D399),
                ),
                _StoreCard(
                  icon: Icons.point_of_sale_rounded,
                  title: 'POS Source Code',
                  description:
                      'Full source code of Rekty POS with documentation and support.',
                  price: '\$99',
                  badge: 'PREMIUM',
                  badgeColor: Color(0xFFA78BFA),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StoreCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;
  final String price;
  final String badge;
  final Color badgeColor;

  const _StoreCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.price,
    required this.badge,
    required this.badgeColor,
  });

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
        width: 340,
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: AppRadius.card,
          border: Border.all(
            color: _hover
                ? AppColors.primary.withValues(alpha: .35)
                : AppColors.border,
          ),
          boxShadow: _hover ? AppShadow.cyanGlow : AppShadow.card,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: .10),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: .20),
                    ),
                  ),
                  child: Icon(
                    widget.icon,
                    color: AppColors.primary,
                    size: 28,
                  ),
                ),

                const Spacer(),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: widget.badgeColor.withValues(alpha: .12),
                    borderRadius: AppRadius.roundRadius,
                    border: Border.all(
                      color: widget.badgeColor.withValues(alpha: .30),
                    ),
                  ),
                  child: Text(
                    widget.badge,
                    style: TextStyle(
                      color: widget.badgeColor,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: .5,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.xl),

            // Title
            Text(
              widget.title,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            // Description
            Text(
              widget.description,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 15,
                height: 1.7,
              ),
            ),

            const SizedBox(height: AppSpacing.xxl),

            // Price + Buy button
            Row(
              children: [
                Text(
                  widget.price,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const Spacer(),

                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.shopping_cart_rounded, size: 18),
                  label: const Text('Buy Now'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xl,
                      vertical: AppSpacing.md,
                    ),
                    shape: const RoundedRectangleBorder(
                      borderRadius: AppRadius.button,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
