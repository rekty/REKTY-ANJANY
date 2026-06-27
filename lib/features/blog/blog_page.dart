import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_radius.dart';
import '../../core/constants/app_spacing.dart';
import '../../shared/layout/app_scaffold.dart';
import '../../shared/layout/responsive_container.dart';
import '../../shared/layout/section_title.dart';

class BlogPage extends StatelessWidget {
  const BlogPage({super.key});

  static const List<_BlogPostData> _posts = [
    _BlogPostData(
      tag: 'React',
      tagColor: Color(0xFF54C5F8),
      icon: Icons.web_rounded,
      title: 'Building Scalable React Applications',
      excerpt:
          'Best practices for structuring React apps with TypeScript, state management patterns, and performance optimization techniques for large-scale projects.',
      date: 'Jan 10, 2025',
      readTime: '5 min read',
      author: 'Rekty Anjany',
    ),
    _BlogPostData(
      tag: 'Backend',
      tagColor: Color(0xFF34D399),
      icon: Icons.dns_rounded,
      title: 'Building RESTful APIs with Node.js',
      excerpt:
          'A comprehensive guide to creating robust REST APIs using Node.js and Express. Learn about authentication, validation, error handling, and best practices.',
      date: 'Feb 3, 2025',
      readTime: '7 min read',
      author: 'Rekty Anjany',
    ),
    _BlogPostData(
      tag: 'Database',
      tagColor: Color(0xFFA78BFA),
      icon: Icons.storage_rounded,
      title: 'PostgreSQL Performance Tuning',
      excerpt:
          'Master database optimization with indexing strategies, query analysis, connection pooling, and advanced PostgreSQL features for high-performance applications.',
      date: 'Mar 15, 2025',
      readTime: '6 min read',
      author: 'Rekty Anjany',
    ),
    _BlogPostData(
      tag: 'Design',
      tagColor: Color(0xFFF472B6),
      icon: Icons.palette_rounded,
      title: 'Modern UI/UX Design Principles',
      excerpt:
          'Creating beautiful and functional user interfaces with modern design systems, color theory, typography, and user-centered design approaches.',
      date: 'Apr 2, 2025',
      readTime: '4 min read',
      author: 'Rekty Anjany',
    ),
    _BlogPostData(
      tag: 'DevOps',
      tagColor: Color(0xFFFBBF24),
      icon: Icons.cloud_rounded,
      title: 'CI/CD Pipeline Best Practices',
      excerpt:
          'Implementing continuous integration and deployment with GitHub Actions, Docker, and cloud platforms for automated testing and deployment workflows.',
      date: 'May 20, 2025',
      readTime: '8 min read',
      author: 'Rekty Anjany',
    ),
    _BlogPostData(
      tag: 'Tutorial',
      tagColor: Color(0xFF00E5FF),
      icon: Icons.school_rounded,
      title: 'Full-Stack Development Roadmap 2025',
      excerpt:
          'A complete guide to becoming a full-stack developer: frontend frameworks, backend technologies, databases, DevOps, and essential tools you need to master.',
      date: 'Jun 5, 2025',
      readTime: '9 min read',
      author: 'Rekty Anjany',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.hero),
            child: const ResponsiveContainer(
              child: SectionTitle(
                title: 'Blog',
                subtitle:
                    'Articles, tutorials and insights about web development, programming, and technology.',
              ),
            ),
          ),

          // Posts grid
          ResponsiveContainer(
            child: Wrap(
              spacing: AppSpacing.xxl,
              runSpacing: AppSpacing.xxl,
              children: _posts.map((post) => _BlogCard(post: post)).toList(),
            ),
          ),

          const SizedBox(height: AppSpacing.hero),
        ],
      ),
    );
  }
}

class _BlogPostData {
  final String tag;
  final Color tagColor;
  final IconData icon;
  final String title;
  final String excerpt;
  final String date;
  final String readTime;
  final String author;

  const _BlogPostData({
    required this.tag,
    required this.tagColor,
    required this.icon,
    required this.title,
    required this.excerpt,
    required this.date,
    required this.readTime,
    required this.author,
  });
}

class _BlogCard extends StatefulWidget {
  final _BlogPostData post;

  const _BlogCard({required this.post});

  @override
  State<_BlogCard> createState() => _BlogCardState();
}

class _BlogCardState extends State<_BlogCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 380,
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: AppRadius.card,
          border: Border.all(
            color: _hover
                ? AppColors.primary.withValues(alpha: .35)
                : AppColors.border,
          ),
          boxShadow: _hover
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: .08),
                    blurRadius: 28,
                    spreadRadius: 2,
                  ),
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tag
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: widget.post.tagColor.withValues(alpha: .12),
                borderRadius: AppRadius.roundRadius,
                border: Border.all(
                    color: widget.post.tagColor.withValues(alpha: .25)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(widget.post.icon,
                      size: 13, color: widget.post.tagColor),
                  const SizedBox(width: 6),
                  Text(
                    widget.post.tag,
                    style: TextStyle(
                      color: widget.post.tagColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // Title
            Text(
              widget.post.title,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                height: 1.4,
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            // Excerpt
            Text(
              widget.post.excerpt,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                height: 1.7,
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: AppSpacing.xxl),

            // Footer
            Row(
              children: [
                const Icon(Icons.calendar_today_rounded,
                    size: 13, color: AppColors.textSecondary),
                const SizedBox(width: 5),
                Text(
                  widget.post.date,
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 12),
                ),
                const SizedBox(width: AppSpacing.lg),
                const Icon(Icons.access_time_rounded,
                    size: 13, color: AppColors.textSecondary),
                const SizedBox(width: 5),
                Text(
                  widget.post.readTime,
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 12),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_rounded,
                  size: 16,
                  color: _hover ? AppColors.primary : AppColors.textSecondary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
