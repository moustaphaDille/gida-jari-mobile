import 'package:flutter/material.dart';
import 'package:gida_jari_mobile/core/theme/app_colors.dart';
import '../../core/routing/app_router.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/models/user_profile.dart';

const _professionsArtisan = [
  'Maçon',
  'Plombier',
  'Électricien',
  'Carreleur',
  'Peintre',
  'Menuisier',
  'Charpentier',
  'Soudeur',
];

const _professionsArchitecte = [
  'Architecte',
  'Ingénieur génie civil',
  'Ingénieur MEP',
  'Ingénieur VRD',
];

class RegistrationScreen extends StatefulWidget {
  final String phone;
  final ProfileType profileType;

  const RegistrationScreen({
    super.key,
    required this.phone,
    required this.profileType,
  });

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _professionController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmationController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmation = true;
  bool _acceptedTerms = false;
  String? _profession;

  bool get _isIndependentWorker => widget.profileType != ProfileType.client;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _addressController.dispose();
    _professionController.dispose();
    _passwordController.dispose();
    _confirmationController.dispose();
    super.dispose();
  }

  String? _required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ce champ est obligatoire';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Ce champ est obligatoire';
    if (value.length < 6) return '6 caractères minimum';
    return null;
  }

  String? _validateConfirmation(String? value) {
    if (value == null || value.isEmpty) return 'Ce champ est obligatoire';
    if (value != _passwordController.text) {
      return 'Les mots de passe ne correspondent pas';
    }
    return null;
  }

  void _createAccount() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (!_acceptedTerms) {
      setState(() {});
      return;
    }

    final dashboard = switch (_profession) {
      _ => AppRoutes.partnerDashboard,
    };

    final clientDashboard = switch (widget.profileType) {
      ProfileType.client => AppRoutes.clientDashboard,
      _ => dashboard,
    };
    Navigator.of(context).pushReplacementNamed(clientDashboard);
  }

  @override
  Widget build(BuildContext context) {
    const accentColor = AppColors.clientColor;

    return Scaffold(
      appBar: AppBar(title: const Text('Créer mon compte')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    border:
                        Border.all(color: accentColor.withValues(alpha: 0.18)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: accentColor,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                        child: const Icon(Icons.person_add_alt_1_rounded,
                            color: Colors.white),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Bienvenue sur Gida Jari',
                                style: AppTextStyles.labelStrong),
                            SizedBox(height: 4),
                            Text(
                                'Quelques informations pour finaliser votre compte',
                                style: AppTextStyles.caption),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                const Text('Vos informations', style: AppTextStyles.h2),
                const SizedBox(height: AppSpacing.sm),
                const Text('Ces informations servent à créer votre compte.',
                    style: AppTextStyles.caption),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  initialValue: widget.phone,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Numéro de téléphone',
                    prefixIcon: Icon(Icons.phone_outlined),
                    suffixIcon: Padding(
                      padding: EdgeInsets.only(right: AppSpacing.sm),
                      child: _VerifiedBadge(color: accentColor),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _firstNameController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(labelText: 'Prénom'),
                  validator: _required,
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _lastNameController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(labelText: 'Nom'),
                  validator: _required,
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _addressController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(labelText: 'Adresse'),
                  validator: _required,
                ),
                if (_isIndependentWorker) ...[
                  const SizedBox(height: AppSpacing.md),
                  DropdownButtonFormField<String>(
                    initialValue: _profession,
                    decoration: const InputDecoration(
                      labelText: 'Profession',
                      prefixIcon: Icon(Icons.work_outline_rounded),
                    ),
                    items: [
                      ..._professionsArtisan,
                      ..._professionsArchitecte,
                    ].map((profession) {
                      return DropdownMenuItem(
                        value: profession,
                        child: Text(profession),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => _profession = value),
                    validator: (value) => value == null
                        ? 'Sélectionnez votre profession'
                        : null,
                  ),
                ],
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Mot de passe',
                    suffixIcon: IconButton(
                      tooltip: 'Afficher ou masquer le mot de passe',
                      icon: Icon(_obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  validator: _validatePassword,
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _confirmationController,
                  obscureText: _obscureConfirmation,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    labelText: 'Confirmer le mot de passe',
                    suffixIcon: IconButton(
                      tooltip: 'Afficher ou masquer le mot de passe',
                      icon: Icon(_obscureConfirmation
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined),
                      onPressed: () => setState(
                          () => _obscureConfirmation = !_obscureConfirmation),
                    ),
                  ),
                  validator: _validateConfirmation,
                  onFieldSubmitted: (_) => _createAccount(),
                ),
                const SizedBox(height: AppSpacing.md),
                CheckboxListTile(
                  value: _acceptedTerms,
                  onChanged: (value) =>
                      setState(() => _acceptedTerms = value ?? false),
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: accentColor,
                  title: const Text(
                      'J’accepte la politique de confidentialité et les conditions d’utilisation.',
                      style: AppTextStyles.caption),
                  subtitle: !_acceptedTerms
                      ? const Text('Votre accord est obligatoire',
                          style: TextStyle(color: AppColors.errorRed))
                      : null,
                ),
                const SizedBox(height: AppSpacing.md),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    minimumSize: const Size.fromHeight(52),
                  ),
                  onPressed: _createAccount,
                  icon: const Icon(Icons.check_rounded),
                  label: const Text('Créer mon compte'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _VerifiedBadge extends StatelessWidget {
  final Color color;

  const _VerifiedBadge({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified_rounded, size: 15, color: color),
          const SizedBox(width: 4),
          Text('Vérifié', style: TextStyle(color: color, fontSize: 12)),
        ],
      ),
    );
  }
}
