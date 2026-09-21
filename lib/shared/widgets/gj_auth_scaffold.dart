import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_theme.dart';

/// Habillage commun des écrans d'authentification (Connexion, Inscription,
/// OTP, Mot de passe oublié) : fond clair + carte blanche centrée avec
/// ombre douce, en-tête de marque, icône d'illustration optionnelle.
class GjAuthScaffold extends StatelessWidget {
  final Widget child;
  final bool showBrandHeader;
  final PreferredSizeWidget? appBar;

  const GjAuthScaffold({
    super.key,
    required this.child,
    this.showBrandHeader = true,
    this.appBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: AppColors.surfaceLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.lg,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (showBrandHeader) ...[
                    const _BrandHeader(),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: child,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BrandHeader extends StatelessWidget {
  const _BrandHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.primaryBlue,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.construction_rounded, color: Colors.white, size: 18),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text('Gida Jari', style: AppTextStyles.h3.copyWith(color: AppColors.primaryBlue)),
      ],
    );
  }
}

/// Icône d'illustration ronde en tête de carte (loupe, cadenas, refresh...).
class AuthIconAvatar extends StatelessWidget {
  final IconData icon;
  final Color background;
  final Color iconColor;

  const AuthIconAvatar({
    super.key,
    required this.icon,
    this.background = AppColors.primaryBlueBg,
    this.iconColor = AppColors.primaryBlue,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(18)),
        child: Icon(icon, color: iconColor, size: 30),
      ),
    );
  }
}

/// Titre + sous-titre centrés, communs à tous les écrans d'auth.
class AuthTitleBlock extends StatelessWidget {
  final String title;
  final String subtitle;

  const AuthTitleBlock({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: AppSpacing.md),
        Text(title, textAlign: TextAlign.center, style: AppTextStyles.h2),
        const SizedBox(height: 6),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyRegular.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}
