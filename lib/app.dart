import 'package:flutter/material.dart';

class OurSpaceApp extends StatelessWidget {
  const OurSpaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OurSpace',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFE8A0BF)),
      ),
      home: const _SkeletonPlaceholder(),
    );
  }
}

class _SkeletonPlaceholder extends StatelessWidget {
  const _SkeletonPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: const Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'OurSpace',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Skeleton siap. Fitur menyusul.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
