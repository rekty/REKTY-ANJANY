import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_breakpoints.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../shared/layout/responsive_container.dart';

import '../widgets/gradient_heading.dart';
import '../widgets/hero_badge.dart';
import '../widgets/hero_buttons.dart';
import '../widgets/hero_mockup.dart';
import '../widgets/hero_scroll_indicator.dart';
import '../widgets/hero_stats.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final mobile = AppBreakpoints.isMobile(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.hero,
      ),
      child: ResponsiveContainer(
        child: mobile
            ? const _MobileHero()
            : const _DesktopHero(),
      ),
    );
  }
}
class _DesktopHero extends StatelessWidget {
  const _DesktopHero();

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 6,
          child: _HeroContent(),
        ),

        SizedBox(width: 80),

        Expanded(
          flex: 5,
          child: _HeroPreview(),
        ),
      ],
    );
  }
}

class _MobileHero extends StatelessWidget {
  const _MobileHero();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _HeroContent(),

        SizedBox(height: 60),

        HeroMockup(),

        SizedBox(height: 50),

        HeroScrollIndicator(),
      ],
    );
  }
}
class _HeroContent extends StatelessWidget {
  const _HeroContent();

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 640,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const HeroBadge(
            text: "DEVELOPER • CREATOR • INNOVATOR",
          ),

          const SizedBox(height: 24),

          const GradientHeading(
            text: "Code.\nCreate.\nInnovate.",
          ),

          const SizedBox(height: 28),

          const Text(
            "Hi, I'm Rekty Anjany, a passionate developer specializing in "
            "building modern web and mobile applications. I create innovative "
            "solutions with clean code, beautiful UI/UX, and cutting-edge "
            "technology. Welcome to my digital space.",
            style: TextStyle(
              fontSize: 18,
              height: 1.8,
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 40),

          HeroButtons(
            onExplore: () {
              context.go('/apps');
            },
            onDownload: () {
              context.go('/downloads');
            },
          ),

          const SizedBox(height: 60),

          const HeroStats(),

          const SizedBox(height: 60),

          const HeroScrollIndicator(),
        ],
      ),
    );
  }
}
// ============================================================
// HERO PREVIEW
// ============================================================

class _HeroPreview extends StatelessWidget {
  const _HeroPreview();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 720,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 20,
            left: 20,
            child: _FloatingBadge(
              icon: Icons.code_rounded,
              title: "Full Stack",
            ),
          ),

          Positioned(
            top: 190,
            right: 0,
            child: _FloatingBadge(
              icon: Icons.design_services_rounded,
              title: "UI/UX Design",
            ),
          ),

          Positioned(
            bottom: 110,
            left: 0,
            child: _FloatingBadge(
              icon: Icons.cloud_rounded,
              title: "Cloud Ready",
            ),
          ),

          Center(
            child: HeroMockup(),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// FLOATING BADGE
// ============================================================

class _FloatingBadge extends StatelessWidget {
  final IconData icon;
  final String title;

  const _FloatingBadge({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: AppColors.card.withValues(alpha: .92),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: .20),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: .08),
            blurRadius: 22,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: AppColors.primary,
            size: 18,
          ),

          const SizedBox(width: 8),

          Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}