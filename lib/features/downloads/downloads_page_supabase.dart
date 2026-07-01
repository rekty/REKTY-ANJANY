import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_radius.dart';
import '../../core/constants/app_shadow.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/config/supabase_config.dart';
import '../../core/services/seo_service.dart';
import '../../shared/layout/app_scaffold.dart';
import '../../shared/layout/responsive_container.dart';
import '../../shared/layout/section_title.dart';

class DownloadsPageSupabase extends StatefulWidget {
  const DownloadsPageSupabase({super.key});

  @override
  State<DownloadsPageSupabase> createState() => _DownloadsPageSupabaseState();
}

class _DownloadsPageSupabaseState extends State<DownloadsPageSupabase> {
  @override
  void initState() {
    super.initState();
    // Set SEO meta tags
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SeoService.instance.updatePageMeta(
        title: 'Downloads - Rekty Anjany',
        description: 'Download the latest APKs, tools and resources from Rekty Anjany. Free downloads for Android, iOS, and Web.',
        keywords: 'downloads, APK, tools, resources, free download, Rekty Anjany',
        url: 'https://rekty-anjany-5a2eb.web.app/#/downloads',
        type: 'website',
      );
    });
  }

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
              'Download the latest APKs, tools and resources from Rekty Anjany.',
        ),
      ),
    );
  }
}

class _DownloadsList extends StatefulWidget {
  const _DownloadsList();

  @override
  State<_DownloadsList> createState() => _DownloadsListState();
}

class _DownloadsListState extends State<_DownloadsList> {
  List<Map<String, dynamic>> _downloads = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDownloads();
  }

  Future<void> _loadDownloads() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final response = await http.get(
        Uri.parse('${SupabaseConfig.supabaseUrl}/rest/v1/downloads?select=*&order=created_at.desc'),
        headers: {
          'apikey': SupabaseConfig.supabaseAnonKey,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _downloads = data.cast<Map<String, dynamic>>();
          // Add 1 sample dummy data if empty
          if (_downloads.isEmpty) {
            _downloads = [
              {
                'id': 'sample-1',
                'name': 'Sample Download',
                'description': 'This is a sample download. Add your own downloads from admin panel!',
                'version': 'v1.0.0',
                'platform': 'Android',
                'file_size': '10 MB',
                'download_url': '#',
                'icon': 'download_rounded',
                'color': '#34D399',
                'features': ['Sample Feature 1', 'Sample Feature 2'],
              }
            ];
          }
          _loading = false;
        });
      } else {
        throw Exception('Failed to load downloads');
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const ResponsiveContainer(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.massive),
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    if (_error != null) {
      return ResponsiveContainer(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.massive),
            child: Column(
              children: [
                const Icon(Icons.error_outline_rounded,
                    size: 64, color: AppColors.error),
                const SizedBox(height: AppSpacing.xl),
                const Text(
                  'Failed to load downloads',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  _error!,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xl),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _loading = true;
                      _error = null;
                    });
                    _loadDownloads();
                  },
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_downloads.isEmpty) {
      return const ResponsiveContainer(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.massive),
            child: Text(
              'No downloads available yet',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
              ),
            ),
          ),
        ),
      );
    }

    return ResponsiveContainer(
      child: Column(
        children: _downloads
            .map((app) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xxxl),
                  child: _DownloadCard(data: app),
                ))
            .toList(),
      ),
    );
  }
}

class _DownloadCard extends StatefulWidget {
  final Map<String, dynamic> data;

  const _DownloadCard({required this.data});

  @override
  State<_DownloadCard> createState() => _DownloadCardState();
}

class _DownloadCardState extends State<_DownloadCard> {
  bool _hover = false;

  Color get _color {
    final colorStr = widget.data['color'] as String?;
    if (colorStr != null && colorStr.startsWith('#')) {
      return Color(int.parse(colorStr.substring(1), radix: 16) + 0xFF000000);
    }
    return const Color(0xFF54C5F8);
  }
  
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

