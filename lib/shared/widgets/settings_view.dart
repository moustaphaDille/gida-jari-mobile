import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/routing/app_router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_theme.dart';
import '../../features/auth/providers/auth_providers.dart';
import '../../features/profile/providers/profile_provider.dart';

/// Écran Paramètres, partagé par tous les dashboards.
///
/// Il lit lui-même le profil connecté : les dashboards n'ont rien à lui
/// passer (`const SettingsView()`). Les callbacks restent optionnels pour
/// surcharger la navigation par défaut.
class SettingsView extends ConsumerWidget {
  const SettingsView({
    super.key,
    this.onViewProfile,
    this.onCompleteProfile,
    this.onChangePassword,
  });

  final VoidCallback? onViewProfile;
  final VoidCallback? onCompleteProfile;
  final VoidCallback? onChangePassword;

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Se déconnecter ?'),
        content: const Text(
          'Vous devrez vous reconnecter pour accéder à votre compte.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            child: const Text('Se déconnecter'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    // 1. Efface tokens + userId + profileType du stockage sécurisé.
    await ref.read(tokenStorageProvider).clear();

    // 2. Vide les données en mémoire (profil du compte précédent).
    ref.invalidate(currentProfileProvider);
    ref.invalidate(loginProvider);

    if (!context.mounted) return;

    // 3. Retour au login, pile de navigation vidée.
    Navigator.of(context, rootNavigator: true)
        .pushNamedAndRemoveUntil(AppRoutes.login, (_) => false);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigator = Navigator.of(context);

    final viewProfile =
        onViewProfile ?? () => navigator.pushNamed(AppRoutes.profile);
    final completeProfile = onCompleteProfile ??
        () => navigator.pushNamed(AppRoutes.completeProfile);
    final changePassword = onChangePassword ??
        () => navigator.pushNamed(AppRoutes.changePassword);

    // En chargement ou en erreur : name == null, et on affiche la ligne
    // "Mon profil" à la place de l'en-tête. Les réglages restent utilisables.
    final profile = ref.watch(currentProfileProvider).value;
    final name = profile?.nomAffiche;

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.xl,
      ),
      children: [
        if (name != null) ...[
          _ProfileHeader(
            name: name,
            subtitle: profile!.displayRole,
            onTap: viewProfile,
          ),
          const SizedBox(height: AppSpacing.md),
        ],

        _SettingsCard(
          children: [
            if (name == null)
              _SettingsTile(
                icon: Icons.person_outline_rounded,
                title: 'Mon profil',
                onTap: viewProfile,
              ),
            _SettingsTile(
              icon: Icons.assignment_ind_outlined,
              title: 'Compléter mon profil',
              onTap: completeProfile,
            ),
            _SettingsTile(
              icon: Icons.lock_outline_rounded,
              title: 'Mot de passe',
              onTap: changePassword,
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.md),

        _SettingsCard(
          children: [
            _SettingsTile(
              icon: Icons.logout_rounded,
              title: 'Se déconnecter',
              destructive: true,
              showChevron: false,
              onTap: () => _logout(context, ref),
            ),
          ],
        ),
      ],
    );
  }
}

/// Carte blanche arrondie. `Material` + `clipBehavior` : l'effet de toucher
/// (ripple) est coupé proprement aux coins arrondis.
class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      if (i > 0) {
        rows.add(const Divider(height: 1, indent: 56));
      }
      rows.add(children[i]);
    }

    return Material(
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.borderNeutral),
      ),
      child: Column(children: rows),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.name,
    required this.subtitle,
    required this.onTap,
  });

  final String name;
  final String subtitle;
  final VoidCallback onTap;

  /// "Moustapha Alassane" → "MA"
  String get _initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    final first = parts.first[0];
    final second = parts.length > 1 ? parts[1][0] : '';
    return (first + second).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return _SettingsCard(
      children: [
        ListTile(
          onTap: onTap,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          leading: CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.primaryBlue.withValues(alpha: 0.10),
            foregroundColor: AppColors.primaryBlue,
            child: Text(
              _initials,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          title: Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(subtitle),
          trailing: const Icon(Icons.chevron_right_rounded),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.destructive = false,
    this.showChevron = true,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool destructive;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = destructive ? scheme.error : null;

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      leading: Icon(icon, color: color ?? AppColors.primaryBlue),
      title: Text(title, style: TextStyle(color: color)),
      trailing: showChevron ? const Icon(Icons.chevron_right_rounded) : null,
    );
  }
}