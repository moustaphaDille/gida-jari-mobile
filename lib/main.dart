import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/routing/app_router.dart';

void main() {
  runApp(const GidaJariApp());
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
