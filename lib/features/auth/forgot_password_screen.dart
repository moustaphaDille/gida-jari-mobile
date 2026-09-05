import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/gj_auth_scaffold.dart';

/// Écran de récupération de mot de passe (portail professionnel).
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _identifierController = TextEditingController();
  bool _isSending = false;
  bool _sent = false;

  Future<void> _submit() async {
    setState(() => _isSending = true);
   
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() {
      _isSending = false;
      _sent = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GjAuthScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AuthIconAvatar(icon: Icons.lock_reset_rounded),
          AuthTitleBlock(
            title: 'Mot de passe oublié',
            subtitle: _sent
                ? 'Un lien de réinitialisation a été envoyé. Vérifiez vos SMS ou votre email.'
                : 'Entrez vos coordonnées pour recevoir un lien de réinitialisation.',
          ),
          if (!_sent) ...[
            const Text('Email ou Numéro de téléphone', style: AppTextStyles.caption),
            const SizedBox(height: 6),
            TextField(
              controller: _identifierController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.mail_outline),
                hintText: 'nom@entreprise.com ou +227...',
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.successGreen),
              onPressed: _isSending ? null : _submit,
              icon: _isSending
                  ? const SizedBox(
                      width: 18, height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.arrow_forward_rounded, size: 18),
              label: const Text('Envoyer'),
            ),
          ] else ...[
            Icon(Icons.check_circle_outline, color: AppColors.successGreen, size: 48),
            const SizedBox(height: AppSpacing.md),
          ],
          const SizedBox(height: AppSpacing.lg),
          Center(
            child: TextButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back_rounded, size: 16),
              label: const Text('Retour à la connexion'),
            ),
          ),
        ],
      ),
    );
  }
}
