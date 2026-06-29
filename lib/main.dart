import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'core/utils/image_cache_manager.dart';
import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Performance optimizations
  if (kIsWeb) {
    debugPrint('Running in optimized web mode');
  }

  // Initialize image cache manager
  ImageCacheManager.instance.initialize();

  // Don't initialize Supabase here - it will be initialized on-demand
  // This avoids null pointer errors on web startup

  runApp(const RektyAnjanyApp());
}