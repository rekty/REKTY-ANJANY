import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class GradientHeading extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final double height;

  const GradientHeading({
    super.key,
    required this.text,
    this.fontSize = 72,
    this.fontWeight = FontWeight.w900,
    this.textAlign = TextAlign.left,
    this.height = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) {
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            AppColors.primary,
            AppColors.accent,
          ],
          stops: [
            0.0,
            0.55,
            1.0,
          ],
        ).createShader(bounds);
      },
      child: Text(
        text,
        textAlign: textAlign,
        style: TextStyle(
          fontSize: fontSize,
          height: height,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}