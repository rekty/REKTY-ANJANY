import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_radius.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/config/supabase_config.dart';
import '../../core/services/seo_service.dart';
import '../../shared/layout/app_scaffold.dart';
import '../../shared/layout/responsive_container.dart';
import '../../shared/layout/section_title.dart';
import '../../shared/widgets/loading/skeleton_loader.dart';

class BlogPageSupabase extends StatefulWidget {
  const BlogPageSupabase({super.key});

  @override
  State<BlogPageSupabase> createState() => _BlogPageSupabaseState();
}

class _BlogPageSupabaseState extends State<BlogPageSupabase> {
  List<Map<String, dynamic>> _posts = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    // Set SEO meta tags
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SeoService.instance.updatePageMeta(
        title: 'Blog - Rekty Anjany',
        description: 'Articles, tutorials and insights about web development, programming, and technology from Rekty Anjany.',
        keywords: 'blog, articles, tutorials, web development, programming, technology, Rekty Anjany',
        url: 'https://rekty-anjany-5a2eb.web.app/#/blog',
        type: 'website',
      );
    });
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await http.get(
        Uri.parse('${SupabaseConfig.supabaseUrl}/rest/v1/blog_posts?select=*&is_published=eq.true&order=published_at.desc'),
        headers: {
          'apikey': SupabaseConfig.supabaseAnonKey,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _posts = data.cast<Map<String, dynamic>>();
          // Add 1 sample dummy data if empty
          if (_posts.isEmpty) {
            _posts = [
              {
                'id': 'sample-1',
                'title': 'Welcome to Our Blog',
                'excerpt': 'This is a sample blog post. Add your own blog posts from admin panel!',
                'published_at': DateTime.now().toIso8601String(),
                'tag': 'Announcement',
                'tag_color': '#54C5F8',
                'read_time': 5,
                'icon': 'article_rounded',
              }
            ];
          }
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load blog posts');
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

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

          // Content
          if (_isLoading)
            Expanded(
              child: ResponsiveContainer(
                child: SkeletonList(itemCount: 3),
              ),
            )
          else if (_error != null)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 64, color: AppColors.error),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'Error: $_error',
                      style: const TextStyle(color: AppColors.error),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    ElevatedButton(
                      onPressed: _loadPosts,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            )
          else if (_posts.isEmpty)
            const Expanded(
              child: Center(
                child: Text(
                  'No blog posts yet',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            )
          else
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

class _BlogCard extends StatefulWidget {
  final Map<String, dynamic> post;

  const _BlogCard({required this.post});

  @override
  State<_BlogCard> createState() => _BlogCardState();
}

class _BlogCardState extends State<_BlogCard> {
  bool _hover = false;
  
  // Helper method to parse color from hex string
  Color _parseColor(String? hexColor, Color defaultColor) {
    if (hexColor == null || hexColor.isEmpty) return defaultColor;
    try {
      return Color(int.parse(hexColor.replaceFirst('#', ''), radix: 16) + 0xFF000000);
    } catch (e) {
      return defaultColor;
    }
  }

  // Helper method to parse font weight from string
  FontWeight _parseFontWeight(String? fontWeightStr) {
    switch (fontWeightStr) {
      case 'light':
        return FontWeight.w300;
      case 'normal':
        return FontWeight.w400;
      case 'semibold':
        return FontWeight.w600;
      case 'bold':
        return FontWeight.w700;
      default:
        return FontWeight.w700;
    }
  }

  Color _getTagColor() {
    final colorStr = widget.post['tag_color'] as String?;
    if (colorStr == null) return AppColors.primary;
    return Color(int.parse(colorStr.replaceFirst('#', '0xFF')));
  }

  IconData _getIcon() {
    final iconStr = widget.post['icon'] as String?;
    switch (iconStr) {
      case 'web_rounded':
        return Icons.web_rounded;
      case 'dns_rounded':
        return Icons.dns_rounded;
      case 'storage_rounded':
        return Icons.storage_rounded;
      case 'palette_rounded':
        return Icons.palette_rounded;
      case 'cloud_rounded':
        return Icons.cloud_rounded;
      case 'school_rounded':
        return Icons.school_rounded;
      default:
        return Icons.article_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tagColor = _getTagColor();
    
    // Dynamic styling from database
    final titleColor = _parseColor(widget.post['title_color'] as String?, AppColors.textPrimary);
    final excerptColor = _parseColor(widget.post['excerpt_color'] as String?, AppColors.textSecondary);
    final fontWeight = _parseFontWeight(widget.post['font_weight'] as String?);

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
                color: tagColor.withValues(alpha: .12),
                borderRadius: AppRadius.roundRadius,
                border: Border.all(color: tagColor.withValues(alpha: .25)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(_getIcon(), size: 13, color: tagColor),
                  const SizedBox(width: 6),
                  Text(
                    widget.post['tag'] ?? '',
                    style: TextStyle(
                      color: tagColor,
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
              widget.post['title'] ?? '',
              style: TextStyle(
                color: titleColor,
                fontSize: 20,
                fontWeight: fontWeight,
                height: 1.4,
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            // Excerpt
            Text(
              widget.post['excerpt'] ?? '',
              style: TextStyle(
                color: excerptColor,
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
                  _formatDate(widget.post['published_at']),
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 12),
                ),
                const SizedBox(width: AppSpacing.lg),
                const Icon(Icons.access_time_rounded,
                    size: 13, color: AppColors.textSecondary),
                const SizedBox(width: 5),
                Text(
                  widget.post['read_time'] ?? '',
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

  String _formatDate(dynamic date) {
    if (date == null) return '';
    try {
      final dt = DateTime.parse(date.toString());
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
    } catch (e) {
      return '';
    }
  }
}
