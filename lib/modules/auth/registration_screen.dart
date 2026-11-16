import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/api_exception.dart';
import '../../features/auth/providers/auth_providers.dart';
import '../../app/routing/app_router.dart';
import '../../app/theme/app_text_styles.dart';
import '../../app/theme/app_theme.dart';
import '../../shared/models/user_profile.dart';

const _professions = [
  'Maçon',
  'Plombier',
  'Électricien',
  'Carreleur',
  'Peintre',
  'Menuisier',
  'Charpentier',
  'Soudeur',
  'Architecte',
  'Ingénieur génie civil',
  'Ingénieur MEP',
  'Ingénieur VRD',
];

class RegistrationScreen extends ConsumerStatefulWidget {
  final String phone;
  final ProfileType profileType;

  const RegistrationScreen({
    super.key,
    required this.phone,
    required this.profileType,
  });

  @override
  ConsumerState<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends ConsumerState<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  // Professionnel indépendant
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  // Entreprise
  final _companyNameController = TextEditingController();
  final _addressController = TextEditingController();

  // Sécurité
  final _passwordController = TextEditingController();
  final _confirmationController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmation = true;
  bool _acceptedTerms = false;

  String? _profession;

  bool get _isEntreprise => widget.profileType == ProfileType.entrepriseBtp;

