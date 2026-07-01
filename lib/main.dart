import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/config/supabase_config.dart';
import 'core/utils/image_cache_manager.dart';
import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase
  try {
    await Supabase.initialize(
      url: SupabaseConfig.supabaseUrl,
      anonKey: SupabaseConfig.supabaseAnonKey,
    );
    debugPrint('✅ Supabase initialized in main.dart');
  } catch (e) {
    debugPrint('⚠️ Supabase initialization error (might be already initialized): $e');
  }
  
  // Configure URL strategy for clean URLs (no hash) on web
  if (kIsWeb) {
    usePathUrlStrategy();
    debugPrint('Running in optimized web mode with path-based URLs');
  }

  // Performance optimizations
  if (kIsWeb) {
    debugPrint('Running in optimized web mode');
  }

  // Initialize image cache manager
  ImageCacheManager.instance.initialize();

  runApp(const RektyAnjanyApp());
}