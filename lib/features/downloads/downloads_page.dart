import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_radius.dart';
import '../../core/constants/app_shadow.dart';
import '../../core/constants/app_spacing.dart';
import '../../shared/layout/app_scaffold.dart';
import '../../shared/layout/responsive_container.dart';
import '../../shared/layout/section_title.dart';

class DownloadsPage extends StatelessWidget {
  const DownloadsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      child: Column(
        children: [
          _DownloadsHeader(),
          _DownloadsList(),
          SizedBox(height: AppSpacing.hero),
        ],
      ),
    );
  }
}

class _DownloadsHeader extends StatelessWidget {
  const _DownloadsHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.hero),
      child: const ResponsiveContainer(
        child: SectionTitle(
          title: 'Downloads',
          subtitle:
              'Download the latest APKs, tools and resources from the Rekty Anjany ecosystem.',
        ),
      ),
    );
  }
}

class _DownloadsList extends StatelessWidget {
  const _DownloadsList();

  static const List<_DownloadData> items = [
    _DownloadData(
      icon: Icons.smart_toy_rounded,
      title: 'Rekty AI',
      version: 'v1.0.0',
      size: '18.5 MB',
      platform: 'Android',
      platformIcon: Icons.android_rounded,
      description:
          'AI Chat and Image Generation app powered by Pollinations. Requires Android 7.0+',
      changelog: [
        'Initial release',
        'AI Chat with context memory',
        'Image generation support',
        'Dark theme',
      ],
      color: Color(0xFF54C5F8),
    ),
    _DownloadData(
      icon: Icons.point_of_sale_rounded,
      title: 'Rekty POS',
      version: 'v1.0.0',
      size: '22.1 MB',
      platform: 'Android',
      platformIcon: Icons.android_rounded,
      description:
          'Full-featured Point of Sale app for small and medium businesses. Requires Android 8.0+',
      changelog: [
        'Initial release',
        'Product management',
        'Transaction history',
        'Receipt printing',
      ],
      color: Color(0xFF34D399),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ResponsiveContainer(
      child: Column(
        children: items
            .map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xxxl),
                  child: _DownloadCard(data: item),
                ))
            .toList(),
      ),
    );
  }
}

class _DownloadData {
  final IconData icon;
  final String title;
  final String version;
  final String size;
  final String platform;
  final IconData platformIcon;
  final String description;
  final List<String> changelog;
  final Color color;

  const _DownloadData({
    required this.icon,
    required this.title,
    required this.version,
    required this.size,
    required this.platform,
    required this.platformIcon,
    required this.description,
    required this.changelog,
    required this.color,
  });
}

class _DownloadCard extends StatefulWidget {
  final _DownloadData data;

  const _DownloadCard({required this.data});

  @override
  State<_DownloadCard> createState() => _DownloadCardState();
}

class _DownloadCardState extends State<_DownloadCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
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
                ? widget.data.color.withValues(alpha: .35)
                : AppColors.border,
          ),
          boxShadow: _hover
              ? AppShadow.glow(color: widget.data.color, blur: 28)
              : AppShadow.card,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: widget.data.color.withValues(alpha: .12),
                    borderRadius: AppRadius.card,
                    border: Border.all(
                        color: widget.data.color.withValues(alpha: .25)),
                  ),
                  child: Icon(widget.data.icon,
                      color: widget.data.color, size: 36),
                ),

                const SizedBox(width: AppSpacing.xl),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.data.title,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          _InfoChip(
                            icon: Icons.tag_rounded,
                            label: widget.data.version,
                            color: widget.data.color,
                          ),
                          const SizedBox(width: 10),
                          _InfoChip(
                            icon: widget.data.platformIcon,
                            label: widget.data.platform,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 10),
                          _InfoChip(
                            icon: Icons.folder_rounded,
                            label: widget.data.size,
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.xl),

            // Description
            Text(
              widget.data.description,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 15,
                height: 1.7,
              ),
            ),

            const SizedBox(height: AppSpacing.xxl),

            // Changelog
            const Text(
              "What's New",
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            ...widget.data.changelog.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.check_rounded,
                          size: 16, color: widget.data.color),
                      const SizedBox(width: 10),
                      Text(
                        item,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                )),

            const SizedBox(height: AppSpacing.xxl),

            // Download button
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.download_rounded),
                    label: const Text('Download APK'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.lg,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.code_rounded),
                  label: const Text('Source'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
