import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../shared/models/user_profile.dart';
import '../models/user_profile_data.dart';

class ProfileService {
  ProfileService(this._api);

  final ApiClient _api;

  Future<UserProfileData> getProfile({
    required String userId,
    required ProfileType profileType,
  }) async {
    final json = await _api.get(
      ApiEndpoints.profilePath(profileType, userId),
      auth: true,
    );
    return UserProfileData.fromJson(json);
  }

  Future<UserProfileData> completeProfile({
    required ProfileType profileType,
    required Map<String, dynamic> body,
  }) async {
    final json = await _api.patch(
      ApiEndpoints.completeProfilePath(profileType),
      body: body,
      auth: true,
    );
    return UserProfileData.fromJson(json);
  }
}
