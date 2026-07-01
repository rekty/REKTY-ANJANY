import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';

class FontWeightField extends StatelessWidget {
  final String label;
  final String value;
  final ValueChanged<String?> onChanged;

  const FontWeightField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
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
        DropdownButtonFormField<String>(
          value: value.isEmpty ? 'bold' : value,
          style: const TextStyle(color: AppColors.textPrimary),
          dropdownColor: AppColors.surface,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.format_bold, size: 20),
          ),
          items: const [
            DropdownMenuItem(
              value: 'light',
              child: Text('Light (300)', style: TextStyle(fontWeight: FontWeight.w300)),
            ),
            DropdownMenuItem(
              value: 'normal',
              child: Text('Normal (400)', style: TextStyle(fontWeight: FontWeight.w400)),
            ),
            DropdownMenuItem(
              value: 'semibold',
              child: Text('Semi Bold (600)', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
            DropdownMenuItem(
              value: 'bold',
              child: Text('Bold (700)', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ],
          onChanged: onChanged,
        ),
      ],
    );
  }
}
