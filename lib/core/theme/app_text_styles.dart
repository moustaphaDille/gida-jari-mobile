import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Hiérarchie typographique Gida Jari — Arial (fallback Roboto sur Android).
/// Règle non-négociable : jamais de corps de texte en dessous de 14sp,
/// 16sp minimum pour le contenu principal (contexte terrain africain).
class AppTextStyles {
  AppTextStyles._();

  static const String fontFamily = 'Roboto'; // fallback système = Arial-like

  static const TextStyle h1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryBlue,
    height: 1.3,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryBlue,
    height: 1.4,
  );

  static const TextStyle h3 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.successGreen,
    height: 1.4,
  );

  static const TextStyle labelStrong = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.6,
  );

  static const TextStyle bodyRegular = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.6,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  /// Montant FCFA — toujours en vert, poids fort (priorité visuelle max).
  static const TextStyle amount = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.successGreen,
  );

  /// Référence GJ-xxxxx — police mono, fond distinctif.
  static const TextStyle reference = TextStyle(
    fontFamily: 'monospace',
    fontSize: 14,
    color: AppColors.textPrimary,
  );

  static const TextStyle button = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.5,
  );
}
