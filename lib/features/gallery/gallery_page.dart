import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_radius.dart';
import '../../core/constants/app_spacing.dart';
import '../../shared/layout/app_scaffold.dart';
import '../../shared/layout/responsive_container.dart';
import '../../shared/layout/section_title.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  String _selectedCategory = 'All';

  static const List<String> categories = [
    'All',
    'App Screenshots',
    'Design',
    'Mockups',
    'Wallpapers',
  ];

  static const List<_GalleryItem> items = [
    _GalleryItem(title: 'Rekty AI — Chat', category: 'App Screenshots', icon: Icons.smart_toy_rounded, color: Color(0xFF54C5F8)),
    _GalleryItem(title: 'Rekty AI — Image Gen', category: 'App Screenshots', icon: Icons.image_rounded, color: Color(0xFFA78BFA)),
    _GalleryItem(title: 'Rekty POS — Dashboard', category: 'App Screenshots', icon: Icons.point_of_sale_rounded, color: Color(0xFF34D399)),
    _GalleryItem(title: 'Rekty POS — Products', category: 'App Screenshots', icon: Icons.inventory_2_rounded, color: Color(0xFF34D399)),
    _GalleryItem(title: 'UI Design System', category: 'Design', icon: Icons.palette_rounded, color: Color(0xFFA78BFA)),
    _GalleryItem(title: 'Color Palette', category: 'Design', icon: Icons.color_lens_rounded, color: Color(0xFFFBBF24)),
    _GalleryItem(title: 'Typography Guide', category: 'Design', icon: Icons.text_fields_rounded, color: Color(0xFFF472B6)),
    _GalleryItem(title: 'Phone Mockup', category: 'Mockups', icon: Icons.phone_android_rounded, color: Color(0xFFFBBF24)),
    _GalleryItem(title: 'Tablet Mockup', category: 'Mockups', icon: Icons.tablet_rounded, color: Color(0xFF54C5F8)),
    _GalleryItem(title: 'Desktop Mockup', category: 'Mockups', icon: Icons.desktop_mac_rounded, color: Color(0xFF34D399)),
    _GalleryItem(title: 'Cyan Grid', category: 'Wallpapers', icon: Icons.grid_on_rounded, color: Color(0xFF00E5FF)),
    _GalleryItem(title: 'Dark Nebula', category: 'Wallpapers', icon: Icons.nights_stay_rounded, color: Color(0xFFA78BFA)),
  ];

  List<_GalleryItem> get _filtered => _selectedCategory == 'All'
      ? items
      : items.where((i) => i.category == _selectedCategory).toList();

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
                title: 'Gallery',
                subtitle:
                    'A curated showcase of app screenshots, design work, and creative assets.',
              ),
            ),
          ),

          // Filter tabs
          ResponsiveContainer(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categories.map((cat) {
                  final selected = cat == _selectedCategory;
                  return Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.md),
                    child: _CategoryChip(
                      label: cat,
                      selected: selected,
                      onTap: () => setState(() => _selectedCategory = cat),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.massive),

          // Grid
          ResponsiveContainer(
            child: Wrap(
              spacing: AppSpacing.xl,
              runSpacing: AppSpacing.xl,
              children: _filtered
                  .map((item) => _GalleryCard(item: item))
                  .toList(),
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
  final bool selected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: .15)
              : AppColors.card,
          borderRadius: AppRadius.roundRadius,
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? AppColors.primary : AppColors.textSecondary,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
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
        width: 260,
        height: 200,
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
                    blurRadius: 28,
                    spreadRadius: 2,
                  ),
                ]
              : [],
        ),
        child: Stack(
          children: [
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
            Padding(
              padding: const EdgeInsets.all(AppSpacing.cardPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Center(
                      child: AnimatedScale(
                        scale: _hover ? 1.12 : 1.0,
                        duration: const Duration(milliseconds: 200),
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color: widget.item.color.withValues(alpha: .12),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: widget.item.color.withValues(alpha: .25),
                            ),
                          ),
                          child: Icon(widget.item.icon,
                              color: widget.item.color, size: 36),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    widget.item.category,
                    style: TextStyle(
                      color: widget.item.color,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: .5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.item.title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
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
