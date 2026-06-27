import 'package:flutter/material.dart';

class ImageCacheManager {
  static ImageCacheManager? _instance;
  static ImageCacheManager get instance => _instance ??= ImageCacheManager._();

  ImageCacheManager._();

  // Optimize image cache
  void initialize() {
    // Set image cache size (in MB)
    PaintingBinding.instance.imageCache.maximumSizeBytes = 100 << 20; // 100 MB
    PaintingBinding.instance.imageCache.maximumSize = 200; // 200 images
  }

  // Clear cache when needed
  void clearCache() {
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
  }

  // Preload important images
  Future<void> preloadImages(BuildContext context, List<String> imagePaths) async {
    for (final path in imagePaths) {
      await precacheImage(AssetImage(path), context);
    }
  }
}

// Optimized Image Widget with lazy loading
class OptimizedImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;

  const OptimizedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) return child;
        return AnimatedOpacity(
          opacity: frame == null ? 0 : 1,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          child: child,
        );
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return placeholder ??
            Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
                strokeWidth: 2,
              ),
            );
      },
      errorBuilder: (context, error, stackTrace) {
        return errorWidget ??
            Container(
              width: width,
              height: height,
              color: Colors.grey[900],
              child: const Icon(Icons.error_outline, color: Colors.white54),
            );
      },
      // Enable caching
      cacheWidth: width?.toInt(),
      cacheHeight: height?.toInt(),
    );
  }
}
