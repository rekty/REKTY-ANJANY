import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_shadow.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../shared/layout/responsive_container.dart';
import '../../../shared/layout/section_title.dart';

class DownloadsSection extends StatelessWidget {
  const DownloadsSection({super.key});

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
              title: 'Downloads',
              subtitle:
                  'Download the latest applications, tools and resources.',
            ),

            SizedBox(height: AppSpacing.massive),

            Wrap(
              spacing: AppSpacing.xxl,
              runSpacing: AppSpacing.xxl,
              children: [
                _DownloadCard(
                  title: 'Rekty AI',
                  version: 'v1.0.0',
                  description:
                      'AI Chat & Image Generation powered by Pollinations.',
                  icon: Icons.smart_toy_rounded,
                ),

                _DownloadCard(
                  title: 'Rekty POS',
                  version: 'v1.0.0',
                  description:
                      'Modern Point of Sale for Android.',
                  icon: Icons.point_of_sale_rounded,
                ),

                _DownloadCard(
                  title: 'Coming Soon',
                  version: '--',
                  description:
                      'More applications will be available soon.',
                  icon: Icons.download_rounded,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DownloadCard extends StatelessWidget {
  final String title;
  final String version;
  final String description;
  final IconData icon;

  const _DownloadCard({
    required this.title,
    required this.version,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 340,
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: const BoxDecoration(
        color: AppColors.card,
        borderRadius: AppRadius.card,
        boxShadow: AppShadow.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: AppColors.primary,
            size: 52,
          ),

          const SizedBox(height: AppSpacing.xl),

          Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: AppSpacing.sm),

          Text(
            version,
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          Text(
            description,
            style: const TextStyle(
              color: AppColors.textSecondary,
              height: 1.7,
            ),
          ),

          const SizedBox(height: AppSpacing.xxl),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                // Nanti diarahkan ke GitHub Release
              },
              icon: const Icon(Icons.download),
              label: const Text("Download"),
            ),
          ),
        ],
      ),
    );
  }
}