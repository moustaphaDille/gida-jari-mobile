import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/models/user_profile.dart';
import '../../../shared/widgets/gj_auth_scaffold.dart';

/// Étape 3 — Numéro de téléphone. JAMAIS d'email requis à ce stade
/// (Principe fondateur P1 du brief mobile : téléphone-first).
class PhoneNumberScreen extends StatefulWidget {
  final ProfileType profileType;

  const PhoneNumberScreen({super.key, required this.profileType});

  @override
  State<PhoneNumberScreen> createState() => _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends State<PhoneNumberScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isValid = false;
  bool _isSending = false;

  // Format nigérien attendu : 8 chiffres, ex 90 12 34 56.
  void _validate(String value) {
    final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
    setState(() => _isValid = digits.length == 8);
  }

  Future<void> _sendOtp() async {
    setState(() => _isSending = true);
    // TODO: appel API Spring Boot — POST /api/auth/otp/send { phone }
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() => _isSending = false);
    final fullPhone = '+227${_controller.text.replaceAll(' ', '')}';
    Navigator.of(context).pushNamed(
      AppRoutes.otpVerification,
      arguments: OtpVerificationArgs(phone: fullPhone, profileType: widget.profileType),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.profileType.color;
    return GjAuthScaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, leading: const BackButton(),),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AuthIconAvatar(
            icon: Icons.phone_iphone_rounded,
            background: color.withValues(alpha: 0.12),
            iconColor: color,
          ),
          const AuthTitleBlock(
            title: 'Votre numéro de téléphone',
            subtitle: "Pas d'email requis. Votre téléphone est votre identité.",
          ),
          Row(
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
                    controller: _controller,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: AppTextStyles.labelStrong,
                    decoration: const InputDecoration(hintText: '9X XX XX XX', border: OutlineInputBorder()),
                    onChanged: _validate,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            const Row(
              children: [
                Icon(Icons.lock_outline, size: 16, color: AppColors.successGreen),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Votre numéro est sécurisé et ne sera jamais partagé',
                    style: AppTextStyles.caption,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: color),
              onPressed: _isValid && !_isSending ? _sendOtp : null,
              child: _isSending
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Recevoir le code'),
            ),
        ],
      ),
    );
  }
}
