import 'package:gida_jari_mobile/shared/models/user_profile.dart';

/// Pont entre le ProfileType de l'UI et les valeurs du backend.
/// (remplace l'ancien profile_type.dart : un seul enum dans l'app)
extension ProfileTypeApi on ProfileType {
  String get apiValue => switch (this) {
        ProfileType.client => 'CLIENT_PARTICULIER',
        ProfileType.artisan => 'ARTISAN',
        ProfileType.entrepriseBtp => 'ENTREPRISE_BTP',
        ProfileType.architecteIngenieur => 'INGENIEUR_ARCHITECTE',
        ProfileType.fournisseurMateriaux => 'FOURNISSEUR_MATERIAUX',
        ProfileType.ongInstitution => 'ONG_INSTITUTION',
      };
}

ProfileType profileTypeFromApi(String value) => switch (value) {
      'CLIENT_PARTICULIER' => ProfileType.client,
      'ARTISAN' => ProfileType.artisan,
      'ENTREPRISE_BTP' => ProfileType.entrepriseBtp,
      'INGENIEUR_ARCHITECTE' => ProfileType.architecteIngenieur,
      'FOURNISSEUR_MATERIAUX' => ProfileType.fournisseurMateriaux,
      'ONG_INSTITUTION' => ProfileType.ongInstitution,
      _ => throw ArgumentError('ProfileType inconnu : $value'),
    };
