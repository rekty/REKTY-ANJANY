import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';

class AiTabBar extends StatelessWidget {
  final TabController controller;

  const AiTabBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.roundRadius,
        border: Border.all(color: AppColors.border),
      ),
      child: TabBar(
        controller: controller,
        indicator: const BoxDecoration(
          color: AppColors.primary,
          borderRadius: AppRadius.roundRadius,
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Colors.black,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
        padding: const EdgeInsets.all(4),
        tabs: const [
          Tab(
            icon: Icon(Icons.chat_rounded, size: 20),
            text: 'Chat Bot',
            height: 56,
          ),
          Tab(
            icon: Icon(Icons.image_rounded, size: 20),
            text: 'Image Generator',
            height: 56,
          ),
        ],
      ),
    );
  }
}
