import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'core/config/supabase_config.dart';
import 'core/services/supabase_service.dart';
import 'core/utils/image_cache_manager.dart';
import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Performance optimizations
  if (kIsWeb) {
    // Optimize for web
    debugPrint('Running in optimized web mode');
  }

  // Initialize image cache manager
  ImageCacheManager.instance.initialize();

  // Initialize Supabase
  await SupabaseService.initialize(
    supabaseUrl: SupabaseConfig.supabaseUrl,
    supabaseAnonKey: SupabaseConfig.supabaseAnonKey,
  );

  runApp(const RektyAnjanyApp());
}