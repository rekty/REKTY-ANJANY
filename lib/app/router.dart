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
import '../features/admin/apps/admin_app_form_page.dart';
import '../features/admin/downloads/admin_downloads_page.dart';
import '../features/admin/downloads/admin_download_form_page.dart';
import '../features/admin/store/admin_store_page.dart';
import '../features/admin/store/admin_product_form_page.dart';
import '../features/admin/gallery/admin_gallery_page.dart';
import '../features/admin/gallery/admin_gallery_form_page.dart';
import '../features/admin/blog/admin_blog_page.dart';
import '../features/admin/blog/admin_blog_form_page.dart';
import '../features/admin/about/admin_about_page.dart';
import '../features/admin/messages/admin_messages_page.dart';
import '../features/admin/contact/admin_contact_page.dart';
import '../core/middleware/admin_guard.dart';
import '../core/services/supabase_auth_service.dart';
import '../core/services/admin_service.dart';

class AppRouter {
  AppRouter._();

  static final router = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    // Path-based routing is enabled by default in go_router 13.x
    // See index.html for usePathUrlStrategy configuration
    redirect: (context, state) async {
      final path = state.uri.path;
      print('🔍 [Router] Redirect check for path: $path');
      
      // Skip auth check for non-admin routes
      if (!path.startsWith('/admin')) {
        print('✅ [Router] Public route, allowing access');
        return null;
      }
      
      print('🔐 [Router] Admin route detected, checking authentication...');
      
      // Check if user is logged in
      final authService = SupabaseAuthService.instance;
      final user = authService.currentUser;
      
      if (user == null) {
        print('❌ [Router] No user logged in, redirecting to login');
        // Not logged in, redirect to login
        return '/login?redirect=${Uri.encodeComponent(path)}';
      }
      
      print('✅ [Router] User logged in: ${user['email']}');
      
      // Check if user is admin
      final adminService = AdminService.instance;
      final token = authService.accessToken;
      
      if (token != null) {
        adminService.setAccessToken(token);
      }
      
      final userEmail = user['email'] ?? '';
      print('🔍 [Router] Checking if $userEmail is admin...');
      final isAdmin = await adminService.isAdmin(userEmail);
      
      if (!isAdmin) {
        print('❌ [Router] User is NOT admin, redirecting to home');
        // Not admin, redirect to home
        return '/';
      }
      
      print('✅ [Router] User IS admin, allowing access to $path');
      // User is admin, allow access
      return null;
    },
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
            path: '/admin/apps/create',
            builder: (_, __) => const AdminAppFormPage(),
          ),
          GoRoute(
            path: '/admin/apps/edit/:id',
            builder: (_, state) => AdminAppFormPage(
              appId: state.pathParameters['id'],
            ),
          ),
          GoRoute(
            path: '/admin/downloads',
            builder: (_, __) => const AdminDownloadsPage(),
          ),
          GoRoute(
            path: '/admin/downloads/create',
            builder: (_, __) => const AdminDownloadFormPage(),
          ),
          GoRoute(
            path: '/admin/downloads/edit/:id',
            builder: (_, state) => AdminDownloadFormPage(
              downloadId: state.pathParameters['id'],
            ),
          ),
          GoRoute(
            path: '/admin/store',
            builder: (_, __) => const AdminStorePage(),
          ),
          GoRoute(
            path: '/admin/store/create',
            builder: (_, __) => const AdminProductFormPage(),
          ),
          GoRoute(
            path: '/admin/store/edit/:id',
            builder: (_, state) => AdminProductFormPage(
              productId: state.pathParameters['id'],
            ),
          ),
          GoRoute(
            path: '/admin/gallery',
            builder: (_, __) => const AdminGalleryPage(),
          ),
          GoRoute(
            path: '/admin/gallery/create',
            builder: (_, __) => const AdminGalleryFormPage(),
          ),
          GoRoute(
            path: '/admin/gallery/edit/:id',
            builder: (_, state) => AdminGalleryFormPage(
              itemId: state.pathParameters['id'],
            ),
          ),
          GoRoute(
            path: '/admin/blog',
            builder: (_, __) => const AdminBlogPage(),
          ),
          GoRoute(
            path: '/admin/blog/create',
            builder: (_, __) => const AdminBlogFormPage(),
          ),
          GoRoute(
            path: '/admin/blog/edit/:id',
            builder: (_, state) => AdminBlogFormPage(
              postId: state.pathParameters['id'],
            ),
          ),
          GoRoute(
            path: '/admin/about',
            builder: (_, __) => const AdminAboutPage(),
          ),
          GoRoute(
            path: '/admin/messages',
            builder: (_, __) => const AdminMessagesPage(),
          ),
          GoRoute(
            path: '/admin/contact',
            builder: (_, __) => const AdminContactPage(),
          ),
        ],
      ),
    ],
  );
}