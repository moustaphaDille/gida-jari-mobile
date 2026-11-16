import 'package:flutter/material.dart';

/// Palette officielle Gida Jari — issue de la Charte Graphique et du
/// Design System V3. Ne jamais utiliser de couleurs hors de cette palette.
class AppColors {
  AppColors._();

  // Couleurs de marque
  static const Color primaryBlue = Color(0xFF1A3C6E); // Confiance, navigation
  static const Color primaryBlueHover = Color(0xFF2A5298);
  static const Color primaryBlueActive = Color(0xFF0D2B54);
  static const Color primaryBlueDisabled = Color(0xFF8BA8C8);

  static const Color successGreen = Color(0xFF2E7D32); // Validation, paiements
  static const Color successGreenHover = Color(0xFF388E3C);

  static const Color goldAccent = Color(0xFFC8922A); // Premium / Pro
  static const Color warningOrange = Color(0xFFE65100); // Urgence, Artisan
  static const Color errorRed = Color(0xFFB71C1C); // Erreurs, litiges
  static const Color technicalPurple = Color(0xFF6A1B9A); // Architecte / BET
  static const Color precisionTeal = Color(0xFF00695C); // Topographe

  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF616161);
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFF5F5F5);
  static const Color borderNeutral = Color(0xFFE0E0E0);

  // Fonds clairs associés
  static const Color primaryBlueBg = Color(0xFFE3F2FD);
  static const Color successGreenBg = Color(0xFFE8F5E9);
  static const Color warningOrangeBg = Color(0xFFFFF3E0);
  static const Color errorRedBg = Color(0xFFFFEBEE);
  static const Color technicalPurpleBg = Color(0xFFF3E5F5);
  static const Color goldAccentBg = Color(0xFFFFF8E1);

  // Opérateurs Mobile Money Niger
  static const Color operatorAmana = Color(0xFF2E7D32);
  static const Color operatorNita = Color(0xFF0047AB);
  static const Color operatorAirtel = Color(0xFFB71C1C);
  static const Color operatorZamani = Color(0xFF6A1B9A);
  static const Color operatorMoov = Color(0xFF1565C0);

  /// Couleur d'identité par profil (utilisée pour l'en-tête, les badges,
  /// les CTA de la catégorie "Je suis un professionnel BTP").
  static const Color clientColor = primaryBlue;
  static const Color artisanColor = warningOrange;
  static const Color architecteColor = technicalPurple;
}
