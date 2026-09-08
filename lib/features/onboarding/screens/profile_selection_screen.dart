import 'package:flutter/material.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/models/user_profile.dart';
import '../../../shared/widgets/gj_auth_scaffold.dart';

/// Étape 2 — Sélection du profil précis au sein de la catégorie choisie.
/// Maximum 4 profils visibles sans scroll sur mobile (règle UX).
class ProfileSelectionScreen extends StatelessWidget {
  final OnboardingCategory category;

  const ProfileSelectionScreen({super.key, required this.category});

  List<ProfileType> get _profiles {
    switch (category) {
      case OnboardingCategory.seekProfessional:
        return [ProfileType.client];
      case OnboardingCategory.independentProfessional:
        return [ProfileType.artisan, ProfileType.architecteIngenieur];
    }
  }

  @override
  Widget build(BuildContext context) {
    return GjAuthScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AuthTitleBlock(
            title: 'Précisez votre profil',
            subtitle: 'Ex : "Je suis maçon indépendant" ou '
                '"Je fais des levés topographiques"',
          ),
          ..._profiles.map((profile) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: _ProfileCard(
                  profileType: profile,
                  onTap: () => Navigator.of(context).pushNamed(
                    AppRoutes.phoneNumber,
                    arguments: profile,
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final ProfileType profileType;
  final VoidCallback onTap;

  const _ProfileCard({required this.profileType, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = profileType.color;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.borderNeutral),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: color.withValues(alpha: 0.12),
              child: Icon(profileType.icon, color: color),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(profileType.label, style: AppTextStyles.labelStrong),
                  const SizedBox(height: 2),
                  Text(profileType.pitch, style: AppTextStyles.caption),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: color),
          ],
        ),
      ),
    );
  }
}
