import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Lazy loading image widget with placeholder and error handling
/// Automatically loads image when visible on screen
class LazyImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;

  const LazyImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          
          return placeholder ?? _buildDefaultPlaceholder(loadingProgress);
        },
        errorBuilder: (context, error, stackTrace) {
          return errorWidget ?? _buildDefaultError();
        },
        // Enable caching
        cacheWidth: width?.toInt(),
        cacheHeight: height?.toInt(),
      ),
    );
  }

  Widget _buildDefaultPlaceholder(ImageChunkEvent? loadingProgress) {
    final progress = loadingProgress?.expectedTotalBytes != null
        ? loadingProgress!.cumulativeBytesLoaded /
            loadingProgress.expectedTotalBytes!
        : null;

    return Container(
      width: width,
      height: height,
      color: AppColors.surface,
      child: Center(
        child: SizedBox(
          width: 40,
          height: 40,
          child: CircularProgressIndicator(
            value: progress,
            strokeWidth: 3,
            color: AppColors.primary.withValues(alpha: 0.5),
            backgroundColor: AppColors.border,
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultError() {
    return Container(
      width: width,
      height: height,
      color: AppColors.surface,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.broken_image_outlined,
              color: AppColors.textDisabled,
              size: 48,
            ),
            SizedBox(height: 8),
            Text(
              'Failed to load image',
              style: TextStyle(
                color: AppColors.textDisabled,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
