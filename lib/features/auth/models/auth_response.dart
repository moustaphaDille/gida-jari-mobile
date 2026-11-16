import 'package:gida_jari_mobile/shared/models/user_profile.dart';

import 'profile_type_api.dart';

/// Réponse de register, login et refresh (même forme)
class AuthResponse {
  final String accessToken;
  final String refreshToken;
  final String userId;
  final ProfileType profileType;
  final String kycLevel; // ex: NIVEAU_1_TELEPHONE_VERIFIE
  final bool admin;
  final String? adminRole;

  const AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
    required this.profileType,
    required this.kycLevel,
    required this.admin,
    this.adminRole,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      userId: json['userId'] as String,
      profileType: profileTypeFromApi(json['profileType'] as String),
      kycLevel: json['kycLevel'] as String? ?? '',
      admin: json['admin'] as bool? ?? false,
      adminRole: json['adminRole'] as String?,
    );
  }
}
