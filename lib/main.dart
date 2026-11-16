import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/theme/app_theme.dart';
import 'app/routing/app_router.dart';


void main() {
  runApp(const ProviderScope(child: GidaJariApp()));
}

class GidaJariApp extends StatelessWidget {
  const GidaJariApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gida Jari',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
