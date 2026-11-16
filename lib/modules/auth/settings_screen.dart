import 'package:flutter/material.dart';

import '../../app/routing/app_router.dart';
import '../../shared/widgets/settings_view.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Paramètres')),
      body: SettingsView(
        onViewProfile: () =>
            Navigator.of(context).pushNamed(AppRoutes.profile),
        onCompleteProfile: () =>
            Navigator.of(context).pushNamed(AppRoutes.completeProfile),
        onChangePassword: () =>
            Navigator.of(context).pushNamed(AppRoutes.changePassword),
      ),
    );
  }
}
