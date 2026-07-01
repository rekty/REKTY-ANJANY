/// Sitemap Generator for SEO
/// This generates XML sitemap content that can be saved as sitemap.xml
class SitemapGenerator {
  static final String baseUrl = 'https://rekty-anjany-5a2eb.web.app';

  /// Generate sitemap XML content
  static String generateSitemap({
    required List<Map<String, dynamic>> pages,
  }) {
    final buffer = StringBuffer();
    
    buffer.writeln('<?xml version="1.0" encoding="UTF-8"?>');
    buffer.writeln(
      '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">',
    );

    // Add each page
    for (final page in pages) {
      buffer.writeln('  <url>');
      buffer.writeln('    <loc>${page['url']}</loc>');
      
      if (page['lastmod'] != null) {
        buffer.writeln('    <lastmod>${page['lastmod']}</lastmod>');
      }
      
      if (page['changefreq'] != null) {
        buffer.writeln('    <changefreq>${page['changefreq']}</changefreq>');
      }
      
      if (page['priority'] != null) {
        buffer.writeln('    <priority>${page['priority']}</priority>');
      }
      
      buffer.writeln('  </url>');
    }

    buffer.writeln('</urlset>');
    return buffer.toString();
  }

  /// Generate default sitemap with static pages
  static String generateDefaultSitemap() {
    final now = DateTime.now().toIso8601String().split('T')[0];
    
    final pages = [
      {
        'url': baseUrl,
        'lastmod': now,
        'changefreq': 'daily',
        'priority': '1.0',
      },
      {
        'url': '$baseUrl/#/apps',
        'lastmod': now,
        'changefreq': 'weekly',
        'priority': '0.9',
      },
      {
        'url': '$baseUrl/#/downloads',
        'lastmod': now,
        'changefreq': 'weekly',
        'priority': '0.9',
      },
      {
        'url': '$baseUrl/#/store',
        'lastmod': now,
        'changefreq': 'weekly',
        'priority': '0.8',
      },
      {
        'url': '$baseUrl/#/blog',
        'lastmod': now,
        'changefreq': 'daily',
        'priority': '0.9',
      },
      {
        'url': '$baseUrl/#/gallery',
        'lastmod': now,
        'changefreq': 'weekly',
        'priority': '0.7',
      },
      {
        'url': '$baseUrl/#/contact',
        'lastmod': now,
        'changefreq': 'monthly',
        'priority': '0.6',
      },
    ];

    return generateSitemap(pages: pages);
  }

  /// Generate sitemap with blog posts
  static String generateBlogSitemap({
    required List<Map<String, dynamic>> posts,
  }) {
    final pages = posts.map((post) {
      return {
        'url': '$baseUrl/#/blog/${post['slug']}',
        'lastmod': post['updated_at'] ?? post['published_at'],
        'changefreq': 'monthly',
        'priority': '0.7',
      };
    }).toList();

    return generateSitemap(pages: pages);
  }

  /// Generate robots.txt content
  static String generateRobotsTxt() {
    return '''User-agent: *
Allow: /

Sitemap: $baseUrl/sitemap.xml

# Disallow admin routes
User-agent: *
Disallow: /#/admin
Disallow: /#/login

# Crawl delay
Crawl-delay: 10
''';
  }
}
