import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_shadow.dart';
import '../../../core/constants/app_spacing.dart';

import 'login_button.dart';
import 'nav_logo.dart';
import 'nav_menu.dart';

class Navbar extends StatelessWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
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
          child: const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.desktopPadding,
            ),
            child: Row(
              children: [
                NavLogo(),

                Spacer(),

                NavMenu(),

                SizedBox(width: AppSpacing.xxl),

                LoginButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}