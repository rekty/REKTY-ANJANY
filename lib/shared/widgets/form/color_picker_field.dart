import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_radius.dart';

class ColorPickerField extends StatelessWidget {
  final String label;
  final String value;
  final ValueChanged<String> onChanged;

  const ColorPickerField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  Color _parseColor(String hexColor) {
    try {
      return Color(int.parse(hexColor.replaceFirst('#', '0xFF')));
    } catch (e) {
      return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentColor = _parseColor(value);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            // Color preview
            GestureDetector(
              onTap: () => _showColorPicker(context),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: currentColor,
                  borderRadius: AppRadius.input,
                  border: Border.all(color: AppColors.border),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            // Hex input
            Expanded(
              child: TextFormField(
                initialValue: value,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: const InputDecoration(
                  hintText: '#FFFFFF',
                  prefixIcon: Icon(Icons.palette, size: 20),
                ),
                onChanged: (val) {
                  if (val.startsWith('#') && (val.length == 7 || val.length == 4)) {
                    onChanged(val);
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showColorPicker(BuildContext context) {
    // Predefined colors
    final presetColors = [
      '#FFFFFF', // White
      '#000000', // Black
      '#54C5F8', // Cyan
      '#34D399', // Green
      '#F59E0B', // Orange
      '#EF4444', // Red
      '#8B5CF6', // Purple
      '#EC4899', // Pink
      '#94A3B8', // Gray
      '#FFD700', // Gold
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        title: const Text(
          'Select Color',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: SizedBox(
          width: 300,
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: presetColors.map((hex) {
              final color = _parseColor(hex);
              final isSelected = value.toUpperCase() == hex.toUpperCase();
              return GestureDetector(
                onTap: () {
                  onChanged(hex);
                  Navigator.of(context).pop();
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                      width: isSelected ? 3 : 1,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
