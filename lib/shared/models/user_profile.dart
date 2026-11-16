import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

/// Les 6 profils du cahier des charges : Client (demandeur), Artisan,
/// Architecte/Ingénieur, Entreprise BTP, Fournisseur de matériaux,
/// ONG/Institution.
enum ProfileType {
  client,
  artisan,
  architecteIngenieur,
  entrepriseBtp,
  fournisseurMateriaux,
  ongInstitution,
}

extension ProfileTypeX on ProfileType {
  String get label {
    switch (this) {
      case ProfileType.client:
        return 'Client Particulier';
      case ProfileType.artisan:
        return 'Artisan';
      case ProfileType.architecteIngenieur:
        return 'Architecte / Ingénieur';
      case ProfileType.entrepriseBtp:
        return 'Entreprise BTP';
      case ProfileType.fournisseurMateriaux:
        return 'Fournisseur de matériaux';
      case ProfileType.ongInstitution:
        return 'ONG / Institution';
    }
  }

  String get pitch {
    switch (this) {
      case ProfileType.client:
        return 'Je veux construire, rénover ou financer un chantier';
      case ProfileType.artisan:
        return 'Je propose mes services sur les chantiers (maçon, plombier, électricien...)';
      case ProfileType.architecteIngenieur:
        return "Je conçois, je supervise, j'apporte mon expertise technique";
      case ProfileType.entrepriseBtp:
        return "Je dirige une structure qui exécute des chantiers dans leur globalité";
      case ProfileType.fournisseurMateriaux:
        return 'Je vends des matériaux de construction (ciment, fer, bois...)';
      case ProfileType.ongInstitution:
        return 'Je pilote des projets BTP d’intérêt collectif pour mon organisation';
    }
  }

  Color get color {
    switch (this) {
      case ProfileType.client:
        return AppColors.clientColor;
      case ProfileType.artisan:
        return AppColors.artisanColor;
      case ProfileType.architecteIngenieur:
        return AppColors.architecteColor;
      case ProfileType.entrepriseBtp:
        return AppColors.successGreen;
      case ProfileType.fournisseurMateriaux:
        return AppColors.goldAccent;
      case ProfileType.ongInstitution:
        return AppColors.precisionTeal;
    }
  }

  IconData get icon {
    switch (this) {
      case ProfileType.client:
        return Icons.home_rounded;
      case ProfileType.artisan:
        return Icons.construction_rounded;
      case ProfileType.architecteIngenieur:
        return Icons.architecture_rounded;
      case ProfileType.entrepriseBtp:
        return Icons.apartment_rounded;
      case ProfileType.fournisseurMateriaux:
        return Icons.storefront_rounded;
      case ProfileType.ongInstitution:
        return Icons.handshake_rounded;
    }
  }

  /// Seuls les professionnels indépendants choisissent un métier précis
  /// (Artisan ou Architecte/Ingénieur) via le dropdown de RegistrationScreen.
  bool get isIndependentProfessional =>
      this == ProfileType.artisan || this == ProfileType.architecteIngenieur;

  /// Label du champ "nom de structure" affiché à la place du dropdown métier
  /// pour Entreprise BTP / Fournisseur / ONG.
  String? get structureFieldLabel {
    switch (this) {
      case ProfileType.entrepriseBtp:
        return 'Raison sociale de l’entreprise';
      case ProfileType.fournisseurMateriaux:
        return 'Nom du commerce';
      case ProfileType.ongInstitution:
        return 'Nom de l’organisation';
      default:
        return null;
    }
  }
}

/// Statut de disponibilité temps réel (Module M02 / Section 4 design system).
enum AvailabilityStatus { availableNow, availableFrom, unavailable }

extension AvailabilityStatusX on AvailabilityStatus {
  String get label {
    switch (this) {
      case AvailabilityStatus.availableNow:
        return 'Disponible maintenant';
      case AvailabilityStatus.availableFrom:
        return 'Disponible à partir du';
      case AvailabilityStatus.unavailable:
        return 'Non disponible';
    }
  }

  Color get color {
    switch (this) {
      case AvailabilityStatus.availableNow:
        return AppColors.successGreen;
      case AvailabilityStatus.availableFrom:
        return AppColors.warningOrange;
      case AvailabilityStatus.unavailable:
        return AppColors.textSecondary;
    }
  }
}

/// Badges de réputation, calculés côté serveur (cron nightly) — le mobile
/// ne fait qu'afficher la valeur reçue de l'API Spring Boot.
enum UserBadge { debutant, confirme, expert, certifie }

extension UserBadgeX on UserBadge {
  String get label {
    switch (this) {
      case UserBadge.debutant:
        return 'Débutant';
      case UserBadge.confirme:
        return 'Confirmé';
      case UserBadge.expert:
        return 'Expert';
      case UserBadge.certifie:
        return 'Certifié';
    }
  }
}

/// Modèle utilisateur minimal côté mobile — reflète les colonnes communes
/// de la table `users` (superclasse) du MCD partagées par les 6 profils.
class UserProfile {
  final String id;
  final String phone;
  final ProfileType profileType;
  final String? fullName;
  final int kycLevel;
  final int profileScore;
  final UserBadge badge;
  final AvailabilityStatus? availability;
  final double walletBalance;

  const UserProfile({
    required this.id,
    required this.phone,
    required this.profileType,
    this.fullName,
    this.kycLevel = 0,
    this.profileScore = 0,
    this.badge = UserBadge.debutant,
    this.availability,
    this.walletBalance = 0,
  });

  UserProfile copyWith({
    String? fullName,
    int? kycLevel,
    int? profileScore,
    UserBadge? badge,
    AvailabilityStatus? availability,
    double? walletBalance,
  }) {
    return UserProfile(
      id: id,
      phone: phone,
      profileType: profileType,
      fullName: fullName ?? this.fullName,
      kycLevel: kycLevel ?? this.kycLevel,
      profileScore: profileScore ?? this.profileScore,
      badge: badge ?? this.badge,
      availability: availability ?? this.availability,
      walletBalance: walletBalance ?? this.walletBalance,
    );
  }
}