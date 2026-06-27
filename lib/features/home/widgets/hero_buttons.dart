import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';

class HeroButtons extends StatelessWidget {
  final VoidCallback? onExplore;
  final VoidCallback? onDownload;

  const HeroButtons({
    super.key,
    this.onExplore,
    this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.lg,
      runSpacing: AppSpacing.lg,
      children: [

        FilledButton.icon(
          onPressed: onExplore,
          icon: const Icon(Icons.rocket_launch_rounded),
          label: const Text("Explore Apps"),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(
              horizontal: 28,
              vertical: 18,
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: AppRadius.button,
            ),
          ),
        ),

        OutlinedButton.icon(
          onPressed: onDownload,
          icon: const Icon(Icons.download_rounded),
          label: const Text("Download APK"),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(
              color: AppColors.primary,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 28,
              vertical: 18,
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: AppRadius.button,
            ),
          ),
        ),
      ],
    );
  }
}