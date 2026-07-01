import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/services/sitemap_generator.dart';
import '../../../core/services/rss_generator.dart';
import '../admin_layout.dart';

/// Admin SEO Tools Page
/// Generate sitemap.xml and rss.xml
class AdminSeoPage extends StatefulWidget {
  const AdminSeoPage({super.key});

  @override
  State<AdminSeoPage> createState() => _AdminSeoPageState();
}

class _AdminSeoPageState extends State<AdminSeoPage> {
  final _sitemapGenerator = SitemapGenerator.instance;
  final _rssGenerator = RssGenerator.instance;
  
  bool _loading = false;
  String? _sitemapXml;
  String? _rssXml;
  String? _message;
  bool _isError = false;

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.card,
          elevation: 0,
          title: const Text(
            'SEO Tools',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_message != null) ...[
                _buildMessage(),
                const SizedBox(height: AppSpacing.xl),
              ],
              
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildSitemapCard(),
                  ),
                  const SizedBox(width: AppSpacing.xl),
                  Expanded(
                    child: _buildRssCard(),
                  ),
                ],
              ),
              
              if (_sitemapXml != null || _rssXml != null) ...[
                const SizedBox(height: AppSpacing.xl),
                _buildPreviewSection(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessage() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: _isError 
            ? AppColors.error.withValues(alpha: 0.1)
            : AppColors.success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isError
              ? AppColors.error.withValues(alpha: 0.3)
              : AppColors.success.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            _isError ? Icons.error_outline : Icons.check_circle_outline,
            color: _isError ? AppColors.error : AppColors.success,
            size: 24,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              _message!,
              style: TextStyle(
                color: _isError ? AppColors.error : AppColors.success,
                fontSize: 14,
              ),
            ),
          ),
          IconButton(
            onPressed: () => setState(() => _message = null),
            icon: const Icon(Icons.close, size: 20),
            color: _isError ? AppColors.error : AppColors.success,
          ),
        ],
      ),
    );
  }

  Widget _buildSitemapCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.map_outlined,
                  color: AppColors.primary,
                  size: 28,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sitemap.xml',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Dynamic sitemap for Google',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          const Text(
            'Includes:',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildListItem('All static pages'),
          _buildListItem('Blog posts'),
          _buildListItem('Apps'),
          _buildListItem('Products'),
          _buildListItem('Gallery items'),
          const SizedBox(height: AppSpacing.xl),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _loading ? null : _generateSitemap,
              icon: _loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.black),
                      ),
                    )
                  : const Icon(Icons.refresh),
              label: Text(_loading ? 'Generating...' : 'Generate Sitemap'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRssCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.accent.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.rss_feed,
                  color: AppColors.accent,
                  size: 28,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'RSS Feed',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'RSS 2.0 feed for blog',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          const Text(
            'Includes:',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildListItem('Latest 50 blog posts'),
          _buildListItem('Full content'),
          _buildListItem('Images & metadata'),
          _buildListItem('Author & categories'),
          const SizedBox(height: AppSpacing.xl),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _loading ? null : _generateRss,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
              ),
              icon: _loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.black),
                      ),
                    )
                  : const Icon(Icons.refresh),
              label: Text(_loading ? 'Generating...' : 'Generate RSS Feed'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle,
            color: AppColors.success,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Preview & Copy',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        
        if (_sitemapXml != null) ...[
          _buildXmlPreview('Sitemap XML', _sitemapXml!),
          const SizedBox(height: AppSpacing.md),
        ],
        
        if (_rssXml != null) ...[
          _buildXmlPreview('RSS Feed XML', _rssXml!),
        ],
      ],
    );
  }

  Widget _buildXmlPreview(String title, String xml) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _copyToClipboard(xml, title),
                  icon: const Icon(Icons.copy, size: 18),
                  label: const Text('Copy to Clipboard'),
                ),
              ],
            ),
          ),
          Container(
            constraints: const BoxConstraints(maxHeight: 400),
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: const BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: SingleChildScrollView(
              child: SelectableText(
                xml,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _generateSitemap() async {
    setState(() {
      _loading = true;
      _message = null;
      _isError = false;
    });

    try {
      final sitemap = await _sitemapGenerator.generateSitemap();
      setState(() {
        _sitemapXml = sitemap;
        _loading = false;
        _message = 'Sitemap generated successfully! Copy and save as sitemap.xml in web/ folder.';
        _isError = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _message = 'Error generating sitemap: $e';
        _isError = true;
      });
    }
  }

  Future<void> _generateRss() async {
    setState(() {
      _loading = true;
      _message = null;
      _isError = false;
    });

    try {
      final rss = await _rssGenerator.generateRssFeed();
      setState(() {
        _rssXml = rss;
        _loading = false;
        _message = 'RSS feed generated successfully! Copy and save as rss.xml in web/ folder.';
        _isError = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _message = 'Error generating RSS feed: $e';
        _isError = true;
      });
    }
  }

  void _copyToClipboard(String text, String type) {
    Clipboard.setData(ClipboardData(text: text));
    setState(() {
      _message = '$type copied to clipboard!';
      _isError = false;
    });
  }
}
