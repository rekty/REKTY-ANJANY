import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/about/about_page.dart';
import '../features/ai/ai_page.dart';
import '../features/apps/apps_page_supabase.dart';
import '../features/auth/auth_callback_page.dart';
import '../features/blog/blog_page_supabase.dart';
import '../features/contact/contact_page.dart';
import '../features/downloads/downloads_page_supabase.dart';
import '../features/gallery/gallery_page_supabase.dart';
import '../features/home/home_page.dart';
import '../features/login/login_page.dart';
import '../features/store/store_page_supabase.dart';
import '../features/admin/admin_layout.dart';
import '../features/admin/dashboard/admin_dashboard_page.dart';
import '../features/admin/apps/admin_apps_page.dart';
import '../features/admin/downloads/admin_downloads_page.dart';
import '../core/middleware/admin_guard.dart';

class AppRouter {
  AppRouter._();

  static final router = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    errorBuilder: (context, state) {
      print('🔴 [Router] Error for URI: ${state.uri}');
      print('🔴 [Router] Error: ${state.error}');
      
      // Handle OAuth callback - check both path and query
      final uriString = state.uri.toString();
      if (uriString.contains('access_token') || 
          state.uri.path == '/auth/callback' ||
          uriString.contains('/auth/callback')) {
        print('✅ [Router] Detected OAuth callback, showing AuthCallbackPage');
        return const AuthCallbackPage();
      }
      
      // Show error page for other unknown routes
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Route not found: ${state.uri.path}'),
              const SizedBox(height: 8),
              Text('Error: ${state.error}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go('/'),
                child: const Text('Go Home'),
              ),
            ],
          ),
        ),
      );
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (_, __) => const HomePage(),
      ),
      GoRoute(
        path: '/ai',
        builder: (_, __) => const AiPage(),
      ),
      GoRoute(
        path: '/apps',
        builder: (_, __) => const AppsPageSupabase(),
      ),
      GoRoute(
        path: '/downloads',
        builder: (_, __) => const DownloadsPageSupabase(),
      ),
      GoRoute(
        path: '/store',
        builder: (_, __) => const StorePageSupabase(),
      ),
      GoRoute(
        path: '/gallery',
        builder: (_, __) => const GalleryPageSupabase(),
      ),
      GoRoute(
        path: '/blog',
        builder: (_, __) => const BlogPageSupabase(),
      ),
      GoRoute(
        path: '/about',
        builder: (_, __) => const AboutPage(),
      ),
      GoRoute(
        path: '/contact',
        builder: (_, __) => const ContactPage(),
      ),
      GoRoute(
        path: '/login',
        builder: (_, __) => const LoginPage(),
      ),
      GoRoute(
        path: '/auth/callback',
        builder: (_, __) => const AuthCallbackPage(),
      ),
      
      // Admin routes - Auth check dilakukan di masing-masing page
      ShellRoute(
        builder: (context, state, child) => AdminLayout(child: child),
        routes: [
          GoRoute(
            path: '/admin',
            builder: (_, __) => const AdminDashboardPage(),
          ),
          GoRoute(
            path: '/admin/apps',
            builder: (_, __) => const AdminAppsPage(),
          ),
          GoRoute(
            path: '/admin/downloads',
            builder: (_, __) => const AdminDownloadsPage(),
          ),
          // More admin routes will be added here (store, gallery, blog, etc.)
        ],
      ),
    ],
  );
}