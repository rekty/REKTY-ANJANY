import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/supabase_config.dart';

/// Service for generating dynamic sitemap.xml from database content
class SitemapGenerator {
  static final SitemapGenerator instance = SitemapGenerator._();
  SitemapGenerator._();

  final String _baseUrl = '${SupabaseConfig.supabaseUrl}/rest/v1';
  final String _websiteUrl = 'https://rekty-anjany-5a2eb.web.app';

  /// Generate complete sitemap XML
  Future<String> generateSitemap() async {
    final buffer = StringBuffer();
    
    // XML header
    buffer.writeln('<?xml version="1.0" encoding="UTF-8"?>');
    buffer.writeln('<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">');
    
    // Static pages
    _addStaticPages(buffer);
    
    // Dynamic content from database
    await _addBlogPosts(buffer);
    await _addApps(buffer);
    await _addProducts(buffer);
    await _addGalleryItems(buffer);
    
    buffer.writeln('</urlset>');
    
    return buffer.toString();
  }

  /// Add static pages to sitemap
  void _addStaticPages(StringBuffer buffer) {
    final staticPages = [
      {'loc': '/', 'priority': '1.0', 'changefreq': 'daily'},
      {'loc': '/apps', 'priority': '0.9', 'changefreq': 'weekly'},
      {'loc': '/downloads', 'priority': '0.9', 'changefreq': 'weekly'},
      {'loc': '/store', 'priority': '0.8', 'changefreq': 'weekly'},
      {'loc': '/blog', 'priority': '0.9', 'changefreq': 'daily'},
      {'loc': '/gallery', 'priority': '0.7', 'changefreq': 'weekly'},
      {'loc': '/contact', 'priority': '0.6', 'changefreq': 'monthly'},
    ];

    for (var page in staticPages) {
      buffer.writeln('  <url>');
      buffer.writeln('    <loc>$_websiteUrl${page['loc']}</loc>');
      buffer.writeln('    <lastmod>${_getCurrentDate()}</lastmod>');
      buffer.writeln('    <changefreq>${page['changefreq']}</changefreq>');
      buffer.writeln('    <priority>${page['priority']}</priority>');
      buffer.writeln('  </url>');
    }
  }

  /// Add blog posts from database
  Future<void> _addBlogPosts(StringBuffer buffer) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/blog_posts?select=id,slug,title,updated_at&order=created_at.desc&limit=100'),
        headers: {
          'apikey': SupabaseConfig.supabaseAnonKey,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List posts = json.decode(response.body);
        
        for (var post in posts) {
          final slug = post['slug'] ?? post['id'];
          final updatedAt = post['updated_at'] ?? _getCurrentDate();
          
          buffer.writeln('  <url>');
          buffer.writeln('    <loc>$_websiteUrl/blog/$slug</loc>');
          buffer.writeln('    <lastmod>${_formatDate(updatedAt)}</lastmod>');
          buffer.writeln('    <changefreq>monthly</changefreq>');
          buffer.writeln('    <priority>0.8</priority>');
          buffer.writeln('  </url>');
        }
      }
    } catch (e) {
      print('Error fetching blog posts for sitemap: $e');
    }
  }

  /// Add apps from database
  Future<void> _addApps(StringBuffer buffer) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/apps?select=id,name,updated_at&order=created_at.desc&limit=100'),
        headers: {
          'apikey': SupabaseConfig.supabaseAnonKey,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List apps = json.decode(response.body);
        
        for (var app in apps) {
          final appId = app['id'];
          final updatedAt = app['updated_at'] ?? _getCurrentDate();
          
          buffer.writeln('  <url>');
          buffer.writeln('    <loc>$_websiteUrl/apps/$appId</loc>');
          buffer.writeln('    <lastmod>${_formatDate(updatedAt)}</lastmod>');
          buffer.writeln('    <changefreq>monthly</changefreq>');
          buffer.writeln('    <priority>0.7</priority>');
          buffer.writeln('  </url>');
        }
      }
    } catch (e) {
      print('Error fetching apps for sitemap: $e');
    }
  }

  /// Add products from database
  Future<void> _addProducts(StringBuffer buffer) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/products?select=id,name,updated_at&order=created_at.desc&limit=100'),
        headers: {
          'apikey': SupabaseConfig.supabaseAnonKey,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List products = json.decode(response.body);
        
        for (var product in products) {
          final productId = product['id'];
          final updatedAt = product['updated_at'] ?? _getCurrentDate();
          
          buffer.writeln('  <url>');
          buffer.writeln('    <loc>$_websiteUrl/store/$productId</loc>');
          buffer.writeln('    <lastmod>${_formatDate(updatedAt)}</lastmod>');
          buffer.writeln('    <changefreq>weekly</changefreq>');
          buffer.writeln('    <priority>0.7</priority>');
          buffer.writeln('  </url>');
        }
      }
    } catch (e) {
      print('Error fetching products for sitemap: $e');
    }
  }

  /// Add gallery items from database
  Future<void> _addGalleryItems(StringBuffer buffer) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/gallery_items?select=id,title,updated_at&order=created_at.desc&limit=100'),
        headers: {
          'apikey': SupabaseConfig.supabaseAnonKey,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List items = json.decode(response.body);
        
        for (var item in items) {
          final itemId = item['id'];
          final updatedAt = item['updated_at'] ?? _getCurrentDate();
          
          buffer.writeln('  <url>');
          buffer.writeln('    <loc>$_websiteUrl/gallery/$itemId</loc>');
          buffer.writeln('    <lastmod>${_formatDate(updatedAt)}</lastmod>');
          buffer.writeln('    <changefreq>monthly</changefreq>');
          buffer.writeln('    <priority>0.6</priority>');
          buffer.writeln('  </url>');
        }
      }
    } catch (e) {
      print('Error fetching gallery items for sitemap: $e');
    }
  }

  /// Get current date in YYYY-MM-DD format
  String _getCurrentDate() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  /// Format datetime string to YYYY-MM-DD
  String _formatDate(String? dateStr) {
    if (dateStr == null) return _getCurrentDate();
    
    try {
      final date = DateTime.parse(dateStr);
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    } catch (e) {
      return _getCurrentDate();
    }
  }

  /// Save sitemap to file (for static hosting)
  /// This is useful for generating sitemap.xml before deployment
  String getSitemapFileName() {
    return 'sitemap.xml';
  }
}
