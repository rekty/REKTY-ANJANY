import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static SupabaseService? _instance;
  static SupabaseService get instance => _instance ??= SupabaseService._();

  SupabaseService._();

  SupabaseClient get client => Supabase.instance.client;

  // Initialize Supabase
  static Future<void> initialize({
    required String supabaseUrl,
    required String supabaseAnonKey,
  }) async {
    await Supabase.initialize(
      url: supabaseUrl,
      publishableKey: supabaseAnonKey,
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
      ),
    );
  }

  // ==========================================
  // BLOG POSTS
  // ==========================================
  Future<List<Map<String, dynamic>>> getBlogPosts({int limit = 10}) async {
    final response = await client
        .from('blog_posts')
        .select()
        .order('published_at', ascending: false)
        .limit(limit);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<Map<String, dynamic>?> getBlogPostBySlug(String slug) async {
    final response =
        await client.from('blog_posts').select().eq('slug', slug).maybeSingle();
    return response;
  }

  Future<List<Map<String, dynamic>>> getBlogPostsByTag(String tag) async {
    final response =
        await client.from('blog_posts').select().eq('tag', tag).order('published_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  // ==========================================
  // PRODUCTS / STORE
  // ==========================================
  Future<List<Map<String, dynamic>>> getProducts({int limit = 10}) async {
    final response = await client
        .from('products')
        .select()
        .order('created_at', ascending: false)
        .limit(limit);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> getFeaturedProducts() async {
    final response = await client
        .from('products')
        .select()
        .eq('is_featured', true)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<Map<String, dynamic>?> getProductBySlug(String slug) async {
    final response =
        await client.from('products').select().eq('slug', slug).maybeSingle();
    return response;
  }

  Future<List<Map<String, dynamic>>> getProductsByCategory(
      String category) async {
    final response = await client
        .from('products')
        .select()
        .eq('category', category)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  // ==========================================
  // GALLERY
  // ==========================================
  Future<List<Map<String, dynamic>>> getGalleryItems(
      {String category = 'all'}) async {
    var query = client.from('gallery_items').select();

    if (category != 'all') {
      query = query.eq('category', category);
    }

    final response = await query.order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  // ==========================================
  // APPS / DOWNLOADS
  // ==========================================
  Future<List<Map<String, dynamic>>> getApps({int limit = 10}) async {
    final response = await client
        .from('apps')
        .select()
        .order('created_at', ascending: false)
        .limit(limit);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<Map<String, dynamic>?> getAppBySlug(String slug) async {
    final response =
        await client.from('apps').select().eq('slug', slug).maybeSingle();
    return response;
  }

  Future<void> incrementDownloadCount(String appId) async {
    await client.rpc('increment_download_count', params: {'app_id': appId});
  }

  // ==========================================
  // CONTACT MESSAGES
  // ==========================================
  Future<void> submitContactMessage({
    required String name,
    required String email,
    required String subject,
    required String message,
  }) async {
    await client.from('contact_messages').insert({
      'name': name,
      'email': email,
      'subject': subject,
      'message': message,
    });
  }

  Future<List<Map<String, dynamic>>> getContactMessages(
      {bool unreadOnly = false}) async {
    var query = client.from('contact_messages').select();

    if (unreadOnly) {
      query = query.eq('is_read', false);
    }

    final response = await query.order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> markMessageAsRead(String messageId) async {
    await client
        .from('contact_messages')
        .update({'is_read': true}).eq('id', messageId);
  }

  // ==========================================
  // AI CHAT HISTORY (Optional)
  // ==========================================
  Future<void> saveChatHistory({
    required String sessionId,
    required String userMessage,
    required String aiResponse,
    String modelUsed = 'openai',
  }) async {
    await client.from('ai_chat_history').insert({
      'session_id': sessionId,
      'user_message': userMessage,
      'ai_response': aiResponse,
      'model_used': modelUsed,
    });
  }

  Future<List<Map<String, dynamic>>> getChatHistory(String sessionId) async {
    final response = await client
        .from('ai_chat_history')
        .select()
        .eq('session_id', sessionId)
        .order('created_at', ascending: true);
    return List<Map<String, dynamic>>.from(response);
  }

  // ==========================================
  // AI IMAGE HISTORY (Optional)
  // ==========================================
  Future<void> saveImageGeneration({
    required String sessionId,
    required String prompt,
    required String modelUsed,
    required String aspectRatio,
    required String imageUrl,
    int? seed,
    bool enhance = false,
    bool noLogo = true,
  }) async {
    await client.from('ai_image_history').insert({
      'session_id': sessionId,
      'prompt': prompt,
      'model_used': modelUsed,
      'aspect_ratio': aspectRatio,
      'image_url': imageUrl,
      'seed': seed,
      'enhance': enhance,
      'no_logo': noLogo,
    });
  }

  Future<List<Map<String, dynamic>>> getImageHistory(String sessionId) async {
    final response = await client
        .from('ai_image_history')
        .select()
        .eq('session_id', sessionId)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  // ==========================================
  // AUTHENTICATION (if needed)
  // ==========================================
  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    return await client.auth.signUp(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await client.auth.signOut();
  }

  User? get currentUser => client.auth.currentUser;

  Stream<AuthState> get authStateChanges => client.auth.onAuthStateChange;
}
