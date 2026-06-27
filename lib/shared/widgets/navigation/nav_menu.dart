import 'package:flutter/material.dart';

import '../../../core/constants/app_breakpoints.dart';
import '../../../core/constants/app_spacing.dart';
import 'nav_item.dart';

class NavMenu extends StatelessWidget {
  const NavMenu({super.key});

  @override
  Widget build(BuildContext context) {
    // Sembunyikan menu pada mobile
    if (AppBreakpoints.isMobile(context)) {
      return const SizedBox.shrink();
    }

    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        NavItem(
          title: 'Home',
          route: '/',
          isActive: true,
        ),

        SizedBox(width: AppSpacing.xl),

        NavItem(
          title: 'Apps',
          route: '/apps',
        ),

        SizedBox(width: AppSpacing.xl),

        NavItem(
          title: 'Downloads',
          route: '/downloads',
        ),

        SizedBox(width: AppSpacing.xl),

        NavItem(
          title: 'Store',
          route: '/store',
        ),

        SizedBox(width: AppSpacing.xl),

        NavItem(
          title: 'Gallery',
          route: '/gallery',
        ),

        SizedBox(width: AppSpacing.xl),

        NavItem(
          title: 'Blog',
          route: '/blog',
        ),

        SizedBox(width: AppSpacing.xl),

        NavItem(
          title: 'About',
          route: '/about',
        ),

        SizedBox(width: AppSpacing.xl),

        NavItem(
          title: 'Contact',
          route: '/contact',
        ),
      ],
    );
  }
}