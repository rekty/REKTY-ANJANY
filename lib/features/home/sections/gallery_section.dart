import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../shared/layout/responsive_container.dart';
import '../../../shared/layout/section_title.dart';

class GallerySection extends StatelessWidget {
  const GallerySection({super.key});

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
              title: 'Gallery',
              subtitle: 'A showcase of creative works, screenshots and design assets.',
            ),

            SizedBox(height: AppSpacing.massive),

            _GalleryGrid(),
          ],
        ),
      ),
    );
  }
}

class _GalleryGrid extends StatelessWidget {
  const _GalleryGrid();

  static const List<_GalleryItem> items = [
    _GalleryItem(
      title: 'Rekty AI — Chat Interface',
      category: 'App Screenshot',
      icon: Icons.smart_toy_rounded,
      color: Color(0xFF54C5F8),
    ),
    _GalleryItem(
      title: 'Rekty POS — Dashboard',
      category: 'App Screenshot',
      icon: Icons.point_of_sale_rounded,
      color: Color(0xFF34D399),
    ),
    _GalleryItem(
      title: 'UI Design System',
      category: 'Design',
      icon: Icons.palette_rounded,
      color: Color(0xFFA78BFA),
    ),
    _GalleryItem(
      title: 'Mobile App Mockup',
      category: 'Mockup',
      icon: Icons.phone_android_rounded,
      color: Color(0xFFFBBF24),
    ),
    _GalleryItem(
      title: 'Web Dashboard',
      category: 'App Screenshot',
      icon: Icons.web_rounded,
      color: Color(0xFFF472B6),
    ),
    _GalleryItem(
      title: 'Dark Theme Preview',
      category: 'Design',
      icon: Icons.dark_mode_rounded,
      color: Color(0xFF00E5FF),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.xl,
      runSpacing: AppSpacing.xl,
      children: items
          .map((item) => _GalleryCard(item: item))
          .toList(),
    );
  }
}

class _GalleryItem {
  final String title;
  final String category;
  final IconData icon;
  final Color color;

  const _GalleryItem({
    required this.title,
    required this.category,
    required this.icon,
    required this.color,
  });
}

class _GalleryCard extends StatefulWidget {
  final _GalleryItem item;

  const _GalleryCard({required this.item});

  @override
  State<_GalleryCard> createState() => _GalleryCardState();
}

class _GalleryCardState extends State<_GalleryCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 300,
        height: 220,
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: AppRadius.card,
          border: Border.all(
            color: _hover
                ? widget.item.color.withValues(alpha: .40)
                : AppColors.border,
          ),
          boxShadow: _hover
              ? [
                  BoxShadow(
                    color: widget.item.color.withValues(alpha: .15),
                    blurRadius: 30,
                    spreadRadius: 2,
                  ),
                ]
              : [],
        ),
        child: Stack(
          children: [
            // Background glow
            if (_hover)
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: AppRadius.card,
                    gradient: RadialGradient(
                      colors: [
                        widget.item.color.withValues(alpha: .06),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

            // Content
            Padding(
              padding: const EdgeInsets.all(AppSpacing.cardPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon area
                  Expanded(
                    child: Center(
                      child: AnimatedScale(
                        scale: _hover ? 1.1 : 1.0,
                        duration: const Duration(milliseconds: 200),
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: widget.item.color.withValues(alpha: .12),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: widget.item.color.withValues(alpha: .25),
                            ),
                          ),
                          child: Icon(
                            widget.item.icon,
                            color: widget.item.color,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.md),

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

                  const SizedBox(height: AppSpacing.xs),

                  // Title
                  Text(
                    widget.item.title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
