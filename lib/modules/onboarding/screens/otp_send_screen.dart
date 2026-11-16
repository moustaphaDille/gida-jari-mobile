import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gida_jari_mobile/core/network/api_exception.dart';
import 'package:gida_jari_mobile/features/auth/providers/auth_providers.dart';
import '../../../app/routing/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/app_theme.dart';
import '../../../shared/models/user_profile.dart';
import '../../../shared/widgets/gj_auth_scaffold.dart';

/// Étape 2 — Envoi du code OTP.
///
/// Le backend attend le téléphone et l'email pour créer un compte.
/// Le code OTP est envoyé à l'adresse email renseignée.
class OtpSendScreen extends ConsumerStatefulWidget {
  final ProfileType profileType;

  const OtpSendScreen({
    super.key,
    required this.profileType,
  });

  @override
  ConsumerState<OtpSendScreen> createState() => _OtpSendScreenState();
}

class _OtpSendScreenState extends ConsumerState<OtpSendScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  /// Format simple : quelquechose@domaine.xx (le serveur reste la vraie validation).
  static final RegExp _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  String get _phoneDigits => _phoneController.text.replaceAll(' ', '');

  bool get _isValid {
    if (_phoneDigits.length != 8) return false;
    return _emailRegex.hasMatch(_emailController.text.trim());
  }

  /// 90123456 → 90 12 34 56 (maximum 8 chiffres).
  void _formatPhone(String value) {
    var digits = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length > 8) {
      digits = digits.substring(0, 8);
    }

    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && i % 2 == 0) buffer.write(' ');
      buffer.write(digits[i]);
    }
    final formatted = buffer.toString();

    if (_phoneController.text != formatted) {
      _phoneController.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }

    setState(() {});
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _sendOtp() async {
    final isSending = ref.read(sendOtpProvider).isLoading;
    if (!_isValid || isSending) return;

    FocusScope.of(context).unfocus();

    final email = _emailController.text.trim().toLowerCase();

    await ref
        .read(sendOtpProvider.notifier)
        .send(phone: _phoneDigits, email: email);

    if (!mounted) return;

    final result = ref.read(sendOtpProvider);

    if (result.hasError) {
      _showSnack(errorMessage(result.error!));
      return;
    }

    final response = result.value;
    if (response == null) return;

    Navigator.of(context).pushNamed(
      AppRoutes.otpVerification,
      arguments: OtpVerificationArgs(
        contact: '+227$_phoneDigits',
        method: ContactMethod.phone,
        profileType: widget.profileType,
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration({
    required String hint,
    Widget? prefixIcon,
  }) {
    OutlineInputBorder border(Color color, double width) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: color, width: width),
        );

    return InputDecoration(
      hintText: hint,
      prefixIcon: prefixIcon,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 16,
      ),
      enabledBorder: border(AppColors.borderNeutral, 1),
      focusedBorder: border(AppColors.primaryBlue, 1.5),
    );
  }

  Widget _buildPhoneField() {
    return Row(
      children: [
        Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.borderNeutral),
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: const Center(
            child: Text('🇳🇪 +227', style: AppTextStyles.labelStrong),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(8),
            ],
            style: AppTextStyles.labelStrong,
            decoration: _inputDecoration(hint: '9X XX XX XX'),
            onChanged: _formatPhone,
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          textInputAction: TextInputAction.done,
          style: AppTextStyles.labelStrong,
          decoration: _inputDecoration(
            hint: 'nom@exemple.com',
            prefixIcon: const Icon(Icons.alternate_email_rounded, size: 20),
          ),
          onChanged: (_) => setState(() {}),
          onSubmitted: (_) => _sendOtp(),
        ),
        const SizedBox(height: 6),
        const Text(
          'Un email est nécessaire pour finaliser votre inscription.',
          style: AppTextStyles.caption,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSending = ref.watch(sendOtpProvider).isLoading;

    return GjAuthScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AuthIconAvatar(icon: Icons.phone_iphone_rounded),
          const AuthTitleBlock(
            title: 'Créez votre accès',
            subtitle:
                'Entrez votre numéro pour recevoir votre code de vérification.',
          ),
          _buildPhoneField(),
          _buildEmailField(),
          const SizedBox(height: AppSpacing.md),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 1),
                child: Icon(
                  Icons.lock_outline,
                  size: 16,
                  color: AppColors.successGreen,
                ),
              ),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Votre numéro est sécurisé et ne sera jamais partagé.',
                  style: AppTextStyles.caption,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.successGreen,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey.shade300,
                disabledForegroundColor: Colors.grey.shade500,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
              ),
              onPressed: _isValid && !isSending ? _sendOtp : null,
              child: isSending
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Recevoir le code',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward_rounded, size: 20),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
