import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_radius.dart';
import '../../core/constants/app_shadow.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/services/supabase_service.dart';
import '../../shared/layout/app_scaffold.dart';
import '../../shared/layout/responsive_container.dart';
import '../../shared/layout/section_title.dart';

class AppsPageSupabase extends StatelessWidget {
  const AppsPageSupabase({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      child: Column(
        children: [
          _AppsHeader(),
          _AppsList(),
          SizedBox(height: AppSpacing.hero),
        ],
      ),
    );
  }
}

class _AppsHeader extends StatelessWidget {
  const _AppsHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.hero),
      child: const ResponsiveContainer(
        child: SectionTitle(
          title: 'Our Applications',
          subtitle:
              'Explore the applications built by Rekty Anjany.',
        ),
      ),
    );
  }
}

class _AppsList extends StatefulWidget {
  const _AppsList();

  @override
  State<_AppsList> createState() => _AppsListState();
}

class _AppsListState extends State<_AppsList> {
  final _supabase = SupabaseService.instance;
  List<Map<String, dynamic>> _apps = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadApps();
  }

  Future<void> _loadApps() async {
    try {
      final apps = await _supabase.getApps(limit: 20);
      setState(() {
        _apps = apps;
        _loading = false;
      });
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
                  'Failed to load apps',
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
                    _loadApps();
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

    if (_apps.isEmpty) {
      return const ResponsiveContainer(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.massive),
            child: Text(
              'No apps available yet',
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
        children: _apps
            .map((app) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xxxl),
                  child: _AppDetailCard(app: app),
                ))
            .toList(),
      ),
    );
  }
}

class _AppDetailCard extends StatefulWidget {
  final Map<String, dynamic> app;

  const _AppDetailCard({required this.app});

  @override
  State<_AppDetailCard> createState() => _AppDetailCardState();
}

class _AppDetailCardState extends State<_AppDetailCard> {
  bool _hover = false;

  Color get _color {
    final colorStr = widget.app['color'] as String?;
    if (colorStr != null && colorStr.startsWith('#')) {
      return Color(int.parse(colorStr.substring(1), radix: 16) + 0xFF000000);
    }
    return const Color(0xFF54C5F8);
  }

  IconData get _icon {
    final iconStr = widget.app['icon'] as String?;
    switch (iconStr) {
      case 'smart_toy_rounded':
        return Icons.smart_toy_rounded;
      case 'point_of_sale_rounded':
        return Icons.point_of_sale_rounded;
      case 'storefront_rounded':
        return Icons.storefront_rounded;
      case 'photo_library_rounded':
        return Icons.photo_library_rounded;
      default:
        return Icons.apps_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

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
          boxShadow:
              _hover ? AppShadow.glow(color: _color, blur: 30) : AppShadow.card,
        ),
        child: isMobile ? _buildMobile() : _buildDesktop(),
      ),
    );
  }

  Widget _buildDesktop() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icon
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            color: _color.withValues(alpha: .12),
            borderRadius: AppRadius.card,
            border: Border.all(color: _color.withValues(alpha: .25)),
          ),
          child: Icon(_icon, color: _color, size: 44),
        ),
        const SizedBox(width: AppSpacing.xxxl),
        Expanded(child: _buildContent()),
      ],
    );
  }

  Widget _buildMobile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: _color.withValues(alpha: .12),
            borderRadius: AppRadius.card,
            border: Border.all(color: _color.withValues(alpha: .25)),
          ),
          child: Icon(_icon, color: _color, size: 36),
        ),
        const SizedBox(height: AppSpacing.xl),
        _buildContent(),
      ],
    );
  }

  Widget _buildContent() {
    final name = widget.app['name'] as String;
    final tagline = widget.app['tagline'] as String?;
    final description = widget.app['description'] as String;
    final platform = widget.app['platform'] as String;
    final version = widget.app['version'] as String;
    final features = widget.app['features'] as List<dynamic>?;
    final downloadUrl = widget.app['download_url'] as String?;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title + Version
        Row(
          children: [
            Text(
              name,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: _color.withValues(alpha: .12),
                borderRadius: AppRadius.roundRadius,
                border: Border.all(color: _color.withValues(alpha: .30)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.tag_rounded, size: 12, color: _color),
                  const SizedBox(width: 6),
                  Text(
                    version,
                    style: TextStyle(
                      color: _color,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (tagline != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            tagline,
            style: TextStyle(
              color: _color,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
        Text(
          description,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 16,
            height: 1.7,
          ),
        ),
        if (features != null && features.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xl),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: features.map((f) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: _color.withValues(alpha: .08),
                  borderRadius: AppRadius.roundRadius,
                  border: Border.all(color: _color.withValues(alpha: .20)),
                ),
                child: Text(
                  f.toString(),
                  style: TextStyle(
                    color: _color,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
        const SizedBox(height: AppSpacing.xxl),
        // Platform + Button
        Row(
          children: [
            const Icon(
              Icons.devices_rounded,
              size: 16,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              platform,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: downloadUrl != null && downloadUrl.isNotEmpty
                  ? () {
                      // TODO: Handle download
                    }
                  : null,
              icon: const Icon(Icons.open_in_new_rounded, size: 16),
              label: const Text('Open App'),
            ),
          ],
        ),
      ],
    );
  }
}
