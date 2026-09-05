import 'package:flutter/material.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_theme.dart';

/// Étape 1 — Sélection de la grande catégorie, cf. Design System V3
/// Section 2.1. Seules les 2 catégories du périmètre (Client / Professionnel
/// indépendant) sont actives ; les autres sont grisées "Bientôt disponible".
class CategorySelectionScreen extends StatelessWidget {
  const CategorySelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bienvenue sur Gida Jari')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Que voulez-vous faire ?', style: AppTextStyles.h1),
            const SizedBox(height: AppSpacing.sm),
            const Text(
              'Choisissez votre situation pour continuer.',
              style: AppTextStyles.bodyRegular,
            ),
            const SizedBox(height: AppSpacing.lg),
            _CategoryCard(
              icon: Icons.home_rounded,
              title: 'Je cherche un professionnel',
              subtitle: 'Je veux construire, rénover ou financer un chantier',
              bgColor: AppColors.primaryBlueBg,
              accentColor: AppColors.primaryBlue,
              onTap: () => Navigator.of(context).pushNamed(
                AppRoutes.profileSelection,
                arguments: OnboardingCategory.seekProfessional,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            _CategoryCard(
              icon: Icons.engineering_rounded,
              title: 'Je suis un professionnel BTP',
              subtitle: 'Je propose mes services, je gère des projets ou je supervise',
              bgColor: AppColors.warningOrangeBg,
              accentColor: AppColors.warningOrange,
              onTap: () => Navigator.of(context).pushNamed(
                AppRoutes.profileSelection,
                arguments: OnboardingCategory.independentProfessional,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            _CategoryCard(
              icon: Icons.storefront_rounded,
              title: 'Je fournis biens ou services',
              subtitle: 'Matériaux, équipements, assurance, transport',
              bgColor: AppColors.surfaceLight,
              accentColor: AppColors.textSecondary,
              enabled: false,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color bgColor;
  final Color accentColor;
  final VoidCallback onTap;
  final bool enabled;

  const _CategoryCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.bgColor,
    required this.accentColor,
    required this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(icon, color: accentColor, size: 28),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.labelStrong),
                    const SizedBox(height: 4),
                    Text(subtitle, style: AppTextStyles.bodyRegular),
                    if (!enabled) ...[
                      const SizedBox(height: 4),
                      const Text('Bientôt disponible', style: AppTextStyles.caption),
                    ],
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: accentColor),
            ],
          ),
        ),
      ),
    );
  }
}
