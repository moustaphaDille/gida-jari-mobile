import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_theme.dart';
import '../../features/profile/models/user_profile_data.dart';
import '../models/user_profile.dart';

class ProfileDetailsView extends StatelessWidget {
  const ProfileDetailsView({
    super.key,
    required this.profile,
    required this.onComplete,
  });

  final UserProfileData profile;
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = profile.profileType?.color ?? AppColors.primaryBlue;
    final displayName = profile.nomAffiche ?? 'Mon profil';
    final initials = displayName
        .split(' ')
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part[0].toUpperCase())
        .join();
    final completion = profile.profileScore <= 1
        ? profile.profileScore * 100
        : profile.profileScore;

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.xl,
      ),
      children: [
        Text('Mon profil', style: theme.textTheme.headlineSmall),
        const SizedBox(height: AppSpacing.lg),
        _ProfileHeader(
          name: displayName,
          initials: initials.isEmpty ? '?' : initials,
          role: profile.displayRole,
          accent: accent,
        ),
        const SizedBox(height: AppSpacing.md),
        _CompletionCard(
          completion: completion,
          accent: accent,
          onComplete: onComplete,
        ),
        const SizedBox(height: AppSpacing.lg),
        _SectionCard(
          title: 'Informations personnelles',
          icon: Icons.person_outline_rounded,
          children: [
            _InfoTile(
              icon: Icons.badge_outlined,
              label: 'Nom complet',
              value: profile.nomAffiche,
            ),
            _InfoTile(
              icon: Icons.phone_outlined,
              label: 'Téléphone',
              value: _value('phone'),
            ),
            _InfoTile(
              icon: Icons.email_outlined,
              label: 'Email',
              value: _value('email'),
            ),
            _InfoTile(
              icon: Icons.location_on_outlined,
              label: 'Adresse',
              value: _value('adresse'),
            ),
          ],
        ),
        if (_roleFields.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          _SectionCard(
            title: 'Informations professionnelles',
            icon: Icons.work_outline_rounded,
            children: [
              for (final field in _roleFields)
                _InfoTile(
                  icon: field.$1,
                  label: field.$2,
                  value: _value(field.$3),
                ),
            ],
          ),
        ],
        const SizedBox(height: AppSpacing.md),
        _SectionCard(
          title: 'Vérification du compte',
          icon: Icons.verified_user_outlined,
          children: [
            _InfoTile(
              icon: Icons.security_outlined,
              label: 'Niveau de vérification',
              value: _value('kycLevel'),
            ),
            _InfoTile(
              icon: Icons.check_circle_outline_rounded,
              label: 'Téléphone vérifié',
              value: _booleanValue('phoneVerifie'),
            ),
          ],
        ),
      ],
    );
  }

  String? _value(String key) {
    final value = profile.values[key];
    if (value == null || value.toString().trim().isEmpty) return null;
    return value.toString();
  }

  String? _booleanValue(String key) {
    final value = profile.values[key];
    if (value is! bool) return _value(key);
    return value ? 'Oui' : 'Non';
  }

  List<(IconData, String, String)> get _roleFields {
    return switch (profile.profileType) {
      ProfileType.client => [
          (Icons.account_circle_outlined, 'Type de client', 'typeClient'),
        ],
      ProfileType.artisan => [
          (Icons.handyman_outlined, 'Métier', 'corpsDeMetier'),
          (Icons.map_outlined, 'Zone d’intervention', 'zoneIntervention'),
          (Icons.payments_outlined, 'Tarif journalier', 'tarifJournalierFcfa'),
          (Icons.event_available_outlined, 'Disponibilité', 'disponibilite'),
        ],
      ProfileType.architecteIngenieur => [
          (Icons.architecture_outlined, 'Spécialité', 'specialite'),
          (Icons.workspace_premium_outlined, 'Numéro d’ordre', 'numeroOrdre'),
          (
            Icons.verified_outlined,
            'Agrément ministériel',
            'agrementMinisteriel'
          ),
        ],
      ProfileType.entrepriseBtp => [
          (Icons.business_outlined, 'Nom commercial', 'nomCommercial'),
          (Icons.description_outlined, 'NIF', 'nif'),
          (Icons.receipt_long_outlined, 'RCCM', 'rccm'),
          (Icons.domain_outlined, 'Domaine d’activité', 'domaineActivite'),
          (Icons.groups_outlined, 'Effectif', 'effectif'),
        ],
      ProfileType.fournisseurMateriaux => [
          (Icons.storefront_outlined, 'Nom de la boutique', 'nomBoutique'),
          (Icons.description_outlined, 'NIF', 'nif'),
          (Icons.category_outlined, 'Catégories', 'categories'),
          (
            Icons.local_shipping_outlined,
            'Zones de livraison',
            'zonesLivraison'
          ),
        ],
      ProfileType.ongInstitution => [
          (Icons.account_balance_outlined, 'Raison sociale', 'raisonSociale'),
          (Icons.description_outlined, 'NIF / RCCM', 'nifOuRccm'),
          (Icons.category_outlined, 'Type d’organisation', 'typeOrganisation'),
          (Icons.gavel_outlined, 'Statut légal', 'statutLegal'),
          (Icons.public_outlined, 'ODD cible', 'oddCible'),
        ],
      null => <(IconData, String, String)>[],
    }
        .where((field) => _value(field.$3) != null)
        .toList();
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.name,
    required this.initials,
    required this.role,
    required this.accent,
  });

  final String name;
  final String initials;
  final String role;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: accent.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            CircleAvatar(
              radius: 34,
              backgroundColor: accent,
              child: Text(
                initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    role,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: accent,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CompletionCard extends StatelessWidget {
  const _CompletionCard({
    required this.completion,
    required this.accent,
    required this.onComplete,
  });

  final double completion;
  final Color accent;
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    final value = (completion / 100).clamp(0.0, 1.0);
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Profil complété',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                Text('${completion.round()}%'),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            LinearProgressIndicator(
              value: value,
              minHeight: 8,
              borderRadius: BorderRadius.circular(8),
              color: accent,
              backgroundColor: accent.withValues(alpha: 0.12),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              completion >= 100
                  ? 'Votre profil est complet.'
                  : 'Ajoutez vos informations pour inspirer confiance.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: AppSpacing.sm),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: onComplete,
                icon: const Icon(Icons.edit_outlined, size: 18),
                label: const Text('Compléter'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  final String title;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.sm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: AppColors.primaryBlue),
                const SizedBox(width: AppSpacing.sm),
                Text(title, style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            const Divider(height: AppSpacing.lg),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    if (value == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.textSecondary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  value!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
