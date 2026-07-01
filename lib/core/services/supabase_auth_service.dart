import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';

/// Supabase Authentication using official supabase_flutter package
/// More reliable for OAuth on web
class SupabaseAuthService {
  static SupabaseAuthService? _instance;
  static SupabaseAuthService get instance => _instance ??= SupabaseAuthService._();

  SupabaseAuthService._();
  
  // Get Supabase client (Supabase is initialized in main.dart)
  SupabaseClient get _supabase => Supabase.instance.client;

  // ==========================================
  // EMAIL/PASSWORD AUTHENTICATION
  // ==========================================
  
  Future<Map<String, dynamic>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      debugPrint('🔐 Attempting email/password login for: $email');
      
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      if (response.user != null) {
        debugPrint('✅ Login successful for: ${response.user!.email}');
        return {
          'success': true,
          'user': response.user!.toJson(),
          'message': 'Login berhasil!',
        };
      } else {
        debugPrint('❌ Login failed: No user returned');
        return {
          'success': false,
          'message': 'Login gagal',
        };
      }
    } on AuthException catch (e) {
      debugPrint('❌ Auth error: ${e.message}');
      return {
        'success': false,
        'message': _getErrorMessage(e.message),
      };
    } catch (e) {
      debugPrint('❌ Unexpected error: $e');
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
      debugPrint('📝 Attempting signup for: $email');
      
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: metadata,
      );
      
      if (response.user != null) {
        debugPrint('✅ Signup successful for: ${response.user!.email}');
        return {
          'success': true,
          'message': 'Akun berhasil dibuat! Silakan cek email untuk verifikasi.',
        };
      } else {
        return {
          'success': false,
          'message': 'Signup gagal',
        };
      }
    } on AuthException catch (e) {
      debugPrint('❌ Signup error: ${e.message}');
      return {
        'success': false,
        'message': _getErrorMessage(e.message),
      };
    } catch (e) {
      debugPrint('❌ Unexpected signup error: $e');
      return {
        'success': false,
        'message': 'Terjadi kesalahan. Silakan coba lagi.',
      };
    }
  }

  // ==========================================
  // OAUTH AUTHENTICATION
  // ==========================================
  
  Future<Map<String, dynamic>> signInWithOAuth(String provider) async {
    try {
      debugPrint('🔐 Starting OAuth flow for provider: $provider');
      
      // For web, signInWithOAuth returns bool and automatically redirects
      if (kIsWeb) {
        await _supabase.auth.signInWithOAuth(
          _getOAuthProvider(provider),
          redirectTo: 'https://rekty-anjany-5a2eb.web.app/auth/callback',
        );
        
        debugPrint('✅ OAuth redirect initiated');
        
        return {
          'success': true,
          'message': 'Redirecting to $provider...',
        };
      } else {
        // For mobile, return URL for manual handling
        final response = await _supabase.auth.signInWithOAuth(
          _getOAuthProvider(provider),
          redirectTo: 'https://rekty-anjany-5a2eb.web.app/auth/callback',
        );
        
        return {
          'success': true,
          'message': 'Redirect to OAuth...',
        };
      }
    } on AuthException catch (e) {
      debugPrint('❌ OAuth error: ${e.message}');
      return {
        'success': false,
        'message': 'OAuth error: ${e.message}',
      };
    } catch (e) {
      debugPrint('❌ Unexpected OAuth error: $e');
      return {
        'success': false,
        'message': 'OAuth error: $e',
      };
    }
  }
  
  OAuthProvider _getOAuthProvider(String provider) {
    switch (provider.toLowerCase()) {
      case 'google':
        return OAuthProvider.google;
      case 'github':
        return OAuthProvider.github;
      case 'facebook':
        return OAuthProvider.facebook;
      default:
        throw Exception('Unsupported OAuth provider: $provider');
    }
  }

  // ==========================================
  // ANONYMOUS AUTHENTICATION
  // ==========================================
  
  Future<Map<String, dynamic>> signInAnonymously() async {
    try {
      debugPrint('👤 Attempting anonymous login');
      
      final response = await _supabase.auth.signInAnonymously();
      
      if (response.user != null) {
        debugPrint('✅ Anonymous login successful');
        return {
          'success': true,
          'user': response.user!.toJson(),
          'message': 'Login sebagai tamu berhasil!',
        };
      } else {
        return {
          'success': false,
          'message': 'Gagal login sebagai tamu',
        };
      }
    } on AuthException catch (e) {
      debugPrint('❌ Anonymous login error: ${e.message}');
      return {
        'success': false,
        'message': 'Gagal login sebagai tamu: ${e.message}',
      };
    } catch (e) {
      debugPrint('❌ Unexpected anonymous login error: $e');
      return {
        'success': false,
        'message': 'Gagal login sebagai tamu. Silakan coba lagi.',
      };
    }
  }

  // ==========================================
  // SIGN OUT
  // ==========================================
  
  Future<Map<String, dynamic>> signOut() async {
    try {
      debugPrint('🚪 Signing out');
      
      await _supabase.auth.signOut();
      
      debugPrint('✅ Sign out successful');
      
      return {
        'success': true,
        'message': 'Logout berhasil',
      };
    } on AuthException catch (e) {
      debugPrint('❌ Sign out error: ${e.message}');
      return {
        'success': false,
        'message': 'Logout error: ${e.message}',
      };
    } catch (e) {
      debugPrint('❌ Unexpected sign out error: $e');
      return {
        'success': false,
        'message': 'Logout error: $e',
      };
    }
  }

  // ==========================================
  // EMAIL OTP AUTHENTICATION
  // ==========================================

  /// Send OTP code to email (passwordless login)
  Future<Map<String, dynamic>> signInWithOTP({
    required String email,
  }) async {
    try {
      debugPrint('📧 Sending OTP to: $email');
      
      await _supabase.auth.signInWithOtp(
        email: email,
        shouldCreateUser: true,
      );
      
      debugPrint('✅ OTP sent successfully');
      
      return {
        'success': true,
        'message': 'Kode OTP telah dikirim ke email Anda. Silakan cek inbox.',
      };
    } on AuthException catch (e) {
      debugPrint('❌ OTP send error: ${e.message}');
      return {
        'success': false,
        'message': _getErrorMessage(e.message),
      };
    } catch (e) {
      debugPrint('❌ Unexpected OTP send error: $e');
      return {
        'success': false,
        'message': 'Terjadi kesalahan. Silakan coba lagi.',
      };
    }
  }

  /// Verify OTP code and login
  Future<Map<String, dynamic>> verifyOTP({
    required String email,
    required String token,
  }) async {
    try {
      debugPrint('🔐 Verifying OTP for: $email');
      
      final response = await _supabase.auth.verifyOTP(
        email: email,
        token: token,
        type: OtpType.email,
      );
      
      if (response.user != null) {
        debugPrint('✅ OTP verification successful');
        return {
          'success': true,
          'user': response.user!.toJson(),
          'message': 'Login berhasil!',
        };
      } else {
        return {
          'success': false,
          'message': 'Verifikasi OTP gagal',
        };
      }
    } on AuthException catch (e) {
      debugPrint('❌ OTP verification error: ${e.message}');
      return {
        'success': false,
        'message': _getErrorMessage(e.message),
      };
    } catch (e) {
      debugPrint('❌ Unexpected OTP verification error: $e');
      return {
        'success': false,
        'message': 'Terjadi kesalahan. Silakan coba lagi.',
      };
    }
  }

  // ==========================================
  // HELPER METHODS
  // ==========================================

  Map<String, dynamic>? get currentUser {
    final user = _supabase.auth.currentUser;
    return user?.toJson();
  }
  
  bool get isAuthenticated => _supabase.auth.currentUser != null;
  
  String? get accessToken => _supabase.auth.currentSession?.accessToken;
  
  User? get user => _supabase.auth.currentUser;

  Future<void> saveOAuthSession(String token) async {
    try {
      debugPrint('💾 Attempting to save OAuth session with token');
      
      // The Supabase Flutter SDK automatically handles session management
      // when OAuth redirects back with access_token in the URL fragment
      // We just need to check if the session is already saved
      
      final currentUser = _supabase.auth.currentUser;
      if (currentUser != null) {
        debugPrint('✅ OAuth session already saved by SDK');
        debugPrint('   User: ${currentUser.email}');
      } else {
        debugPrint('⚠️ No user session found after OAuth callback');
      }
    } catch (e) {
      debugPrint('❌ Error in saveOAuthSession: $e');
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
    } else if (error.contains('invalid otp') || error.contains('otp expired') || error.contains('token has expired')) {
      return 'Kode OTP salah atau sudah kadaluarsa';
    } else if (error.contains('email rate limit')) {
      return 'Terlalu banyak permintaan. Tunggu beberapa menit.';
    } else {
      return 'Terjadi kesalahan. Silakan coba lagi';
    }
  }
}
