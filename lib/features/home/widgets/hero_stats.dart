import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';

class HeroStats extends StatelessWidget {
  const HeroStats({super.key});

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      spacing: AppSpacing.xl,
      runSpacing: AppSpacing.xl,
      children: [
        HeroStatItem(
          value: "25+",
          label: "Applications",
        ),
        HeroStatItem(
          value: "100K+",
          label: "Downloads",
        ),
        HeroStatItem(
          value: "50+",
          label: "Projects",
        ),
        HeroStatItem(
          value: "99.9%",
          label: "Uptime",
        ),
      ],
    );
  }
}

class HeroStatItem extends StatelessWidget {
  final String value;
  final String label;

  const HeroStatItem({
    super.key,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: AppRadius.card,
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        children: [
          ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (bounds) {
              return const LinearGradient(
                colors: [
                  Colors.white,
                  AppColors.primary,
                  AppColors.accent,
                ],
              ).createShader(bounds);
            },
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(
            height: AppSpacing.sm,
          ),

          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}