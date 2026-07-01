import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/supabase_config.dart';
import 'cache_service.dart';

class AdminService {
  static final AdminService instance = AdminService._();
  AdminService._();

  final String _baseUrl = '${SupabaseConfig.supabaseUrl}/rest/v1';
  final Map<String, String> _headers = {
    'apikey': SupabaseConfig.supabaseAnonKey,
    'Content-Type': 'application/json',
  };

  String? _accessToken;
  final _cache = CacheService.instance;

  void setAccessToken(String token) {
    _accessToken = token;
  }

  Map<String, String> get _authHeaders => {
        ..._headers,
        if (_accessToken != null) 'Authorization': 'Bearer $_accessToken',
      };

  // ==========================================
  // ADMIN USER VALIDATION (NO CACHE - AUTH SENSITIVE)
  // ==========================================

  Future<bool> isAdmin(String email) async {
    try {
      print('🔍 [AdminService] Checking admin for email: $email');
      print('🔍 [AdminService] Request URL: $_baseUrl/admin_users?email=eq.$email');
      print('🔍 [AdminService] Has access token: ${_accessToken != null}');
      
      final response = await http.get(
        Uri.parse('$_baseUrl/admin_users?email=eq.$email&select=*'),
        headers: _authHeaders,
      );

      print('🔍 [AdminService] Response status: ${response.statusCode}');
      print('🔍 [AdminService] Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        print('🔍 [AdminService] Admin users found: ${data.length}');
        return data.isNotEmpty;
      }
      print('❌ [AdminService] Non-200 status code');
      return false;
    } catch (e) {
      print('❌ [AdminService] Error checking admin: $e');
      return false;
    }
  }

  // ==========================================
  // APPS CRUD (WITH CACHE)
  // ==========================================

  Future<List<Map<String, dynamic>>> getApps() async {
    final cacheKey = _cache.generateKey('apps');
    
    // Try cache first
    final cached = _cache.get<List<Map<String, dynamic>>>(cacheKey);
    if (cached != null) {
      print('✅ [Cache] Returning cached apps');
      return cached;
    }
    
    // Fetch from API
    final response = await http.get(
      Uri.parse('$_baseUrl/apps?select=*&order=created_at.desc'),
      headers: _authHeaders,
    );
    
    final data = List<Map<String, dynamic>>.from(json.decode(response.body));
    
    // Cache for 5 minutes
    _cache.set(cacheKey, data, duration: const Duration(minutes: 5));
    
    return data;
  }

