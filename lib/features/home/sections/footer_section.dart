import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../shared/layout/responsive_container.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.border),
        ),
      ),
      child: const ResponsiveContainer(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.xxxl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _FooterTop(),
              SizedBox(height: AppSpacing.xxxl),
              Divider(color: AppColors.border, height: 1),
              SizedBox(height: AppSpacing.xl),
              _FooterBottom(),
            ],
          ),
        ),
      ),
    );
  }
}

class _FooterTop extends StatelessWidget {
  const _FooterTop();

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    if (isMobile) {
      return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FooterBrand(),
          SizedBox(height: AppSpacing.xxxl),
          _FooterLinks(
            title: 'Product',
            links: [
              _FooterLink('Apps', '/apps'),
              _FooterLink('Downloads', '/downloads'),
              _FooterLink('Store', '/store'),
              _FooterLink('Gallery', '/gallery'),
            ],
          ),
          SizedBox(height: AppSpacing.xxl),
          _FooterLinks(
            title: 'Company',
            links: [
              _FooterLink('About', '/about'),
              _FooterLink('Blog', '/blog'),
              _FooterLink('Contact', '/contact'),
            ],
          ),
        ],
      );
    }

    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 4, child: _FooterBrand()),
        Expanded(
          flex: 2,
          child: _FooterLinks(
            title: 'Product',
            links: [
              _FooterLink('Apps', '/apps'),
              _FooterLink('Downloads', '/downloads'),
              _FooterLink('Store', '/store'),
              _FooterLink('Gallery', '/gallery'),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: _FooterLinks(
            title: 'Company',
            links: [
              _FooterLink('About', '/about'),
              _FooterLink('Blog', '/blog'),
              _FooterLink('Contact', '/contact'),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: _FooterLinks(
            title: 'Social',
            links: [
              _FooterLink('GitHub', 'https://github.com'),
              _FooterLink('Telegram', 'https://t.me'),
              _FooterLink('YouTube', 'https://youtube.com'),
            ],
          ),
        ),
      ],
    );
  }
}

class _FooterBrand extends StatelessWidget {
  const _FooterBrand();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Logo
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'REKTY ANJANY',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.lg),

        const Text(
          'A modern Flutter ecosystem combining AI,\ndigital products, and creative tools.',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 15,
            height: 1.7,
          ),
        ),

        const SizedBox(height: AppSpacing.xl),

        // Tech chips
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ['Flutter', 'Dart', 'Firebase', 'AI'].map((t) {
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppRadius.roundRadius,
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: .15),
                ),
              ),
              child: Text(
                t,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _FooterLink {
  final String label;
  final String route;

  const _FooterLink(this.label, this.route);
}

class _FooterLinks extends StatelessWidget {
  final String title;
  final List<_FooterLink> links;

  const _FooterLinks({
    required this.title,
    required this.links,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        ...links.map(
          (link) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: _FooterLinkItem(link: link),
          ),
        ),
      ],
    );
  }
}

class _FooterLinkItem extends StatefulWidget {
  final _FooterLink link;

  const _FooterLinkItem({required this.link});

  @override
  State<_FooterLinkItem> createState() => _FooterLinkItemState();
}

class _FooterLinkItemState extends State<_FooterLinkItem> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 150),
        style: TextStyle(
          color: _hover ? AppColors.primary : AppColors.textSecondary,
          fontSize: 15,
        ),
        child: Text(widget.link.label),
      ),
    );
  }
}

class _FooterBottom extends StatelessWidget {
  const _FooterBottom();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Text(
          '© 2025 Rekty Anjany. All rights reserved.',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
        Spacer(),
        Text(
          'Built with ❤️ using Flutter',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
