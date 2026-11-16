import 'package:gida_jari_mobile/shared/models/user_profile.dart';

import 'profile_type_api.dart';

class RegisterRequest {
  final String temporaryToken;
  final ProfileType profileType;
  final String nom;
  final String prenom;
  final String adresse;
  final String password;
  final String confirmPassword;

  const RegisterRequest({
    required this.temporaryToken,
    required this.profileType,
    required this.nom,
    required this.prenom,
    required this.adresse,
    required this.password,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() => {
        'temporaryToken': temporaryToken,
        'profileType': profileType.apiValue,
        'nom': nom,
        'prenom': prenom,
        'adresse': adresse,
        'password': password,
        'confirmPassword': confirmPassword,
      };
}
