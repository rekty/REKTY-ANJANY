import 'package:flutter/material.dart';
import 'router.dart';
import 'theme.dart';

class RektyAnjanyApp extends StatelessWidget {
  const RektyAnjanyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Rekty Anjany',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: AppRouter.router,
    );
  }
}