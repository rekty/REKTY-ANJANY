import 'dart:html' as html;

/// Service for managing SEO meta tags dynamically
class SeoService {
  static final SeoService instance = SeoService._internal();
  SeoService._internal();

  /// Update page title and meta tags
  void updatePageMeta({
    required String title,
    required String description,
    String? keywords,
    String? image,
    String? url,
    String? type,
  }) {
    // Update title
    html.document.title = title;

    // Update meta description
    _updateMetaTag('name', 'description', description);

    // Update keywords if provided
    if (keywords != null) {
      _updateMetaTag('name', 'keywords', keywords);
    }

    // Update Open Graph tags
    _updateMetaTag('property', 'og:title', title);
    _updateMetaTag('property', 'og:description', description);
    _updateMetaTag('property', 'og:type', type ?? 'website');
    
    if (url != null) {
      _updateMetaTag('property', 'og:url', url);
    }
    
    if (image != null) {
      _updateMetaTag('property', 'og:image', image);
      _updateMetaTag('property', 'og:image:width', '1200');
      _updateMetaTag('property', 'og:image:height', '630');
    }

    // Update Twitter Card tags
    _updateMetaTag('name', 'twitter:card', 'summary_large_image');
    _updateMetaTag('name', 'twitter:title', title);
    _updateMetaTag('name', 'twitter:description', description);
    
    if (image != null) {
      _updateMetaTag('name', 'twitter:image', image);
    }

    // Update canonical URL
    if (url != null) {
      _updateCanonicalUrl(url);
    }
  }

  /// Update or create a meta tag
  void _updateMetaTag(String attribute, String attributeValue, String content) {
    // Try to find existing tag
    var element = html.document.querySelector(
      'meta[$attribute="$attributeValue"]',
    );

    if (element != null) {
      // Update existing tag
      element.setAttribute('content', content);
    } else {
      // Create new tag
      var meta = html.MetaElement()
        ..setAttribute(attribute, attributeValue)
        ..setAttribute('content', content);
      html.document.head?.append(meta);
    }
  }

  /// Update canonical URL
  void _updateCanonicalUrl(String url) {
    // Remove existing canonical link
    var existing = html.document.querySelector('link[rel="canonical"]');
    existing?.remove();

    // Add new canonical link
    var link = html.LinkElement()
      ..rel = 'canonical'
      ..href = url;
    html.document.head?.append(link);
  }

  /// Add JSON-LD structured data
  void addStructuredData(Map<String, dynamic> data) {
    // Remove existing structured data
    html.document
        .querySelectorAll('script[type="application/ld+json"]')
        .forEach((element) => element.remove());

    // Add new structured data
    var script = html.ScriptElement()
      ..type = 'application/ld+json'
      ..text = _toJson(data);
    html.document.head?.append(script);
  }

  /// Simple JSON encoder (without importing dart:convert for web)
  String _toJson(Map<String, dynamic> data) {
    final buffer = StringBuffer('{');
    var first = true;
    
    data.forEach((key, value) {
      if (!first) buffer.write(',');
      first = false;
      
      buffer.write('"$key":');
      
      if (value is String) {
        buffer.write('"${_escapeString(value)}"');
      } else if (value is num || value is bool) {
        buffer.write(value);
      } else if (value is List) {
        buffer.write('[');
        for (var i = 0; i < value.length; i++) {
          if (i > 0) buffer.write(',');
          if (value[i] is String) {
            buffer.write('"${_escapeString(value[i])}"');
          } else {
            buffer.write(value[i]);
          }
        }
        buffer.write(']');
      } else if (value is Map) {
        buffer.write(_toJson(value as Map<String, dynamic>));
      }
    });
    
    buffer.write('}');
    return buffer.toString();
  }

  String _escapeString(String str) {
    return str
        .replaceAll('\\', '\\\\')
        .replaceAll('"', '\\"')
        .replaceAll('\n', '\\n')
        .replaceAll('\r', '\\r')
        .replaceAll('\t', '\\t');
  }

  /// Set default meta tags (for homepage)
  void setDefaultMeta() {
    updatePageMeta(
      title: 'Rekty Anjany - Developer Portfolio',
      description:
          'Rekty Anjany - Developer, Creator, Innovator. Explore my portfolio, projects, applications, and blog posts.',
      keywords:
          'Rekty Anjany, Developer, Flutter, Web Development, Portfolio, Apps',
      image: 'https://rekty-anjany-5a2eb.web.app/icons/Icon-512.png',
      url: 'https://rekty-anjany-5a2eb.web.app',
      type: 'website',
    );

    // Add organization structured data
    addStructuredData({
      '@context': 'https://schema.org',
      '@type': 'Person',
      'name': 'Rekty Anjany',
      'url': 'https://rekty-anjany-5a2eb.web.app',
      'sameAs': [
        'https://github.com/rekty',
        'https://twitter.com/rektyanjany',
      ],
      'jobTitle': 'Software Developer',
      'description':
          'Developer, Creator, and Innovator specializing in web and mobile applications',
    });
  }

  /// Generate blog post structured data
  Map<String, dynamic> generateBlogPostStructuredData({
    required String title,
    required String description,
    required String url,
    required DateTime publishedDate,
    String? imageUrl,
    String? authorName,
  }) {
    return {
      '@context': 'https://schema.org',
      '@type': 'BlogPosting',
      'headline': title,
      'description': description,
      'url': url,
      'datePublished': publishedDate.toIso8601String(),
      'author': {
        '@type': 'Person',
        'name': authorName ?? 'Rekty Anjany',
      },
      if (imageUrl != null) 'image': imageUrl,
    };
  }

  /// Generate product structured data
  Map<String, dynamic> generateProductStructuredData({
    required String name,
    required String description,
    required double price,
    String? imageUrl,
    String? currency,
  }) {
    return {
      '@context': 'https://schema.org',
      '@type': 'Product',
      'name': name,
      'description': description,
      if (imageUrl != null) 'image': imageUrl,
      'offers': {
        '@type': 'Offer',
        'price': price.toString(),
        'priceCurrency': currency ?? 'USD',
      },
    };
  }
}
