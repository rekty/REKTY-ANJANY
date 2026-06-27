import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_duration.dart';

class NavItem extends StatefulWidget {
  final String title;
  final String route;
  final bool isActive;

  const NavItem({
    super.key,
    required this.title,
    required this.route,
    this.isActive = false,
  });

  @override
  State<NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<NavItem> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final bool active = widget.isActive;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: () => context.go(widget.route),
        child: AnimatedContainer(
          duration: AppDuration.hover,
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: active || _hover
                    ? AppColors.primary
                    : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: AnimatedDefaultTextStyle(
            duration: AppDuration.hover,
            style: TextStyle(
              color: active || _hover
                  ? AppColors.primary
                  : AppColors.textSecondary,
              fontSize: 15,
              fontWeight:
                  active ? FontWeight.bold : FontWeight.w500,
            ),
            child: Text(widget.title),
          ),
        ),
      ),
    );
  }
}