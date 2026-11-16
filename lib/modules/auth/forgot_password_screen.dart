import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/network/api_exception.dart';
import '../../../features/auth/providers/auth_providers.dart';
import '../../../shared/widgets/gj_auth_scaffold.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  int _step = 0;
  bool _completed = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  bool get _loading =>
      ref.watch(forgotPasswordProvider).isLoading ||
      ref.watch(resetPasswordProvider).isLoading;

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _sendCode() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      _showError('Renseignez votre numéro de téléphone.');
      return;
    }

    await ref.read(forgotPasswordProvider.notifier).send(phone: phone);
    if (!mounted) return;
    final result = ref.read(forgotPasswordProvider);
    if (result.hasError) {
      _showError(errorMessage(result.error!));
      return;
    }
    setState(() => _step = 1);
  }

  void _continueWithCode() {
    if (_codeController.text.trim().isEmpty) {
      _showError('Renseignez le code reçu par email.');
      return;
    }
    setState(() => _step = 2);
  }

  Future<void> _resetPassword() async {
    final password = _passwordController.text;
    final confirmation = _confirmPasswordController.text;
    if (password.isEmpty || confirmation.isEmpty) {
      _showError('Renseignez et confirmez le nouveau mot de passe.');
      return;
    }
    if (password.length < 8) {
      _showError('Le mot de passe doit contenir au moins 8 caractères.');
      return;
    }
    if (password != confirmation) {
      _showError('Les deux mots de passe ne correspondent pas.');
      return;
    }

    await ref.read(resetPasswordProvider.notifier).reset(
          phone: _phoneController.text.trim(),
          code: _codeController.text.trim(),
          newPassword: password,
          confirmPassword: confirmation,
        );
    if (!mounted) return;

    final result = ref.read(resetPasswordProvider);
    if (result.hasError) {
      _showError(errorMessage(result.error!));
      return;
    }
    setState(() => _completed = true);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return GjAuthScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AuthIconAvatar(icon: Icons.lock_reset_rounded),
          AuthTitleBlock(
            title: _completed
                ? 'Mot de passe réinitialisé'
                : 'Changer le mot de passe',
            subtitle: _subtitle,
          ),
          if (_completed)
            const Icon(
              Icons.check_circle_outline,
              color: AppColors.successGreen,
              size: 48,
            )
          else ...[
            _buildStepIndicator(),
            const SizedBox(height: AppSpacing.lg),
            if (_step == 0) _buildPhoneStep(),
            if (_step == 1) _buildCodeStep(),
            if (_step == 2) _buildPasswordStep(),
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.successGreen,
              ),
              onPressed: _loading ? null : _submitStep,
              icon: _loading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.arrow_forward_rounded, size: 18),
              label: Text(_buttonLabel),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          Center(
            child: TextButton.icon(
              onPressed: _completed || _step == 0
                  ? () => Navigator.of(context).pop()
                  : () => setState(() => _step--),
              icon: const Icon(Icons.arrow_back_rounded, size: 16),
              label: Text(_completed ? 'Retour à la connexion' : 'Retour'),
            ),
          ),
        ],
      ),
    );
  }

  String get _subtitle {
    if (_completed) {
      return 'Votre mot de passe a été modifié. Vous pouvez vous connecter.';
    }
    if (_step == 0) {
      return 'Saisissez votre téléphone. Le code sera envoyé à votre email.';
    }
    if (_step == 1) {
      return 'Saisissez le code de vérification reçu par email.';
    }
    return 'Choisissez votre nouveau mot de passe.';
  }

  String get _buttonLabel {
    if (_step == 0) return 'Envoyer le code';
    if (_step == 1) return 'Vérifier le code';
    return 'Changer le mot de passe';
  }

  Widget _buildStepIndicator() {
    return Row(
      children: List.generate(3, (index) {
        final active = index <= _step;
        return Expanded(
          child: Container(
            height: 5,
            margin: EdgeInsets.only(right: index == 2 ? 0 : AppSpacing.sm),
            decoration: BoxDecoration(
              color: active ? AppColors.successGreen : AppColors.borderNeutral,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildPhoneStep() {
    return _field(
      label: 'Numéro de téléphone',
      controller: _phoneController,
      hint: 'Ex. : 90123456',
      icon: Icons.phone_outlined,
      keyboardType: TextInputType.phone,
    );
  }

  Widget _buildCodeStep() {
    return _field(
      label: 'Code reçu par email',
      controller: _codeController,
      hint: 'Saisissez le code',
      icon: Icons.pin_outlined,
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildPasswordStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _field(
          label: 'Nouveau mot de passe',
          controller: _passwordController,
          hint: '8 caractères minimum',
          icon: Icons.lock_outline_rounded,
          obscureText: _obscurePassword,
          suffix: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
        const SizedBox(height: AppSpacing.md),
        _field(
          label: 'Confirmer le mot de passe',
          controller: _confirmPasswordController,
          hint: 'Confirmez votre mot de passe',
          icon: Icons.lock_reset_outlined,
          obscureText: _obscureConfirmPassword,
          suffix: () => setState(
            () => _obscureConfirmPassword = !_obscureConfirmPassword,
          ),
        ),
      ],
    );
  }

  Widget _field({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    VoidCallback? suffix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label, style: AppTextStyles.caption),
        const SizedBox(height: AppSpacing.xs),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            prefixIcon: Icon(icon),
            suffixIcon: suffix == null
                ? null
                : IconButton(
                    onPressed: suffix,
                    icon: Icon(
                      obscureText
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  ),
            hintText: hint,
          ),
        ),
      ],
    );
  }

  void _submitStep() {
    if (_step == 0) {
      _sendCode();
    } else if (_step == 1) {
      _continueWithCode();
    } else {
      _resetPassword();
    }
  }
}
