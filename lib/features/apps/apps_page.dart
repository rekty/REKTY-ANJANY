import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_radius.dart';
import '../../core/constants/app_shadow.dart';
import '../../core/constants/app_spacing.dart';
import '../../shared/layout/app_scaffold.dart';
import '../../shared/layout/responsive_container.dart';
import '../../shared/layout/section_title.dart';

class AppsPage extends StatelessWidget {
  const AppsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      child: Column(
        children: [
          _AppsHeader(),
          _AppsList(),
          SizedBox(height: AppSpacing.hero),
        ],
      ),
    );
  }
}

class _AppsHeader extends StatelessWidget {
  const _AppsHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.hero),
      child: const ResponsiveContainer(
        child: SectionTitle(
          title: 'Our Applications',
          subtitle:
              'Rekty Anjany ecosystem .',
        ),
      ),
    );
  }
}

class _AppsList extends StatelessWidget {
  const _AppsList();

  static const List<_AppData> apps = [
    _AppData(
      icon: Icons.smart_toy_rounded,
      title: 'Rekty AI',
      tagline: 'AI Chat & Image Generation',
      description:
          'An intelligent AI assistant powered by Pollinations. Chat with AI, generate stunning images, and boost your creativity — all in one beautiful Flutter app.',
      platform: 'Android · Web',
      status: 'Available',
      statusColor: Color(0xFF34D399),
      color: Color(0xFF54C5F8),
      features: ['AI Chat', 'Image Generation', 'Dark Theme', 'Offline Mode'],
    ),
    _AppData(
      icon: Icons.point_of_sale_rounded,
      title: 'Rekty POS',
      tagline: 'Modern Point of Sale',
      description:
          'A full-featured point of sale system for Android businesses. Manage products, transactions, receipts and reports with a sleek, modern interface.',
      platform: 'Android',
      status: 'Available',
      statusColor: Color(0xFF34D399),
      color: Color(0xFF34D399),
      features: ['Inventory', 'Receipts', 'Reports', 'Multi User'],
    ),
    _AppData(
      icon: Icons.storefront_rounded,
      title: 'Rekty Store',
      tagline: 'Digital Marketplace',
      description:
          'Browse and purchase premium Flutter templates, UI kits, and full source codes. Everything you need to accelerate your Flutter development.',
      platform: 'Web',
      status: 'Coming Soon',
      statusColor: Color(0xFFFBBF24),
      color: Color(0xFFFBBF24),
      features: ['Templates', 'UI Kits', 'Source Code', 'Licenses'],
    ),
    _AppData(
      icon: Icons.photo_library_rounded,
      title: 'Rekty Gallery',
      tagline: 'Creative Asset Hub',
      description:
          'Explore a curated collection of design assets, app screenshots, and creative works from the Rekty ecosystem.',
      platform: 'Web',
      status: 'Coming Soon',
      statusColor: Color(0xFFFBBF24),
      color: Color(0xFFA78BFA),
      features: ['Design Assets', 'Screenshots', 'Mockups', 'Wallpapers'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ResponsiveContainer(
      child: Column(
        children: apps
            .map((app) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xxxl),
                  child: _AppDetailCard(app: app),
                ))
            .toList(),
      ),
    );
  }
}

class _AppData {
  final IconData icon;
  final String title;
  final String tagline;
  final String description;
  final String platform;
  final String status;
  final Color statusColor;
  final Color color;
  final List<String> features;

  const _AppData({
    required this.icon,
    required this.title,
    required this.tagline,
    required this.description,
    required this.platform,
    required this.status,
    required this.statusColor,
    required this.color,
    required this.features,
  });
}

class _AppDetailCard extends StatefulWidget {
  final _AppData app;

  const _AppDetailCard({required this.app});

  @override
  State<_AppDetailCard> createState() => _AppDetailCardState();
}

class _AppDetailCardState extends State<_AppDetailCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppSpacing.xxxl),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: AppRadius.card,
          border: Border.all(
            color: _hover
                ? widget.app.color.withValues(alpha: .35)
                : AppColors.border,
          ),
          boxShadow: _hover
              ? AppShadow.glow(color: widget.app.color, blur: 30)
              : AppShadow.card,
        ),
        child: isMobile
            ? _MobileCard(app: widget.app)
            : _DesktopCard(app: widget.app),
      ),
    );
  }
}

class _DesktopCard extends StatelessWidget {
  final _AppData app;

  const _DesktopCard({required this.app});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icon
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            color: app.color.withValues(alpha: .12),
            borderRadius: AppRadius.card,
            border: Border.all(color: app.color.withValues(alpha: .25)),
          ),
          child: Icon(app.icon, color: app.color, size: 44),
        ),

        const SizedBox(width: AppSpacing.xxxl),

        // Content
        Expanded(
          child: _AppContent(app: app),
        ),
      ],
    );
  }
}

class _MobileCard extends StatelessWidget {
  final _AppData app;

  const _MobileCard({required this.app});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: app.color.withValues(alpha: .12),
            borderRadius: AppRadius.card,
            border: Border.all(color: app.color.withValues(alpha: .25)),
          ),
          child: Icon(app.icon, color: app.color, size: 36),
        ),
        const SizedBox(height: AppSpacing.xl),
        _AppContent(app: app),
      ],
    );
  }
}

class _AppContent extends StatelessWidget {
  final _AppData app;

  const _AppContent({required this.app});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title + Status
        Row(
          children: [
            Text(
              app.title,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: app.statusColor.withValues(alpha: .12),
                borderRadius: AppRadius.roundRadius,
                border: Border.all(color: app.statusColor.withValues(alpha: .30)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.circle, size: 8, color: app.statusColor),
                  const SizedBox(width: 6),
                  Text(
                    app.status,
                    style: TextStyle(
                      color: app.statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.sm),

        Text(
          app.tagline,
          style: TextStyle(
            color: app.color,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: AppSpacing.lg),

        Text(
          app.description,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 16,
            height: 1.7,
          ),
        ),

        const SizedBox(height: AppSpacing.xl),

        // Features
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: app.features.map((f) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: app.color.withValues(alpha: .08),
                borderRadius: AppRadius.roundRadius,
                border: Border.all(color: app.color.withValues(alpha: .20)),
              ),
              child: Text(
                f,
                style: TextStyle(
                  color: app.color,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: AppSpacing.xxl),

        // Platform + Button
        Row(
          children: [
            const Icon(
              Icons.devices_rounded,
              size: 16,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              app.platform,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.open_in_new_rounded, size: 16),
              label: const Text('Open App'),
            ),
          ],
        ),
      ],
    );
  }
}