  IconData get _icon {
    final iconStr = widget.data['icon'] as String?;
    switch (iconStr) {
      case 'smart_toy_rounded':
        return Icons.smart_toy_rounded;
      case 'point_of_sale_rounded':
        return Icons.point_of_sale_rounded;
      case 'android_rounded':
        return Icons.android_rounded;
      default:
        return Icons.download_rounded;
    }
  }

  Widget _buildIconWidget(double size, double iconSize) {
    final iconStr = widget.data['icon'] as String?;
    final isImageUrl = iconStr != null && (iconStr.startsWith('http://') || iconStr.startsWith('https://'));

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: _color.withValues(alpha: .12),
        borderRadius: AppRadius.card,
        border: Border.all(color: _color.withValues(alpha: .25)),
      ),
      child: isImageUrl
          ? ClipRRect(
              borderRadius: AppRadius.card,
              child: Image.network(
                iconStr!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(_icon, color: _color, size: iconSize);
                },
              ),
            )
          : Icon(_icon, color: _color, size: iconSize),
    );
  }

  IconData get _platformIcon {
    final platform = widget.data['platform'] as String;
    if (platform.toLowerCase().contains('android')) {
      return Icons.android_rounded;
    } else if (platform.toLowerCase().contains('ios')) {
      return Icons.apple_rounded;
    } else if (platform.toLowerCase().contains('web')) {
      return Icons.language_rounded;
    }
    return Icons.devices_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.data['name'] as String;
    final version = widget.data['version'] as String;
    final fileSize = widget.data['file_size'] as String?;
    final platform = widget.data['platform'] as String;
    final description = widget.data['description'] as String;
    final features = widget.data['features'] as List<dynamic>?;
    final downloadUrl = widget.data['download_url'] as String?;
    final sourceUrl = widget.data['source_url'] as String?;
    
    // Dynamic styling from database
    final titleColor = _parseColor(widget.data['title_color'] as String?, AppColors.textPrimary);
    final taglineColor = _parseColor(widget.data['tagline_color'] as String?, _color);
    final descriptionColor = _parseColor(widget.data['description_color'] as String?, AppColors.textSecondary);
    final fontWeight = _parseFontWeight(widget.data['font_weight'] as String?);

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
            color: _hover ? _color.withValues(alpha: .35) : AppColors.border,
          ),
          boxShadow: _hover
              ? AppShadow.glow(color: _color, blur: 28)
              : AppShadow.card,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildIconWidget(72, 36),
                const SizedBox(width: AppSpacing.xl),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          color: titleColor,
                          fontSize: 24,
                          fontWeight: fontWeight,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          _InfoChip(
                            icon: Icons.tag_rounded,
                            label: version,
                            color: taglineColor,
                          ),
                          const SizedBox(width: 10),
                          _InfoChip(
                            icon: _platformIcon,
                            label: platform,
                            color: AppColors.textSecondary,
                          ),
                          if (fileSize != null && fileSize.isNotEmpty) ...[
                            const SizedBox(width: 10),
                            _InfoChip(
                              icon: Icons.folder_rounded,
                              label: fileSize,
                              color: AppColors.textSecondary,
                            ),
                          ],
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
              description,
              style: TextStyle(
                color: descriptionColor,
                fontSize: 15,
                height: 1.7,
              ),
            ),
            if (features != null && features.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xxl),
              const Text(
                "What's New",
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              ...features.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.check_rounded, size: 16, color: _color),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            item.toString(),
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
            const SizedBox(height: AppSpacing.xxl),
            // Download button
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: downloadUrl != null && downloadUrl.isNotEmpty
                        ? () {
                            // TODO: Handle download
                          }
                        : null,
                    icon: const Icon(Icons.download_rounded),
                    label: const Text('Download APK'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.lg,
                      ),
                    ),
                  ),
                ),
                if (sourceUrl != null && sourceUrl.isNotEmpty) ...[
                  const SizedBox(width: AppSpacing.lg),
                  OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Open source URL
                    },
                    icon: const Icon(Icons.code_rounded),
                    label: const Text('Source'),
                  ),
                ],
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