  Future<Map<String, dynamic>> createApp(Map<String, dynamic> data) async {
    try {
      print('📤 [AdminService] Creating app with data: $data');
      
      final headers = {
        ..._authHeaders,
        'Prefer': 'return=representation',
      };
      
      final response = await http.post(
        Uri.parse('$_baseUrl/apps'),
        headers: headers,
        body: json.encode(data),
      );
      
      print('📥 [AdminService] Response status: ${response.statusCode}');
      print('📥 [AdminService] Response body: ${response.body}');
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Clear cache after create
        _cache.remove(_cache.generateKey('apps'));
        
        if (response.body.isEmpty || response.body == '[]') {
          return {'success': true};
        }
        final List result = json.decode(response.body);
        return result.isNotEmpty ? result[0] : {'success': true};
      } else {
        throw Exception('Server returned ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('❌ [AdminService] Error creating app: $e');
      rethrow;
    }
  }

  Future<void> updateApp(String id, Map<String, dynamic> data) async {
    await http.patch(
      Uri.parse('$_baseUrl/apps?id=eq.$id'),
      headers: _authHeaders,
      body: json.encode(data),
    );
  }

  Future<void> deleteApp(String id) async {
    await http.delete(
      Uri.parse('$_baseUrl/apps?id=eq.$id'),
      headers: _authHeaders,
    );
  }

  // ==========================================
  // DOWNLOADS CRUD
  // ==========================================

  Future<List<Map<String, dynamic>>> getDownloads() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/downloads?select=*&order=created_at.desc'),
      headers: _authHeaders,
    );
    return List<Map<String, dynamic>>.from(json.decode(response.body));
  }

  Future<Map<String, dynamic>> createDownload(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/downloads'),
      headers: _authHeaders,
      body: json.encode(data),
    );
    return json.decode(response.body);
  }

  Future<void> updateDownload(String id, Map<String, dynamic> data) async {
    await http.patch(
      Uri.parse('$_baseUrl/downloads?id=eq.$id'),
      headers: _authHeaders,
      body: json.encode(data),
    );
  }

  Future<void> deleteDownload(String id) async {
    await http.delete(
      Uri.parse('$_baseUrl/downloads?id=eq.$id'),
      headers: _authHeaders,
    );
  }

  // ==========================================
  // PRODUCTS CRUD
  // ==========================================

  Future<List<Map<String, dynamic>>> getProducts() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/products?select=*&order=created_at.desc'),
      headers: _authHeaders,
    );
    return List<Map<String, dynamic>>.from(json.decode(response.body));
  }

  Future<Map<String, dynamic>> createProduct(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/products'),
      headers: _authHeaders,
      body: json.encode(data),
    );
    return json.decode(response.body);
  }

  Future<void> updateProduct(String id, Map<String, dynamic> data) async {
    await http.patch(
      Uri.parse('$_baseUrl/products?id=eq.$id'),
      headers: _authHeaders,
      body: json.encode(data),
    );
  }

  Future<void> deleteProduct(String id) async {
    await http.delete(
      Uri.parse('$_baseUrl/products?id=eq.$id'),
      headers: _authHeaders,
    );
  }

  // ==========================================
  // GALLERY CRUD
  // ==========================================

  Future<List<Map<String, dynamic>>> getGalleryItems() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/gallery_items?select=*&order=created_at.desc'),
      headers: _authHeaders,
    );
    return List<Map<String, dynamic>>.from(json.decode(response.body));
  }

  Future<Map<String, dynamic>> createGalleryItem(
      Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/gallery_items'),
      headers: _authHeaders,
      body: json.encode(data),
    );
    return json.decode(response.body);
  }

  Future<void> updateGalleryItem(String id, Map<String, dynamic> data) async {
    await http.patch(
      Uri.parse('$_baseUrl/gallery_items?id=eq.$id'),
      headers: _authHeaders,
      body: json.encode(data),
    );
  }

  Future<void> deleteGalleryItem(String id) async {
    await http.delete(
      Uri.parse('$_baseUrl/gallery_items?id=eq.$id'),
      headers: _authHeaders,
    );
  }

  // ==========================================
  // BLOG CRUD
  // ==========================================

  Future<List<Map<String, dynamic>>> getBlogPosts() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/blog_posts?select=*&order=published_at.desc'),
      headers: _authHeaders,
    );
    return List<Map<String, dynamic>>.from(json.decode(response.body));
  }

  Future<Map<String, dynamic>> createBlogPost(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/blog_posts'),
      headers: _authHeaders,
      body: json.encode(data),
    );
    return json.decode(response.body);
  }

  Future<void> updateBlogPost(String id, Map<String, dynamic> data) async {
    await http.patch(
      Uri.parse('$_baseUrl/blog_posts?id=eq.$id'),
      headers: _authHeaders,
      body: json.encode(data),
    );
  }

  Future<void> deleteBlogPost(String id) async {
    await http.delete(
      Uri.parse('$_baseUrl/blog_posts?id=eq.$id'),
      headers: _authHeaders,
    );
  }

  // ==========================================
  // ABOUT ME
  // ==========================================

  Future<Map<String, dynamic>> getAboutMe() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/about_me?select=*&limit=1'),
      headers: _authHeaders,
    );
    final List data = json.decode(response.body);
    return data.isNotEmpty ? data[0] : {};
  }

  Future<Map<String, dynamic>> createAboutMe(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/about_me'),
      headers: _authHeaders,
      body: json.encode(data),
    );
    return json.decode(response.body);
  }

  Future<void> updateAboutMe(String id, Map<String, dynamic> data) async {
    await http.patch(
      Uri.parse('$_baseUrl/about_me?id=eq.$id'),
      headers: _authHeaders,
      body: json.encode(data),
    );
  }

  // ==========================================
  // CONTACT INFO
  // ==========================================

  Future<Map<String, dynamic>> getContactInfo() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/contact_info?select=*&limit=1'),
      headers: _authHeaders,
    );
    final List data = json.decode(response.body);
    return data.isNotEmpty ? data[0] : {};
  }

  Future<Map<String, dynamic>> createContactInfo(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/contact_info'),
      headers: _authHeaders,
      body: json.encode(data),
    );
    return json.decode(response.body);
  }

  Future<void> updateContactInfo(String id, Map<String, dynamic> data) async {
    await http.patch(
      Uri.parse('$_baseUrl/contact_info?id=eq.$id'),
      headers: _authHeaders,
      body: json.encode(data),
    );
  }

  // ==========================================
  // CONTACT MESSAGES
  // ==========================================

  Future<Map<String, dynamic>> submitContactMessage({
    required String name,
    required String email,
    required String subject,
    required String message,
  }) async {
    try {
      print('📤 [AdminService] Submitting contact message');
      
      final data = {
        'name': name,
        'email': email,
        'subject': subject,
        'message': message,
        'is_read': false,
      };
      
      final headers = {
        ..._headers, // Use public headers (no auth required for public submissions)
        'Prefer': 'return=representation',
      };
      
      final response = await http.post(
        Uri.parse('$_baseUrl/contact_messages'),
        headers: headers,
        body: json.encode(data),
      );
      
      print('📥 [AdminService] Response status: ${response.statusCode}');
      print('📥 [AdminService] Response body: ${response.body}');
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isEmpty || response.body == '[]') {
          return {'success': true};
        }
        final List result = json.decode(response.body);
        return result.isNotEmpty ? result[0] : {'success': true};
      } else {
        throw Exception('Server returned ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('❌ [AdminService] Error submitting message: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getContactMessages() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/contact_messages?select=*&order=created_at.desc'),
      headers: _authHeaders,
    );
    return List<Map<String, dynamic>>.from(json.decode(response.body));
  }

  Future<void> updateContactMessage(String id, Map<String, dynamic> data) async {
    await http.patch(
      Uri.parse('$_baseUrl/contact_messages?id=eq.$id'),
      headers: _authHeaders,
      body: json.encode(data),
    );
  }

  Future<void> markMessageAsRead(String id) async {
    await http.patch(
      Uri.parse('$_baseUrl/contact_messages?id=eq.$id'),
      headers: _authHeaders,
      body: json.encode({'is_read': true}),
    );
  }

  Future<void> deleteContactMessage(String id) async {
    await http.delete(
      Uri.parse('$_baseUrl/contact_messages?id=eq.$id'),
      headers: _authHeaders,
    );
  }

  Future<void> deleteMessage(String id) async {
    await http.delete(
      Uri.parse('$_baseUrl/contact_messages?id=eq.$id'),
      headers: _authHeaders,
    );
  }

  // ==========================================
  // ANALYTICS / STATS
  // ==========================================

  Future<Map<String, dynamic>> getDashboardStats() async {
    try {
      final apps = await getApps();
      final downloads = await getDownloads();
      final products = await getProducts();
      final gallery = await getGalleryItems();
      final blog = await getBlogPosts();
      final messages = await getContactMessages();

      return {
        'apps_count': apps.length,
        'downloads_count': downloads.length,
        'products_count': products.length,
        'gallery_count': gallery.length,
        'blog_count': blog.length,
        'messages_count': messages.length,
        'unread_messages': messages.where((m) => m['is_read'] == false).length,
      };
    } catch (e) {
      print('Error getting stats: $e');
      return {};
    }
  }
}
