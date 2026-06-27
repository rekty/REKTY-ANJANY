import 'package:flutter/material.dart';

import '../widgets/background/animated_background.dart';
import '../widgets/navigation/navbar.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;
  final Widget? footer;

  const AppScaffold({
    super.key,
    required this.child,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              const Navbar(),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      child,

                      if (footer != null) footer!,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}