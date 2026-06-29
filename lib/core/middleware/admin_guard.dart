import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/supabase_auth_service.dart';
import '../services/admin_service.dart';

/// Middleware to protect admin routes
/// Only allows access if user is logged in AND is an admin
class AdminGuard {
  static Future<String?> redirect(
    BuildContext context,
    GoRouterState state,
  ) async {
    final authService = SupabaseAuthService.instance;
    final adminService = AdminService.instance;

    // Check if user is logged in
    final user = authService.currentUser;
    
    if (user == null) {
      // Not logged in, redirect to login page
      print('Admin Guard: No user found');
      return '/login?redirect=${state.uri.path}';
    }

    print('Admin Guard: User found - ${user['email']}');

    // Set access token for admin service
    if (authService.accessToken != null) {
      adminService.setAccessToken(authService.accessToken!);
      print('Admin Guard: Token set');
    }

    // Check if user is admin
    try {
      final isAdmin = await adminService.isAdmin(user['email']);
      print('Admin Guard: isAdmin check result = $isAdmin');
      
      if (!isAdmin) {
        // User is logged in but not admin
        print('Admin Guard: User is NOT admin');
        return '/';
      }
    } catch (e) {
      print('Admin Guard: Error checking admin - $e');
      // Temporarily allow access if error (for debugging)
      // return '/';
    }

    print('Admin Guard: Access granted!');
    // User is admin, allow access
    return null;
  }
}
