import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../shared/layout/responsive_container.dart';
import '../../../shared/layout/section_title.dart';

class BlogSection extends StatelessWidget {
  const BlogSection({super.key});

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
              title: 'Latest Blog',
              subtitle:
                  'Read articles, tutorials and updates from the Rekty ecosystem.',
            ),

            SizedBox(height: AppSpacing.massive),

            Wrap(
              spacing: AppSpacing.xxl,
              runSpacing: AppSpacing.xxl,
              children: [
                _BlogCard(
                  tag: 'Flutter',
                  title: 'Building a Modern UI with Flutter Web',
                  excerpt:
                      'Explore how to create stunning, responsive web experiences using Flutter and its powerful widget system.',
                  date: 'Jan 10, 2025',
                  readTime: '5 min read',
                  icon: Icons.flutter_dash,
                  iconColor: Color(0xFF54C5F8),
                ),
                _BlogCard(
                  tag: 'AI',
                  title: 'Integrating Pollinations AI into Flutter',
                  excerpt:
                      'A step-by-step guide to connecting Pollinations AI API for image generation and chat in your Flutter apps.',
                  date: 'Feb 3, 2025',
                  readTime: '7 min read',
                  icon: Icons.smart_toy_rounded,
                  iconColor: Color(0xFF818CF8),
                ),
                _BlogCard(
                  tag: 'POS',
                  title: 'Modern Point of Sale Architecture',
                  excerpt:
                      'How we designed the Rekty POS system to handle real-time transactions with offline support.',
                  date: 'Mar 15, 2025',
                  readTime: '6 min read',
                  icon: Icons.point_of_sale_rounded,
                  iconColor: Color(0xFF34D399),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BlogCard extends StatefulWidget {
  final String tag;
  final String title;
  final String excerpt;
  final String date;
  final String readTime;
  final IconData icon;
  final Color iconColor;

  const _BlogCard({
    required this.tag,
    required this.title,
    required this.excerpt,
    required this.date,
    required this.readTime,
    required this.icon,
    required this.iconColor,
  });

  @override
  State<_BlogCard> createState() => _BlogCardState();
}

class _BlogCardState extends State<_BlogCard> {
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
                ? AppColors.primary.withValues(alpha: .35)
                : AppColors.border,
          ),
          boxShadow: _hover
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: .10),
                    blurRadius: 28,
                    spreadRadius: 2,
                  ),
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tag
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: widget.iconColor.withValues(alpha: .12),
                borderRadius: AppRadius.roundRadius,
                border: Border.all(
                  color: widget.iconColor.withValues(alpha: .25),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    widget.icon,
                    size: 14,
                    color: widget.iconColor,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    widget.tag,
                    style: TextStyle(
                      color: widget.iconColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // Title
            Text(
              widget.title,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                height: 1.4,
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            // Excerpt
            Text(
              widget.excerpt,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 15,
                height: 1.7,
              ),
            ),

            const SizedBox(height: AppSpacing.xxl),

            // Footer
            Row(
              children: [
                const Icon(
                  Icons.calendar_today_rounded,
                  size: 14,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 6),
                Text(
                  widget.date,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                const Icon(
                  Icons.access_time_rounded,
                  size: 14,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 6),
                Text(
                  widget.readTime,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_rounded,
                  size: 16,
                  color: _hover ? AppColors.primary : AppColors.textSecondary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
