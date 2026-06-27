import 'package:flutter/material.dart';

import '../../core/constants/app_breakpoints.dart';
import '../../core/constants/app_spacing.dart';

class ResponsiveContainer extends StatelessWidget {
  final Widget child;

  const ResponsiveContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    double horizontalPadding;

    if (AppBreakpoints.isMobile(context)) {
      horizontalPadding = AppSpacing.mobilePadding;
    } else if (AppBreakpoints.isTablet(context)) {
      horizontalPadding = AppSpacing.tabletPadding;
    } else {
      horizontalPadding = AppSpacing.desktopPadding;
    }

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: AppSpacing.maxWidth,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
          ),
          child: child,
        ),
      ),
    );
  }
}