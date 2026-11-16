import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_theme.dart';
import '../../core/network/api_exception.dart';
import '../../features/auth/providers/auth_providers.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState
    extends ConsumerState<ChangePasswordScreen> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    final oldPassword = _oldPasswordController.text;
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      _showMessage('Complétez tous les champs.');
      return;
    }
    if (newPassword.length < 8) {
      _showMessage('Le nouveau mot de passe doit contenir 8 caractères minimum.');
      return;
    }

    await ref.read(changePasswordProvider.notifier).change(
          oldPassword: oldPassword,
          newPassword: newPassword,
          confirmPassword: confirmPassword,
        );
    if (!mounted) return;

    final result = ref.read(changePasswordProvider);
    if (result.hasError) {
      _showMessage(errorMessage(result.error!));
      return;
    }
    if (result.value == true) {
      _showMessage('Mot de passe modifié avec succès.');
      Navigator.of(context).pop();
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final loading = ref.watch(changePasswordProvider).isLoading;
    return Scaffold(
      appBar: AppBar(title: const Text('Changer le mot de passe')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Text(
            'Sécurisez votre compte',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Saisissez votre ancien mot de passe puis choisissez le nouveau.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.lg),
          _passwordField(
            controller: _oldPasswordController,
            label: 'Ancien mot de passe',
          ),
          const SizedBox(height: AppSpacing.md),
          _passwordField(
            controller: _newPasswordController,
            label: 'Nouveau mot de passe',
          ),
          const SizedBox(height: AppSpacing.md),
          _passwordField(
            controller: _confirmPasswordController,
            label: 'Confirmer le nouveau mot de passe',
          ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton.icon(
            onPressed: loading ? null : _submit,
            icon: loading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.lock_reset_outlined),
            label: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }

  Widget _passwordField({
    required TextEditingController controller,
    required String label,
  }) {
    return TextField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock_outline_rounded),
      ),
    );
  }
}
