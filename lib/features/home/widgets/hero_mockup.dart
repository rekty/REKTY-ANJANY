import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_shadow.dart';
import '../../../core/constants/app_spacing.dart';

class HeroMockup extends StatelessWidget {
  const HeroMockup({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 460,
      height: 640,
      child: Stack(
        alignment: Alignment.center,
        children: [

          // Glow Top
          Positioned(
            top: 20,
            right: 40,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: .15),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: .35),
                    blurRadius: 120,
                    spreadRadius: 40,
                  ),
                ],
              ),
            ),
          ),

          // Glow Bottom
          Positioned(
            bottom: 40,
            left: 20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.purple.withValues(alpha: .15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withValues(alpha: .30),
                    blurRadius: 90,
                    spreadRadius: 25,
                  ),
                ],
              ),
            ),
          ),

          Container(
            decoration: BoxDecoration(
              color: AppColors.card.withValues(alpha: .88),
              borderRadius: AppRadius.xxlRadius,
              border: Border.all(
                color: AppColors.primary.withValues(alpha: .18),
              ),
              boxShadow: AppShadow.cyanGlowStrong,
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              child: Column(
                children: [

                  Row(
                    children: [

                      Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: .12),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.flutter_dash,
                          size: 34,
                          color: AppColors.primary,
                        ),
                      ),

                      const SizedBox(width: 16),

                      const Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [

                            Text(
                              "REKTY ANJANY",
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),

                            SizedBox(height: 4),

                            Text(
                              "Developer & Creator",
                              style: TextStyle(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: .12),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [

                            Icon(
                              Icons.circle,
                              size: 10,
                              color: Colors.green,
                            ),

                            SizedBox(width: 6),

                            Text(
                              "ONLINE",
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 36),
				                    const _MockupCard(
                    icon: Icons.code_rounded,
                    title: "Web Development",
                    subtitle: "Modern & Responsive",
                    color: Color(0xff3B82F6),
                  ),

                  const SizedBox(height: 16),

                  const _MockupCard(
                    icon: Icons.phone_android_rounded,
                    title: "Mobile Apps",
                    subtitle: "iOS & Android",
                    color: Color(0xff10B981),
                  ),

                  const SizedBox(height: 16),

                  const _MockupCard(
                    icon: Icons.api_rounded,
                    title: "API Development",
                    subtitle: "Backend Solutions",
                    color: Color(0xffA855F7),
                  ),

                  const SizedBox(height: 16),

                  const _MockupCard(
                    icon: Icons.design_services_rounded,
                    title: "UI/UX Design",
                    subtitle: "Beautiful Interfaces",
                    color: Color(0xffF59E0B),
                  ),

                  const Spacer(),

                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Skills Progress",
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: const LinearProgressIndicator(
                      value: .82,
                      minHeight: 8,
                      backgroundColor: Color(0xff2A2A2A),
                      valueColor: AlwaysStoppedAnimation(
                        AppColors.primary,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [

                      Text(
                        "82% Completed",
                        style: TextStyle(
                          color: AppColors.textSecondary,
                        ),
                      ),

                      Text(
                        "v2.0",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  const Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    alignment: WrapAlignment.center,
                    children: [

                      _TechChip("Flutter"),

                      _TechChip("Android"),

                      _TechChip("Web"),

                      _TechChip("AI"),

                      _TechChip("Desktop"),
                    ],
                  ),

                  const SizedBox(height: 24),

                  const _BuiltWithFlutterBadge(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BuiltWithFlutterBadge extends StatelessWidget {
  const _BuiltWithFlutterBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 14,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.roundRadius,
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.auto_awesome,
            color: AppColors.primary,
          ),
          SizedBox(width: 10),
          Text(
            "Made with Passion",
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
class _TechChip extends StatelessWidget {
  final String text;

  const _TechChip(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: .12),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }
}

class _MockupCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _MockupCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.card,
        border: Border.all(
          color: color.withValues(alpha: .18),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),

          const SizedBox(width: 18),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          Icon(
            Icons.arrow_forward_ios_rounded,
            size: 16,
            color: color,
          ),
        ],
      ),
    );
  }
}