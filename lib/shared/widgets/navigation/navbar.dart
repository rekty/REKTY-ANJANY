import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_shadow.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_breakpoints.dart';

import 'login_button.dart';
import 'nav_logo.dart';
import 'nav_menu.dart';

class Navbar extends StatelessWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    // Get actual screen width, not device type
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Show menu on screens >= 800px (lower threshold for desktop site on mobile)
    final bool showMenu = screenWidth >= 800;
    final bool useCompactPadding = screenWidth < 800;
    
    final double horizontalPadding = useCompactPadding 
        ? AppSpacing.mobilePadding 
        : AppSpacing.tabletPadding;

    // Debug: print screen width (remove after testing)
    debugPrint('🔍 Navbar - Screen width: $screenWidth, showMenu: $showMenu');

    return Container(
      height: AppSpacing.navbarHeight,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.background,
        boxShadow: AppShadow.navbar,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppSpacing.maxWidth,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
            ),
            child: Row(
              children: [
                const Flexible(child: NavLogo()),

                const Spacer(),

                // Show menu with responsive items
                if (showMenu) ...[
                  const NavMenu(),
                  const SizedBox(width: AppSpacing.xl),
                ],

                const LoginButton(),
                
                // Extra padding on right to prevent cutoff
                SizedBox(width: useCompactPadding ? 0 : AppSpacing.md),
              ],
            ),
          ),
        ),
      ),
    );
  }
}