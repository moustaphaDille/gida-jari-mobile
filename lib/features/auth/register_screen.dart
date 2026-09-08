import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/models/user_profile.dart';
import '../../../shared/widgets/gj_auth_scaffold.dart';

enum _AccountKind { client, partenaire }

/// Écran d'inscription — première étape : Client ou Partenaire.
/// La profession du partenaire est choisie dans le formulaire d'inscription.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  _AccountKind? _selected;

  void _continue() {
    if (_selected == _AccountKind.client) {
      Navigator.of(context).pushNamed(
        AppRoutes.phoneNumber,
        arguments: ProfileType.client,
      );
    } else if (_selected == _AccountKind.partenaire) {
      Navigator.of(context).pushNamed(
        AppRoutes.phoneNumber,
        arguments: ProfileType.artisan,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GjAuthScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
           Center(
            child: Container(
              width: 84,
              height: 84,
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.primaryBlueBg,
                borderRadius: BorderRadius.circular(24),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.asset(
                  'assets/gida-jari.jpeg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const AuthTitleBlock(
            title: 'Choisissez votre profil',
            subtitle: 'La profession partenaire sera choisie à l’étape suivante.',
          ),
          _AccountKindCard(
            title: 'Client',
            subtitle: 'Je souhaite construire, rénover ou gérer mon projet immobilier.',
            icon: Icons.home_rounded,
            color: AppColors.clientColor,
            selected: _selected == _AccountKind.client,
            onTap: () => setState(() => _selected = _AccountKind.client),
          ),
          const SizedBox(height: AppSpacing.md),
          _AccountKindCard(
            title: 'Partenaire',
            subtitle: 'Je suis un artisan, ingénieur ou une entreprise du BTP.',
            icon: Icons.architecture_rounded,
            color: AppColors.technicalPurple,
            selected: _selected == _AccountKind.partenaire,
            onTap: () => setState(() => _selected = _AccountKind.partenaire),
          ),
          const SizedBox(height: AppSpacing.lg),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.successGreen),
            onPressed: _selected != null ? _continue : null,
            icon: const Icon(Icons.arrow_forward_rounded, size: 18),
            label: const Text('Continuer'),
          ),
          const SizedBox(height: AppSpacing.md),
          Center(
            child: RichText(
              text: TextSpan(
                style: AppTextStyles.bodyRegular,
                children: [
                  const TextSpan(text: 'Vous avez déjà un compte ? '),
                  TextSpan(
                    text: 'Connexion',
                    style: const TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => Navigator.of(context).pushReplacementNamed(AppRoutes.login),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountKindCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const _AccountKindCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.06) : Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: selected ? color : AppColors.borderNeutral, width: selected ? 2 : 1),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(AppRadius.md)),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.labelStrong.copyWith(color: color)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppTextStyles.caption),
                ],
              ),
            ),
            Radio<bool>(
              value: true,
              groupValue: selected,
              activeColor: color,
              onChanged: (_) => onTap(),
            ),
          ],
        ),
      ),
    );
  }
}
