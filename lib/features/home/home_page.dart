import 'package:flutter/material.dart';

import '../../shared/layout/app_scaffold.dart';

import 'sections/apps_section.dart';
import 'sections/blog_section.dart';
import 'sections/contact_section.dart';
import 'sections/downloads_section.dart';
import 'sections/footer_section.dart';
import 'sections/gallery_section.dart';
import 'sections/hero_section.dart';
import 'sections/store_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      child: Column(
        children: [
          HeroSection(),
          AppsSection(),
          DownloadsSection(),
          StoreSection(),
          GallerySection(),
          BlogSection(),
          ContactSection(),
          FooterSection(),
        ],
      ),
    );
  }
}