  Color get _accentColor => widget.profileType.color;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final verified = ref.read(verifyOtpProvider).value;
      final selectedType = ref.read(selectedProfileTypeProvider);
      if (verified == null ||
          verified.temporaryToken.trim().isEmpty ||
          selectedType != widget.profileType) {
        _showSnack('Vérifiez votre numéro avant de créer votre compte.');
        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRoutes.register,
          (_) => false,
        );
      }
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _companyNameController.dispose();
    _addressController.dispose();
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
    if (value == null || value.isEmpty) {
      return 'Mot de passe obligatoire';
    }

    if (value.length < 8) {
      return '8 caractères minimum';
    }

    return null;
  }

  String? _validateConfirmation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirmez votre mot de passe';
    }

    if (value != _passwordController.text) {
      return 'Les mots de passe ne correspondent pas';
    }

    return null;
  }

  Future<void> _createAccount() async {
    FocusScope.of(context).unfocus();

    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    if (!_acceptedTerms) {
      _showTermsMessage();
      return;
    }

    await ref.read(registerProvider.notifier).register(
          nom: _isEntreprise
              ? _companyNameController.text.trim()
              : _lastNameController.text.trim(),
          prenom:
              _isEntreprise ? 'Responsable' : _firstNameController.text.trim(),
          adresse: _addressController.text.trim(),
          password: _passwordController.text,
          confirmPassword: _confirmationController.text,
        );

    if (!mounted) return;

    final result = ref.read(registerProvider);
    if (result.hasError) {
      _showSnack(errorMessage(result.error!));
      return;
    }

    final route = switch (widget.profileType) {
      ProfileType.client => AppRoutes.clientDashboard,
      ProfileType.artisan ||
      ProfileType.architecteIngenieur =>
        AppRoutes.professionalDashboard,
      ProfileType.entrepriseBtp => AppRoutes.entrepriseDashboard,
      _ => AppRoutes.partnerDashboard,
    };
    Navigator.of(context).pushNamedAndRemoveUntil(route, (_) => false);
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _showTermsMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Veuillez accepter les conditions d’utilisation.',
        ),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(AppSpacing.md),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Créer mon compte',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    AppSpacing.sm,
                    AppSpacing.md,
                    AppSpacing.md,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // _buildProgressHeader(),

                      const SizedBox(height: AppSpacing.lg),

                      _buildProfileCard(),

                      const SizedBox(height: AppSpacing.lg),

                      _buildFormFields(),

                      const SizedBox(height: AppSpacing.lg),

                      _buildSecuritySection(),

                      const SizedBox(height: AppSpacing.md),

                      _buildTerms(),

                      const SizedBox(height: AppSpacing.md),
                    ],
                  ),
                ),
              ),
              _buildBottomButton(),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // PROGRESSION
  // ===========================================================================

  // Widget _buildProgressHeader() {
  //   return Row(
  //     children: [
  //       Expanded(
  //         child: Container(
  //           height: 5,
  //           decoration: BoxDecoration(
  //             color: _accentColor,
  //             borderRadius: BorderRadius.circular(10),
  //           ),
  //         ),
  //       ),
  //       const SizedBox(width: 10),
  //       Text(
  //         'Dernière étape',
  //         style: AppTextStyles.caption.copyWith(
  //           fontWeight: FontWeight.w600,
  //           color: AppColors.primaryBlue,
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // ===========================================================================
  // PROFIL
  // ===========================================================================

  Widget _buildProfileCard() {
    final title = _isEntreprise ? 'Compte entreprise' : 'Compte professionnel';

    final subtitle = _isEntreprise
        ? 'Créez votre compte pour gérer votre activité BTP.'
        : 'Créez votre compte professionnel en quelques secondes.';

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _accentColor.withValues(alpha: 0.15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: _accentColor.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              widget.profileType.icon,
              color: _accentColor,
              size: 28,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.labelStrong.copyWith(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // CHAMPS PRINCIPAUX
  // ===========================================================================

  Widget _buildFormFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionHeader(
          title: 'Informations du compte',
          subtitle: 'Quelques informations suffisent pour commencer.',
        ),
        const SizedBox(height: AppSpacing.md),
        _buildPhoneField(),
        const SizedBox(height: AppSpacing.md),
        ..._buildIdentityFields(),
        if (_isEntreprise) _buildCompanyField(),
        const SizedBox(height: AppSpacing.md),
        TextFormField(
          controller: _addressController,
          textCapitalization: TextCapitalization.sentences,
          textInputAction: TextInputAction.next,
          decoration: _inputDecoration(
            label: 'Adresse',
            hint: 'Ex. : Niamey, Koira Kano',
            icon: Icons.location_on_outlined,
          ),
          validator: _required,
        ),
      ],
    );
  }

  List<Widget> _buildIdentityFields() {
    return [
      TextFormField(
        controller: _firstNameController,
        textCapitalization: TextCapitalization.words,
        textInputAction: TextInputAction.next,
        decoration: _inputDecoration(
          label: 'Prénom',
          icon: Icons.person_outline_rounded,
        ),
        validator: _required,
      ),
      const SizedBox(height: AppSpacing.md),
      TextFormField(
        controller: _lastNameController,
        textCapitalization: TextCapitalization.words,
        textInputAction: TextInputAction.next,
        decoration: _inputDecoration(
          label: 'Nom',
          icon: Icons.person_outline_rounded,
        ),
        validator: _required,
      ),
      const SizedBox(height: AppSpacing.md),
      _buildProfessionField(),
    ];
  }

  Widget _buildCompanyField() {
    return TextFormField(
      controller: _companyNameController,
      textCapitalization: TextCapitalization.words,
      textInputAction: TextInputAction.next,
      decoration: _inputDecoration(
        label: 'Nom de l’entreprise',
        hint: 'Ex. : BTP Niger SARL',
        icon: Icons.business_outlined,
      ),
      validator: _required,
    );
  }

  // ===========================================================================
  // TÉLÉPHONE
  // ===========================================================================

  Widget _buildPhoneField() {
    return TextFormField(
      initialValue: widget.phone,
      readOnly: true,
      decoration: InputDecoration(
        labelText: 'Numéro de téléphone',
        prefixIcon: const Icon(Icons.phone_outlined),
        suffixIcon: Container(
          margin: const EdgeInsets.only(
            right: AppSpacing.sm,
            top: 8,
            bottom: 8,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 9,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            color: _accentColor.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.verified_rounded,
                size: 15,
                color: _accentColor,
              ),
              const SizedBox(width: 4),
              Text(
                'Vérifié',
                style: TextStyle(
                  color: _accentColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // PROFESSION
  // ===========================================================================

  Widget _buildProfessionField() {
    return DropdownButtonFormField<String>(
      initialValue: _profession,
      decoration: _inputDecoration(
        label: 'Profession',
        hint: 'Sélectionnez votre activité',
        icon: Icons.work_outline_rounded,
      ),
      items: _professions.map((profession) {
        return DropdownMenuItem<String>(
          value: profession,
          child: Text(profession),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _profession = value;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Sélectionnez votre profession';
        }

        return null;
      },
    );
  }

  // ===========================================================================
  // SÉCURITÉ
  // ===========================================================================

  Widget _buildSecuritySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionHeader(
          title: 'Sécurité',
          subtitle: 'Choisissez un mot de passe pour protéger votre compte.',
        ),
        const SizedBox(height: AppSpacing.md),
        TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          textInputAction: TextInputAction.next,
          decoration: _inputDecoration(
            label: 'Mot de passe',
            icon: Icons.lock_outline_rounded,
          ).copyWith(
            suffixIcon: IconButton(
              tooltip: 'Afficher le mot de passe',
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
          ),
          validator: _validatePassword,
        ),
        const SizedBox(height: AppSpacing.md),
        TextFormField(
          controller: _confirmationController,
          obscureText: _obscureConfirmation,
          textInputAction: TextInputAction.done,
          decoration: _inputDecoration(
            label: 'Confirmer le mot de passe',
            icon: Icons.lock_reset_outlined,
          ).copyWith(
            suffixIcon: IconButton(
              tooltip: 'Afficher le mot de passe',
              icon: Icon(
                _obscureConfirmation
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
              onPressed: () {
                setState(() {
                  _obscureConfirmation = !_obscureConfirmation;
                });
              },
            ),
          ),
          validator: _validateConfirmation,
          onFieldSubmitted: (_) => _createAccount(),
        ),
      ],
    );
  }

  // ===========================================================================
  // CONDITIONS
  // ===========================================================================

  Widget _buildTerms() {
    return InkWell(
      onTap: () {
        setState(() {
          _acceptedTerms = !_acceptedTerms;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: _acceptedTerms
              ? _accentColor.withValues(alpha: 0.06)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _acceptedTerms
                ? _accentColor.withValues(alpha: 0.25)
                : Colors.transparent,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: _acceptedTerms,
              activeColor: _accentColor,
              onChanged: (value) {
                setState(() {
                  _acceptedTerms = value ?? false;
                });
              },
            ),
            const SizedBox(width: 4),
            const Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  'J’accepte les conditions d’utilisation et la politique de confidentialité.',
                  style: AppTextStyles.caption,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // BOUTON
  // ===========================================================================

  Widget _buildBottomButton() {
    final isSubmitting = ref.watch(registerProvider).isLoading;

    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 15,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SizedBox(
        height: 54,
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: _accentColor,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          onPressed: isSubmitting ? null : _createAccount,
          child: isSubmitting
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Créer mon compte',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 20,
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  // ===========================================================================
  // INPUT DECORATION
  // ===========================================================================

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    String? hint,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon),
    );
  }
}

// =============================================================================
// SECTION HEADER
// =============================================================================

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionHeader({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.h2.copyWith(
            fontSize: 19,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: AppTextStyles.caption.copyWith(
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}
