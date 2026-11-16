import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/providers/auth_providers.dart';
import '../../auth/models/profile_type_api.dart';
import '../../../shared/models/user_profile.dart';
import '../models/user_profile_data.dart';
import '../services/profile_service.dart';

final profileServiceProvider = Provider<ProfileService>(
  (ref) => ProfileService(ref.watch(apiClientProvider)),
);

class CurrentProfileNotifier extends AsyncNotifier<UserProfileData> {
  @override
  Future<UserProfileData> build() async {
    final storage = ref.read(tokenStorageProvider);
    final userId = await storage.readUserId();
    final profileValue = await storage.readProfileType();
    if (userId == null || profileValue == null) {
      throw StateError('Session utilisateur introuvable');
    }

    final profileType = profileTypeFromApi(profileValue);
    return ref.read(profileServiceProvider).getProfile(
          userId: userId,
          profileType: profileType,
        );
  }

  Future<void> refreshProfile() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(build);
  }

  Future<void> complete({
    required ProfileType profileType,
    required Map<String, dynamic> body,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(profileServiceProvider).completeProfile(
            profileType: profileType,
            body: body,
          ),
    );
  }
}

final currentProfileProvider =
    AsyncNotifierProvider<CurrentProfileNotifier, UserProfileData>(
  CurrentProfileNotifier.new,
);
