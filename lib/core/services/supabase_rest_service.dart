import 'dart:convert';
import 'package:http/http.dart' as http;

/// Supabase service using REST API directly
/// More stable than supabase_flutter package on web
class SupabaseRestService {
  static SupabaseRestService? _instance;
  static SupabaseRestService get instance => _instance ??= SupabaseRestService._();

  final String supabaseUrl = 'https://tdztcovdwewfsenzrtnq.supabase.co';
  final String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRkenRjb3Zkd2V3ZnNlbnpydG5xIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODI1NTk5MjksImV4cCI6MjA5ODEzNTkyOX0.8sxWy-VUpq137xDvBewBnIX0rBllFP44oq84PhBWB6w';
  
  SupabaseRestService._();

  Map<String, String> get _headers => {
    'apikey': supabaseAnonKey,
    'Authorization': 'Bearer $supabaseAnonKey',
    'Content-Type': 'application/json',
    'Prefer': 'return=representation',
  };

  String get _restUrl => '$supabaseUrl/rest/v1';

  // ==========================================
  // BLOG POSTS
  // ==========================================
  Future<List<Map<String, dynamic>>> getBlogPosts({int limit = 10}) async {
    try {
      final response = await http.get(
        Uri.parse('$_restUrl/blog_posts?order=published_at.desc&limit=$limit'),
        headers: _headers,
      );
      
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(json.decode(response.body));
      }
      throw Exception('Failed to load blog posts: ${response.statusCode}');
    } catch (e) {
      // Error fetching blog posts
      return [];
    }
  }

  Future<Map<String, dynamic>?> getBlogPostBySlug(String slug) async {
    try {
      final response = await http.get(
        Uri.parse('$_restUrl/blog_posts?slug=eq.$slug'),
        headers: _headers,
      );
      
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        return data.isNotEmpty ? data.first : null;
      }
      return null;
    } catch (e) {
      // Error fetching blog post
      return null;
    }
  }

  // ==========================================
  // PRODUCTS / STORE
  // ==========================================
  Future<List<Map<String, dynamic>>> getProducts({int limit = 10}) async {
    try {
      final response = await http.get(
        Uri.parse('$_restUrl/products?order=created_at.desc&limit=$limit'),
        headers: _headers,
      );
      
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(json.decode(response.body));
      }
      throw Exception('Failed to load products: ${response.statusCode}');
    } catch (e) {
      // Error fetching products
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getFeaturedProducts() async {
    try {
      final response = await http.get(
        Uri.parse('$_restUrl/products?is_featured=eq.true&order=created_at.desc'),
        headers: _headers,
      );
      
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(json.decode(response.body));
      }
      return [];
    } catch (e) {
      // Error fetching featured products
      return [];
    }
  }

  // ==========================================
  // GALLERY
  // ==========================================
  Future<List<Map<String, dynamic>>> getGalleryItems({String category = 'all'}) async {
    try {
      String url = '$_restUrl/gallery_items?order=created_at.desc';
      if (category != 'all') {
        url += '&category=eq.$category';
      }
      
      final response = await http.get(Uri.parse(url), headers: _headers);
      
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(json.decode(response.body));
      }
      return [];
    } catch (e) {
      // Error fetching gallery items
      return [];
    }
  }

  // ==========================================
  // APPS / DOWNLOADS
  // ==========================================
  Future<List<Map<String, dynamic>>> getApps({int limit = 10}) async {
    try {
      final response = await http.get(
        Uri.parse('$_restUrl/apps?order=created_at.desc&limit=$limit'),
        headers: _headers,
      );
      
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(json.decode(response.body));
      }
      return [];
    } catch (e) {
      // Error fetching apps
      return [];
    }
  }

  // ==========================================
  // CONTACT MESSAGES
  // ==========================================
  Future<bool> submitContactMessage({
    required String name,
    required String email,
    required String subject,
    required String message,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_restUrl/contact_messages'),
        headers: _headers,
        body: json.encode({
          'name': name,
          'email': email,
          'subject': subject,
          'message': message,
        }),
      );
      
      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      // Error submitting contact message
      return false;
    }
  }

  // ==========================================
  // AI CHAT HISTORY
  // ==========================================
  Future<bool> saveChatHistory({
    required String sessionId,
    required String userMessage,
    required String aiResponse,
    String modelUsed = 'openai',
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_restUrl/ai_chat_history'),
        headers: _headers,
        body: json.encode({
          'session_id': sessionId,
          'user_message': userMessage,
          'ai_response': aiResponse,
          'model_used': modelUsed,
        }),
      );
      
      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      // Error saving chat history
      return false;
    }
  }

  // ==========================================
  // AI IMAGE HISTORY
  // ==========================================
  Future<bool> saveImageGeneration({
    required String sessionId,
    required String prompt,
    required String modelUsed,
    required String aspectRatio,
    required String imageUrl,
    int? seed,
    bool enhance = false,
    bool noLogo = true,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_restUrl/ai_image_history'),
        headers: _headers,
        body: json.encode({
          'session_id': sessionId,
          'prompt': prompt,
          'model_used': modelUsed,
          'aspect_ratio': aspectRatio,
          'image_url': imageUrl,
          'seed': seed,
          'enhance': enhance,
          'no_logo': noLogo,
        }),
      );
      
      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      // Error saving image generation
      return false;
    }
  }
}
