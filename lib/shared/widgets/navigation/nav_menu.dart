import 'package:flutter/material.dart';

import '../../../core/constants/app_spacing.dart';
import 'nav_item.dart';

class NavMenu extends StatelessWidget {
  final bool isCompact;
  
  const NavMenu({
    super.key,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Full menu for large screens (>= 1100px)
    if (screenWidth >= 1100 && !isCompact) {
      return const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          NavItem(title: 'Home', route: '/', isActive: true),
          SizedBox(width: AppSpacing.lg),
          NavItem(title: 'Apps', route: '/apps'),
          SizedBox(width: AppSpacing.lg),
          NavItem(title: 'Downloads', route: '/downloads'),
          SizedBox(width: AppSpacing.lg),
          NavItem(title: 'Store', route: '/store'),
          SizedBox(width: AppSpacing.lg),
          NavItem(title: 'Gallery', route: '/gallery'),
          SizedBox(width: AppSpacing.lg),
          NavItem(title: 'Blog', route: '/blog'),
          SizedBox(width: AppSpacing.lg),
          NavItem(title: 'About', route: '/about'),
          SizedBox(width: AppSpacing.lg),
          NavItem(title: 'Contact', route: '/contact'),
        ],
      );
    }
    
    // Medium menu for tablets and desktop site on mobile (800-1099px)
    // Show 5 most important: Home, Apps, Downloads, Store, Blog
    if (screenWidth >= 800 && screenWidth < 1100 && !isCompact) {
      return const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          NavItem(title: 'Home', route: '/', isActive: true),
          SizedBox(width: AppSpacing.md),
          NavItem(title: 'Apps', route: '/apps'),
          SizedBox(width: AppSpacing.md),
          NavItem(title: 'Downloads', route: '/downloads'),
          SizedBox(width: AppSpacing.md),
          NavItem(title: 'Store', route: '/store'),
          SizedBox(width: AppSpacing.md),
          NavItem(title: 'Blog', route: '/blog'),
        ],
      );
    }
    
    // Compact: hide all menu items (< 800px or isCompact)
    return const SizedBox.shrink();
  }
}