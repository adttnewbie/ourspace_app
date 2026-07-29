import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'shared/widgets/shared_widgets_gallery.dart';

class OurSpaceApp extends StatelessWidget {
  const OurSpaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OurSpace',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const SharedWidgetsGallery(),
    );
  }
}
