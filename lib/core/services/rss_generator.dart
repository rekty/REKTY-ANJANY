import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/supabase_config.dart';

/// Service for generating RSS feed for blog posts
class RssGenerator {
  static final RssGenerator instance = RssGenerator._();
  RssGenerator._();

  final String _baseUrl = '${SupabaseConfig.supabaseUrl}/rest/v1';
  final String _websiteUrl = 'https://rekty-anjany-5a2eb.web.app';
  final String _authorName = 'Rekty Anjany';
  final String _authorEmail = 'rekty.anjany@gmail.com';

  /// Generate RSS 2.0 feed for blog posts
  Future<String> generateRssFeed() async {
    final buffer = StringBuffer();
    
    // XML header
    buffer.writeln('<?xml version="1.0" encoding="UTF-8"?>');
    buffer.writeln('<rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom" xmlns:content="http://purl.org/rss/1.0/modules/content/">');
    buffer.writeln('  <channel>');
    
    // Channel metadata
    buffer.writeln('    <title>Rekty Anjany Blog</title>');
    buffer.writeln('    <link>$_websiteUrl/blog</link>');
    buffer.writeln('    <description>Articles, tutorials, and insights from Rekty Anjany - Developer, Creator, Innovator</description>');
    buffer.writeln('    <language>en-US</language>');
    buffer.writeln('    <lastBuildDate>${_getRfc822Date(DateTime.now())}</lastBuildDate>');
    buffer.writeln('    <atom:link href="$_websiteUrl/rss.xml" rel="self" type="application/rss+xml" />');
    buffer.writeln('    <generator>Rekty Anjany Portfolio</generator>');
    buffer.writeln('    <image>');
    buffer.writeln('      <url>$_websiteUrl/icons/Icon-512.png</url>');
    buffer.writeln('      <title>Rekty Anjany Blog</title>');
    buffer.writeln('      <link>$_websiteUrl/blog</link>');
    buffer.writeln('    </image>');
    
    // Fetch and add blog posts
    await _addBlogPosts(buffer);
    
    buffer.writeln('  </channel>');
    buffer.writeln('</rss>');
    
    return buffer.toString();
  }

  /// Fetch and add blog posts to RSS feed
  Future<void> _addBlogPosts(StringBuffer buffer) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/blog_posts?select=*&order=created_at.desc&limit=50'),
        headers: {
          'apikey': SupabaseConfig.supabaseAnonKey,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List posts = json.decode(response.body);
        
        for (var post in posts) {
          _addRssItem(buffer, post);
        }
      }
    } catch (e) {
      print('Error fetching blog posts for RSS: $e');
    }
  }

  /// Add individual blog post as RSS item
  void _addRssItem(StringBuffer buffer, Map<String, dynamic> post) {
    final title = _escapeXml(post['title'] ?? 'Untitled');
    final slug = post['slug'] ?? post['id'];
    final link = '$_websiteUrl/blog/$slug';
    final description = _escapeXml(post['excerpt'] ?? post['description'] ?? '');
    final content = _escapeXml(post['content'] ?? description);
    final pubDate = _getRfc822Date(_parseDate(post['created_at']));
    final author = post['author'] ?? _authorName;
    final category = post['category'] ?? 'General';
    final imageUrl = post['image_url'];
    
    buffer.writeln('    <item>');
    buffer.writeln('      <title>$title</title>');
    buffer.writeln('      <link>$link</link>');
    buffer.writeln('      <guid isPermaLink="true">$link</guid>');
    buffer.writeln('      <pubDate>$pubDate</pubDate>');
    buffer.writeln('      <author>$_authorEmail ($author)</author>');
    buffer.writeln('      <category>$category</category>');
    buffer.writeln('      <description>$description</description>');
    buffer.writeln('      <content:encoded><![CDATA[$content]]></content:encoded>');
    
    if (imageUrl != null && imageUrl.isNotEmpty) {
      buffer.writeln('      <enclosure url="${_escapeXml(imageUrl)}" type="image/jpeg" />');
    }
    
    buffer.writeln('    </item>');
  }

  /// Escape XML special characters
  String _escapeXml(String text) {
    return text
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&apos;');
  }

  /// Convert DateTime to RFC 822 format (required for RSS)
  String _getRfc822Date(DateTime date) {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    
    final weekday = weekdays[date.weekday - 1];
    final day = date.day.toString().padLeft(2, '0');
    final month = months[date.month - 1];
    final year = date.year;
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    final second = date.second.toString().padLeft(2, '0');
    
    return '$weekday, $day $month $year $hour:$minute:$second +0000';
  }

  /// Parse date string to DateTime
  DateTime _parseDate(String? dateStr) {
    if (dateStr == null) return DateTime.now();
    
    try {
      return DateTime.parse(dateStr);
    } catch (e) {
      return DateTime.now();
    }
  }

  /// Get RSS filename
  String getRssFileName() {
    return 'rss.xml';
  }
}
