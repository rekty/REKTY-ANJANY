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

class AppRouter {
  AppRouter._();

  static final router = GoRouter(
    initialLocation: '/',
    errorBuilder: (context, state) {
      // Handle OAuth callback errors - redirect to callback page
      if (state.uri.toString().contains('access_token')) {
        return const AuthCallbackPage();
      }
      // Otherwise show home page for unknown routes
      return const HomePage();
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
    ],
  );
}