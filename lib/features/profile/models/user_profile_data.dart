import '../../../shared/models/user_profile.dart';
import '../../auth/models/profile_type_api.dart';

class UserProfileData {
  final Map<String, dynamic> values;

  const UserProfileData(this.values);

  String? get id => values['id'] as String?;
  String? get nom => values['nom'] as String?;
  String? get prenom => values['prenom'] as String?;
  String? get nomAffiche {
    final parts = [prenom, nom].whereType<String>().where((v) => v.isNotEmpty);
    return parts.isEmpty ? null : parts.join(' ');
  }

  String? get profileTypeValue => values['profileType'] as String?;
  ProfileType? get profileType {
    final value = profileTypeValue;
    if (value == null) return null;
    try {
      return profileTypeFromApi(value);
    } on ArgumentError {
      return null;
    }
  }

  String get displayRole => profileType?.label ?? 'Profil';
  double get profileScore => (values['profileScore'] as num?)?.toDouble() ?? 0;

  factory UserProfileData.fromJson(Map<String, dynamic> json) =>
      UserProfileData(Map<String, dynamic>.from(json));
}
