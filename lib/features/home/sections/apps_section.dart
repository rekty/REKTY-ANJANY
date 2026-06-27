import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_shadow.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../shared/layout/responsive_container.dart';
import '../../../shared/layout/section_title.dart';

class AppsSection extends StatelessWidget {
  const AppsSection({super.key});

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
              title: "Our Applications",
              subtitle:
                  "Explore applications developed under the Rekty ecosystem.",
            ),

            SizedBox(height: AppSpacing.massive),

            Wrap(
              spacing: AppSpacing.xxl,
              runSpacing: AppSpacing.xxl,
              children: [

                _AppCard(
                  icon: Icons.smart_toy_rounded,
                  title: "Rekty AI",
                  description:
                      "AI Chat, Image Generation and Creative Assistant.",
                ),

                _AppCard(
                  icon: Icons.point_of_sale_rounded,
                  title: "Rekty POS",
                  description:
                      "Modern Point of Sale for Android built with Flutter.",
                ),

                _AppCard(
                  icon: Icons.rocket_launch_rounded,
                  title: "Coming Soon",
                  description:
                      "More innovative applications are currently under development.",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AppCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _AppCard({
    required this.icon,
    required this.title,
    required this.description,
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
            size: 56,
          ),

          const SizedBox(height: AppSpacing.xl),

          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          Text(
            description,
            style: const TextStyle(
              fontSize: 16,
              height: 1.7,
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: AppSpacing.xxl),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.arrow_forward),
              label: const Text("Open"),
            ),
          ),
        ],
      ),
    );
  }
}