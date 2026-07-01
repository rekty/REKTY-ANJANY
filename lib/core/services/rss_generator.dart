/// RSS Feed Generator for Blog
/// Generates RSS 2.0 compliant XML feed
class RssGenerator {
  static final String baseUrl = 'https://rekty-anjany-5a2eb.web.app';
  static final String blogTitle = 'Rekty Anjany Blog';
  static final String blogDescription =
      'Articles, tutorials and insights about web development, programming, and technology';
  static final String blogLanguage = 'en-US';

  /// Generate RSS feed XML content
  static String generateRssFeed({
    required List<Map<String, dynamic>> posts,
  }) {
    final buffer = StringBuffer();
    final now = DateTime.now();
    final pubDate = _formatRssDate(now);

    buffer.writeln('<?xml version="1.0" encoding="UTF-8"?>');
    buffer.writeln('<rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">');
    buffer.writeln('  <channel>');
    buffer.writeln('    <title>$blogTitle</title>');
    buffer.writeln('    <link>$baseUrl/#/blog</link>');
    buffer.writeln('    <description>$blogDescription</description>');
    buffer.writeln('    <language>$blogLanguage</language>');
    buffer.writeln('    <lastBuildDate>$pubDate</lastBuildDate>');
    buffer.writeln('    <atom:link href="$baseUrl/rss.xml" rel="self" type="application/rss+xml"/>');

    // Add each post
    for (final post in posts) {
      final title = _escapeXml(post['title'] ?? 'Untitled');
      final slug = post['slug'] ?? '';
      final excerpt = _escapeXml(post['excerpt'] ?? '');
      final content = _escapeXml(post['content'] ?? '');
      final publishedAt = post['published_at'] != null
          ? DateTime.parse(post['published_at'])
          : now;
      final postPubDate = _formatRssDate(publishedAt);
      final postUrl = '$baseUrl/#/blog/$slug';
      final guid = post['id'] ?? slug;

      buffer.writeln('    <item>');
      buffer.writeln('      <title>$title</title>');
      buffer.writeln('      <link>$postUrl</link>');
      buffer.writeln('      <guid isPermaLink="false">$guid</guid>');
      buffer.writeln('      <pubDate>$postPubDate</pubDate>');
      
      if (excerpt.isNotEmpty) {
        buffer.writeln('      <description>$excerpt</description>');
      }
      
      if (content.isNotEmpty) {
        buffer.writeln('      <content:encoded><![CDATA[$content]]></content:encoded>');
      }

      // Add category/tag if exists
      if (post['tag'] != null) {
        buffer.writeln('      <category>${_escapeXml(post['tag'])}</category>');
      }

      buffer.writeln('    </item>');
    }

    buffer.writeln('  </channel>');
    buffer.writeln('</rss>');

    return buffer.toString();
  }

  /// Format date for RSS (RFC 822)
  static String _formatRssDate(DateTime date) {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];

    final weekday = weekdays[date.weekday - 1];
    final day = date.day.toString().padLeft(2, '0');
    final month = months[date.month - 1];
    final year = date.year;
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    final second = date.second.toString().padLeft(2, '0');

    return '$weekday, $day $month $year $hour:$minute:$second +0000';
  }

  /// Escape XML special characters
  static String _escapeXml(String text) {
    return text
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&apos;');
  }

  /// Generate Atom feed (alternative to RSS)
  static String generateAtomFeed({
    required List<Map<String, dynamic>> posts,
  }) {
    final buffer = StringBuffer();
    final now = DateTime.now().toIso8601String();

    buffer.writeln('<?xml version="1.0" encoding="UTF-8"?>');
    buffer.writeln('<feed xmlns="http://www.w3.org/2005/Atom">');
    buffer.writeln('  <title>$blogTitle</title>');
    buffer.writeln('  <link href="$baseUrl/#/blog"/>');
    buffer.writeln('  <link rel="self" href="$baseUrl/atom.xml"/>');
    buffer.writeln('  <id>$baseUrl/#/blog</id>');
    buffer.writeln('  <updated>$now</updated>');
    buffer.writeln('  <subtitle>$blogDescription</subtitle>');

    // Add each post
    for (final post in posts) {
      final title = _escapeXml(post['title'] ?? 'Untitled');
      final slug = post['slug'] ?? '';
      final excerpt = _escapeXml(post['excerpt'] ?? '');
      final content = _escapeXml(post['content'] ?? '');
      final publishedAt = post['published_at'] ?? now;
      final updatedAt = post['updated_at'] ?? publishedAt;
      final postUrl = '$baseUrl/#/blog/$slug';
      final guid = post['id'] ?? slug;

      buffer.writeln('  <entry>');
      buffer.writeln('    <title>$title</title>');
      buffer.writeln('    <link href="$postUrl"/>');
      buffer.writeln('    <id>$guid</id>');
      buffer.writeln('    <updated>$updatedAt</updated>');
      buffer.writeln('    <published>$publishedAt</published>');
      
      if (excerpt.isNotEmpty) {
        buffer.writeln('    <summary>$excerpt</summary>');
      }
      
      if (content.isNotEmpty) {
        buffer.writeln('    <content type="html"><![CDATA[$content]]></content>');
      }

      buffer.writeln('    <author>');
      buffer.writeln('      <name>Rekty Anjany</name>');
      buffer.writeln('    </author>');

      buffer.writeln('  </entry>');
    }

    buffer.writeln('</feed>');

    return buffer.toString();
  }
}
