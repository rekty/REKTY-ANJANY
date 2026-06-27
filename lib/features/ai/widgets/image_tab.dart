import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../shared/layout/responsive_container.dart';

class ImageTab extends StatefulWidget {
  const ImageTab({super.key});

  @override
  State<ImageTab> createState() => _ImageTabState();
}

class _ImageTabState extends State<ImageTab> {
  final _promptController = TextEditingController();
  String? _generatedImageUrl;
  bool _isGenerating = false;

  // Pollinations Image Models
  String _selectedModel = 'flux';
  final List<ImageModel> _models = const [
    ImageModel('flux', 'Flux', 'Fast & High Quality'),
    ImageModel('flux-pro', 'Flux Pro', 'Professional Quality'),
    ImageModel('flux-realism', 'Flux Realism', 'Photorealistic'),
    ImageModel('turbo', 'Turbo', 'Ultra Fast'),
    ImageModel('flux-anime', 'Flux Anime', 'Anime Style'),
    ImageModel('flux-3d', 'Flux 3D', '3D Rendering'),
    ImageModel('any-dark', 'Any Dark', 'Dark Art Style'),
  ];

  // Aspect Ratios
  String _selectedRatio = '1:1';
  final List<AspectRatioOption> _aspectRatios = const [
    AspectRatioOption('1:1', 'Square', '1024x1024'),
    AspectRatioOption('16:9', 'Landscape', '1280x720'),
    AspectRatioOption('9:16', 'Portrait', '720x1280'),
    AspectRatioOption('4:3', 'Standard', '1024x768'),
    AspectRatioOption('21:9', 'Ultrawide', '1920x820'),
    AspectRatioOption('3:2', 'Photo', '1080x720'),
  ];

  int? _seed;
  bool _noLogo = true;
  bool _enhance = false;

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  void _generateImage() {
    if (_promptController.text.trim().isEmpty) return;

    setState(() {
      _isGenerating = true;
    });

    // Calculate dimensions based on aspect ratio
    final dimensions = _getDimensions();

    // Build Pollinations image URL
    final encodedPrompt =
        Uri.encodeComponent(_promptController.text.trim());
    String url = 'https://image.pollinations.ai/prompt/$encodedPrompt';
    url += '?model=$_selectedModel';
    url += '&width=${dimensions['width']}';
    url += '&height=${dimensions['height']}';
    if (_seed != null) url += '&seed=$_seed';
    if (_noLogo) url += '&nologo=true';
    if (_enhance) url += '&enhance=true';

    setState(() {
      _generatedImageUrl = url;
      _isGenerating = false;
    });
  }

  Map<String, int> _getDimensions() {
    switch (_selectedRatio) {
      case '1:1':
        return {'width': 1024, 'height': 1024};
      case '16:9':
        return {'width': 1280, 'height': 720};
      case '9:16':
        return {'width': 720, 'height': 1280};
      case '4:3':
        return {'width': 1024, 'height': 768};
      case '21:9':
        return {'width': 1920, 'height': 820};
      case '3:2':
        return {'width': 1080, 'height': 720};
      default:
        return {'width': 1024, 'height': 1024};
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;

    return ResponsiveContainer(
      child: isMobile
          ? _buildMobileLayout()
          : _buildDesktopLayout(),
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.xl),
          _buildControls(),
          const SizedBox(height: AppSpacing.xl),
          _buildPreview(),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: AppSpacing.xl, bottom: AppSpacing.xl),
              child: _buildControls(),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.xl),
        Expanded(
          flex: 6,
          child: Padding(
            padding: const EdgeInsets.only(
                top: AppSpacing.xl, bottom: AppSpacing.xl),
            child: _buildPreview(),
          ),
        ),
      ],
    );
  }

  Widget _buildControls() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: AppRadius.card,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          const Text(
            'Image Settings',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: AppSpacing.xxl),

          // Prompt
          const Text(
            'Prompt',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            controller: _promptController,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: const InputDecoration(
              hintText: 'Describe the image you want to create...',
              hintStyle: TextStyle(color: AppColors.textDisabled),
            ),
            maxLines: 3,
          ),

          const SizedBox(height: AppSpacing.xxl),

          // Model Selection
          const Text(
            'Model',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: _models.map((model) {
              final isSelected = _selectedModel == model.id;
              return _ModelChip(
                model: model,
                isSelected: isSelected,
                onTap: () => setState(() => _selectedModel = model.id),
              );
            }).toList(),
          ),

          const SizedBox(height: AppSpacing.xxl),

          // Aspect Ratio
          const Text(
            'Aspect Ratio',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: _aspectRatios.map((ratio) {
              final isSelected = _selectedRatio == ratio.ratio;
              return _RatioChip(
                ratio: ratio,
                isSelected: isSelected,
                onTap: () => setState(() => _selectedRatio = ratio.ratio),
              );
            }).toList(),
          ),

          const SizedBox(height: AppSpacing.xxl),

          // Advanced Options
          Row(
            children: [
              Expanded(
                child: CheckboxListTile(
                  title: const Text(
                    'No Logo',
                    style: TextStyle(color: AppColors.textPrimary, fontSize: 14),
                  ),
                  value: _noLogo,
                  onChanged: (value) =>
                      setState(() => _noLogo = value ?? true),
                  contentPadding: EdgeInsets.zero,
                  activeColor: AppColors.primary,
                ),
              ),
              Expanded(
                child: CheckboxListTile(
                  title: const Text(
                    'Enhance',
                    style: TextStyle(color: AppColors.textPrimary, fontSize: 14),
                  ),
                  value: _enhance,
                  onChanged: (value) =>
                      setState(() => _enhance = value ?? false),
                  contentPadding: EdgeInsets.zero,
                  activeColor: AppColors.primary,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.xl),

          // Generate Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: _isGenerating ? null : _generateImage,
              icon: _isGenerating
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.black,
                      ),
                    )
                  : const Icon(Icons.auto_awesome_rounded),
              label: Text(_isGenerating ? 'Generating...' : 'Generate Image'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreview() {
    return Container(
      width: double.infinity,
      height: 600,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: AppRadius.card,
        border: Border.all(color: AppColors.border),
      ),
      child: _generatedImageUrl == null
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image_outlined,
                      size: 64, color: AppColors.textDisabled),
                  SizedBox(height: AppSpacing.lg),
                  Text(
                    'Your generated image will appear here',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          : ClipRRect(
              borderRadius: AppRadius.card,
              child: Image.network(
                _generatedImageUrl!,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline_rounded,
                            size: 64, color: AppColors.error),
                        SizedBox(height: AppSpacing.lg),
                        Text(
                          'Failed to load image',
                          style: TextStyle(
                            color: AppColors.error,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}

class ImageModel {
  final String id;
  final String name;
  final String description;

  const ImageModel(this.id, this.name, this.description);
}

class AspectRatioOption {
  final String ratio;
  final String name;
  final String resolution;

  const AspectRatioOption(this.ratio, this.name, this.resolution);
}

class _ModelChip extends StatelessWidget {
  final ImageModel model;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModelChip({
    required this.model,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: .15)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.border,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              model.name,
              style: TextStyle(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              model.description,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RatioChip extends StatelessWidget {
  final AspectRatioOption ratio;
  final bool isSelected;
  final VoidCallback onTap;

  const _RatioChip({
    required this.ratio,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: .15)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.border,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              ratio.ratio,
              style: TextStyle(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              ratio.name,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
