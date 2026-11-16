import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/routing/app_router.dart';
import '../../features/profile/providers/profile_provider.dart';
import '../../shared/widgets/profile_details_view.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentProfileProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Mon profil')),
      body: profile.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(error.toString())),
        data: (data) => ProfileDetailsView(
          profile: data,
          onComplete: () =>
              Navigator.of(context).pushNamed(AppRoutes.completeProfile),
        ),
      ),
    );
  }
}
