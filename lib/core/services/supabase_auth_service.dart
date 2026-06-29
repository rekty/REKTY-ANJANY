import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:html' as html;
import '../config/supabase_config.dart';

/// Supabase Authentication using REST API
/// More stable than supabase_flutter package on web
class SupabaseAuthService {
  static SupabaseAuthService? _instance;
  static SupabaseAuthService get instance => _instance ??= SupabaseAuthService._();

  final String supabaseUrl = SupabaseConfig.supabaseUrl;
  final String supabaseAnonKey = SupabaseConfig.supabaseAnonKey;
  
  String? _accessToken;
  Map<String, dynamic>? _currentUser;

  SupabaseAuthService._() {
    _loadSessionFromStorage();
  }

  String get _authUrl => '$supabaseUrl/auth/v1';

  Map<String, String> _headers({String? token}) => {
    'apikey': supabaseAnonKey,
    'Content-Type': 'application/json',
    if (token != null) 'Authorization': 'Bearer $token',
  };

  void _loadSessionFromStorage() {
    try {
      final token = html.window.localStorage['supabase_access_token'];
      final userJson = html.window.localStorage['supabase_user'];
      
      if (token != null && userJson != null) {
        _accessToken = token;
        _currentUser = json.decode(userJson);
      }
    } catch (e) {
      // Ignore
    }
  }

  void _saveSessionToStorage() {
    try {
      if (_accessToken != null && _currentUser != null) {
        html.window.localStorage['supabase_access_token'] = _accessToken!;
        html.window.localStorage['supabase_user'] = json.encode(_currentUser);
      }
    } catch (e) {
      // Ignore
    }
  }

  void _clearSessionFromStorage() {
    try {
      html.window.localStorage.remove('supabase_access_token');
      html.window.localStorage.remove('supabase_user');
    } catch (e) {
      // Ignore
    }
  }

  Future<Map<String, dynamic>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_authUrl/token?grant_type=password'),
        headers: _headers(),
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _accessToken = data['access_token'];
        _currentUser = data['user'];
        _saveSessionToStorage();
        
        return {
          'success': true,
          'user': _currentUser,
          'message': 'Login berhasil!',
        };
      } else {
        final error = json.decode(response.body);
        return {
          'success': false,
          'message': _getErrorMessage(error['error_description'] ?? 'Login failed'),
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan. Silakan coba lagi.',
      };
    }
  }

  Future<Map<String, dynamic>> signUpWithEmail({
    required String email,
    required String password,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final Map<String, dynamic> body = {
        'email': email,
        'password': password,
      };
      
      if (metadata != null && metadata.isNotEmpty) {
        body['data'] = metadata;
      }
      
      final response = await http.post(
        Uri.parse('$_authUrl/signup'),
        headers: _headers(),
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Akun berhasil dibuat! Silakan cek email untuk verifikasi.',
        };
      } else {
        final error = json.decode(response.body);
        return {
          'success': false,
          'message': _getErrorMessage(error['error_description'] ?? 'Signup failed'),
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan. Silakan coba lagi.',
      };
    }
  }

  Future<Map<String, dynamic>> signInWithOAuth(String provider) async {
    try {
      const redirectUrl = 'https://rekty-anjany-5a2eb.web.app/auth/callback';
      final oauthUrl = '$_authUrl/authorize?provider=$provider&redirect_to=$redirectUrl';
      
      return {
        'success': true,
        'oauthUrl': oauthUrl,
        'message': 'Redirect to OAuth...',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'OAuth error: $e',
      };
    }
  }

  Future<Map<String, dynamic>> signInAnonymously() async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      
      _accessToken = 'guest_token_$timestamp';
      _currentUser = {
        'id': 'guest_$timestamp',
        'email': 'guest_$timestamp@temp.local',
        'user_metadata': {
          'full_name': 'Guest User',
          'is_guest': true,
        },
      };
      
      _saveSessionToStorage();
      
      return {
        'success': true,
        'user': _currentUser,
        'message': 'Login sebagai tamu berhasil!',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Gagal login sebagai tamu. Silakan coba lagi.',
      };
    }
  }

  Future<void> signOut() async {
    try {
      if (_accessToken != null) {
        await http.post(
          Uri.parse('$_authUrl/logout'),
          headers: _headers(token: _accessToken),
        );
      }
      
      _accessToken = null;
      _currentUser = null;
      _clearSessionFromStorage();
    } catch (e) {
      // Ignore
    }
  }

  Map<String, dynamic>? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  String? get accessToken => _accessToken;

  Future<void> saveOAuthSession(String token) async {
    try {
      _accessToken = token;
      
      final response = await http.get(
        Uri.parse('$_authUrl/user'),
        headers: _headers(token: token),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _currentUser = data;
        _saveSessionToStorage();
      }
    } catch (e) {
      // Ignore
    }
  }

  String _getErrorMessage(String error) {
    error = error.toLowerCase();
    
    if (error.contains('invalid login credentials') || error.contains('invalid credentials')) {
      return 'Email atau password salah';
    } else if (error.contains('email not confirmed')) {
      return 'Email belum diverifikasi. Silakan cek inbox Anda';
    } else if (error.contains('user already registered')) {
      return 'Email sudah terdaftar';
    } else if (error.contains('password should be at least 6 characters')) {
      return 'Password minimal 6 karakter';
    } else if (error.contains('invalid email')) {
      return 'Format email tidak valid';
    } else if (error.contains('network')) {
      return 'Tidak ada koneksi internet';
    } else {
      return 'Terjadi kesalahan. Silakan coba lagi';
    }
  }
}
