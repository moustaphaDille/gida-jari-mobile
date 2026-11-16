import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gida_jari_mobile/app/routing/app_router.dart';
import 'package:gida_jari_mobile/app/theme/app_colors.dart';
import 'package:gida_jari_mobile/app/theme/app_text_styles.dart';
import 'package:gida_jari_mobile/app/theme/app_theme.dart';
import 'package:gida_jari_mobile/features/auth/providers/auth_providers.dart';
import 'package:gida_jari_mobile/shared/models/user_profile.dart';
import 'package:gida_jari_mobile/shared/widgets/gj_auth_scaffold.dart';

/// Un choix de profil : le type + les textes affichés dans la carte.
class _ProfileOption {
  final ProfileType type;
  final String title;
  final String subtitle;

  const _ProfileOption({
    required this.type,
    required this.title,
    required this.subtitle,
  });
}

const _options = [
  _ProfileOption(
    type: ProfileType.client,
    title: 'Client / Maître d’ouvrage',
    subtitle: 'Je fais construire ou rénover',
  ),
  _ProfileOption(
    type: ProfileType.artisan,
    title: 'Artisan',
    subtitle: 'J’exerce un métier du bâtiment',
  ),
  _ProfileOption(
    type: ProfileType.entrepriseBtp,
    title: 'Entreprise BTP',
    subtitle: 'Je dirige une entreprise de travaux',
  ),
  _ProfileOption(
    type: ProfileType.architecteIngenieur,
    title: 'Ingénieur / Architecte',
    subtitle: 'Je conçois et je suis des ouvrages',
  ),
  _ProfileOption(
    type: ProfileType.fournisseurMateriaux,
    title: 'Fournisseur de matériaux',
    subtitle: 'Je vends des matériaux',
  ),
  _ProfileOption(
    type: ProfileType.ongInstitution,
    title: 'ONG / Institution',
    subtitle: 'Je conduis des programmes',
  ),
];

/// Première étape de l'inscription : choix du profil (6 choix, une seule étape).
/// Le profil choisi est mémorisé dans selectedProfileTypeProvider
/// (lu ensuite par verify-otp et register) et envoyé à l'écran suivant.
class ProfileSelectionScreen extends ConsumerStatefulWidget {
  const ProfileSelectionScreen({super.key});

  @override
  ConsumerState<ProfileSelectionScreen> createState() =>
      _ProfileSelectionScreenState();
}

class _ProfileSelectionScreenState
    extends ConsumerState<ProfileSelectionScreen> {
  ProfileType _selected = ProfileType.client;

  void _continue() {
    ref.read(selectedProfileTypeProvider.notifier).select(_selected);

    Navigator.of(context).pushNamed(
      AppRoutes.contactVerification,
      arguments: _selected,
    );
  }

  @override
  Widget build(BuildContext context) {
    // GjAuthScaffold affiche déjà le header "Gida Jari" avec le logo.
    return GjAuthScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AuthTitleBlock(
            title: 'Choisissez votre profil',
            subtitle: 'Vous pourrez le compléter ensuite.',
          ),
          ..._options.map(
            (option) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: _ProfileCard(
                title: option.title,
                subtitle: option.subtitle,
                icon: option.type.icon,
                color: option.type.color,
                selected: _selected == option.type,
                onTap: () => setState(() => _selected = option.type),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.successGreen,
            ),
            onPressed: _continue,
            icon: const Icon(Icons.arrow_forward_rounded, size: 18),
            label: const Text('Continuer'),
          ),
        ],
      ),
    );
  }
}

/// Carte de choix : icône, titre, sous-titre, radio à droite.
class _ProfileCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const _ProfileCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm + 2,
        ),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.06) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? color : AppColors.borderNeutral,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.labelStrong.copyWith(
                      color: Colors.grey.shade900,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            _RadioDot(selected: selected, color: color),
          ],
        ),
      ),
    );
  }
}

/// Radio dessiné à la main : la carte entière est déjà cliquable,
/// donc pas besoin du widget Radio.
class _RadioDot extends StatelessWidget {
  final bool selected;
  final Color color;

  const _RadioDot({required this.selected, required this.color});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? color : Colors.grey.shade600,
          width: 2,
        ),
      ),
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          width: selected ? 12 : 0,
          height: selected ? 12 : 0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
      ),
    );
  }
}
