import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/gj_auth_scaffold.dart';

/// Écran de connexion — pour les utilisateurs déjà inscrits. La création
/// de compte reste pilotée par OTP SMS (cf. RegisterScreen) ; cet écran
/// sert au retour d'un utilisateur ayant déjà défini un mot de passe
/// (portail professionnel / API Spring Security).
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  Future<void> _submit() async {
    setState(() => _isLoading = true);
   
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() => _isLoading = false);
 
  }

  @override
  Widget build(BuildContext context) {
    return GjAuthScaffold(
      showBrandHeader: false,
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
          const SizedBox(height: AppSpacing.lg),
          const Text(
            'Bon retour parmi nous',
            textAlign: TextAlign.center,
            style: AppTextStyles.h2,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Connectez-vous pour suivre vos projets et retrouver votre espace professionnel.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyRegular
                .copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.xl),
          const Text('Email ou Numéro de téléphone',
              style: AppTextStyles.caption),
          const SizedBox(height: 6),
          TextField(
            controller: _identifierController,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.person_outline),
              hintText: 'nom@entreprise.com ou +227...',
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Mot de passe', style: AppTextStyles.caption),
              GestureDetector(
                onTap: () =>
                    Navigator.of(context).pushNamed(AppRoutes.forgotPassword),
                child: Text(
                  'Mot de passe oublié ?',
                  style: AppTextStyles.caption
                      .copyWith(color: AppColors.primaryBlue),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(_obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
              hintText: 'Entrez votre mot de passe',
            ),
          ),     
          const SizedBox(height: AppSpacing.md),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              elevation: 0,
            ),
            onPressed: _isLoading ? null : _submit,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                : const Text('Se connecter'),
          ),
          const SizedBox(height: AppSpacing.md),
          Center(
            child: RichText(
              text: TextSpan(
                style: AppTextStyles.bodyRegular,
                children: [
                  const TextSpan(text: 'Nouveau sur Gida Jari ? '),
                  TextSpan(
                    text: 'Créer un compte',
                    style: const TextStyle(
                        color: AppColors.successGreen,
                        fontWeight: FontWeight.bold),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () =>
                          Navigator.of(context).pushNamed(AppRoutes.register),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextButton(
            onPressed: () {},
            child: const Text('Politique de confidentialité et conditions'),
          ),
        ],
      ),
    );
  }
}
