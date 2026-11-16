import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_providers.dart';

class SessionNotifier extends AsyncNotifier<bool> {
  // Au démarrage : connecté = on a un refresh token en stockage
  @override
  Future<bool> build() async {
    final refreshToken = await ref.read(tokenStorageProvider).readRefreshToken();
    return refreshToken != null;
  }

  Future<void> logout() async {
    await ref.read(tokenStorageProvider).clear();
    state = const AsyncData(false);
  }
}

final sessionProvider =
    AsyncNotifierProvider<SessionNotifier, bool>(SessionNotifier.new);
