import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_radius.dart';
import '../../core/constants/app_shadow.dart';
import '../../core/constants/app_spacing.dart';
import '../../shared/layout/app_scaffold.dart';
import '../../shared/layout/responsive_container.dart';
import '../../shared/layout/section_title.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      child: Column(
        children: [
          _AboutHero(),
          _AboutMission(),
          _AboutStats(),
          _AboutTech(),
          SizedBox(height: AppSpacing.hero),
        ],
      ),
    );
  }
}

class _AboutHero extends StatelessWidget {
  const _AboutHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.hero),
      child: const ResponsiveContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionTitle(
              title: 'About Me',
              subtitle:
                  'A passionate developer building modern applications with cutting-edge technology.',
            ),

            SizedBox(height: AppSpacing.massive),

            _AboutCard(),
          ],
        ),
      ),
    );
  }
}

class _AboutCard extends StatelessWidget {
  const _AboutCard();

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxxl),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: AppRadius.card,
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadow.card,
      ),
      child: isMobile
          ? const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _AboutIconBlock(),
                SizedBox(height: AppSpacing.xxl),
                _AboutText(),
              ],
            )
          : const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _AboutIconBlock(),
                SizedBox(width: AppSpacing.xxxl),
                Expanded(child: _AboutText()),
              ],
            ),
    );
  }
}

class _AboutIconBlock extends StatelessWidget {
  const _AboutIconBlock();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: .10),
        borderRadius: AppRadius.card,
        border: Border.all(color: AppColors.primary.withValues(alpha: .25)),
        boxShadow: AppShadow.cyanGlow,
      ),
      child: const Icon(
        Icons.person_rounded,
        color: AppColors.primary,
        size: 52,
      ),
    );
  }
}

class _AboutText extends StatelessWidget {
  const _AboutText();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Who I Am',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: AppSpacing.lg),
        Text(
          'I am Rekty Anjany, a passionate software developer with expertise in full-stack development, '
          'mobile applications, and modern web technologies. I love building elegant solutions to complex problems '
          'and creating digital experiences that make a difference.',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 16,
            height: 1.8,
          ),
        ),
        SizedBox(height: AppSpacing.lg),
        Text(
          'My focus is on clean code, scalable architectures, and user-centered design. From React frontends to Node.js backends, '
          'I work across the full stack to bring ideas to life.',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 16,
            height: 1.8,
          ),
        ),
      ],
    );
  }
}

class _AboutMission extends StatelessWidget {
  const _AboutMission();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.section),
      child: const ResponsiveContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionTitle(title: 'My Values'),
            SizedBox(height: AppSpacing.massive),
            Wrap(
              spacing: AppSpacing.xxl,
              runSpacing: AppSpacing.xxl,
              children: [
                _MissionCard(
                  icon: Icons.code_rounded,
                  title: 'Code Quality',
                  description:
                      'Writing clean, maintainable, and efficient code that follows best practices and modern development standards.',
                  color: Color(0xFF54C5F8),
                ),
                _MissionCard(
                  icon: Icons.lightbulb_rounded,
                  title: 'Innovation',
                  description:
                      'Constantly learning new technologies and applying creative solutions to solve real-world problems effectively.',
                  color: Color(0xFFA78BFA),
                ),
                _MissionCard(
                  icon: Icons.people_rounded,
                  title: 'Collaboration',
                  description:
                      'Working effectively in teams, sharing knowledge, and contributing to the developer community.',
                  color: Color(0xFF34D399),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MissionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const _MissionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 340,
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: AppRadius.card,
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadow.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .12),
              borderRadius: AppRadius.card,
              border: Border.all(color: color.withValues(alpha: .25)),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            description,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 15,
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }
}

class _AboutStats extends StatelessWidget {
  const _AboutStats();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.section),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border.symmetric(
          horizontal: BorderSide(color: AppColors.border),
        ),
      ),
      child: const ResponsiveContainer(
        child: Wrap(
          spacing: AppSpacing.massive,
          runSpacing: AppSpacing.massive,
          alignment: WrapAlignment.center,
          children: [
            _StatItem(value: '5+', label: 'Years Experience'),
            _StatItem(value: '50+', label: 'Projects Completed'),
            _StatItem(value: '10+', label: 'Tech Stack'),
            _StatItem(value: '100%', label: 'Dedication'),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Colors.white, AppColors.primary, AppColors.accent],
          ).createShader(bounds),
          child: Text(
            value,
            style: const TextStyle(fontSize: 44, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          label,
          style: const TextStyle(
              color: AppColors.textSecondary, fontSize: 15),
        ),
      ],
    );
  }
}

class _AboutTech extends StatelessWidget {
  const _AboutTech();

  static const List<_TechItem> techs = [
    _TechItem(icon: Icons.code_rounded, name: 'JavaScript', color: Color(0xFFFFA000)),
    _TechItem(icon: Icons.web_rounded, name: 'React', color: Color(0xFF54C5F8)),
    _TechItem(icon: Icons.dns_rounded, name: 'Node.js', color: Color(0xFF34D399)),
    _TechItem(icon: Icons.terminal_rounded, name: 'Python', color: Color(0xFF4B8BBE)),
    _TechItem(icon: Icons.flutter_dash, name: 'Flutter', color: Color(0xFF54C5F8)),
    _TechItem(icon: Icons.storage_rounded, name: 'PostgreSQL', color: Color(0xFF336791)),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.section),
      child: ResponsiveContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle(title: 'Tech Stack'),
            const SizedBox(height: AppSpacing.massive),
            Wrap(
              spacing: AppSpacing.xl,
              runSpacing: AppSpacing.xl,
              children: techs.map((t) => _TechChip(tech: t)).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _TechItem {
  final IconData icon;
  final String name;
  final Color color;

  const _TechItem({required this.icon, required this.name, required this.color});
}

class _TechChip extends StatelessWidget {
  final _TechItem tech;

  const _TechChip({required this.tech});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: AppRadius.roundRadius,
        border: Border.all(color: tech.color.withValues(alpha: .25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(tech.icon, color: tech.color, size: 20),
          const SizedBox(width: AppSpacing.md),
          Text(
            tech.name,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
