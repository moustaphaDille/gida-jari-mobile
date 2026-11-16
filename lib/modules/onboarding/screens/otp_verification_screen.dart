import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gida_jari_mobile/core/network/api_exception.dart';
import 'package:gida_jari_mobile/features/auth/providers/auth_providers.dart';

import '../../../app/routing/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/app_theme.dart';
import '../../../shared/models/user_profile.dart';
import '../../../shared/widgets/gj_auth_scaffold.dart';
import '../../../shared/widgets/otp_input.dart';

/// Étape 4 — Saisie du code OTP.
/// Le backend envoie un code à 6 chiffres.
/// 3 tentatives affichées puis message de blocage (15 min).
class OtpVerificationScreen extends ConsumerStatefulWidget {
  final OtpVerificationArgs args;

  const OtpVerificationScreen({super.key, required this.args});

  @override
  ConsumerState<OtpVerificationScreen> createState() =>
      _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  static const int _otpLength = 6;

  bool _hasError = false;
  int _attemptsLeft = 3;
  int _secondsLeft = 60;
  String _code = '';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _secondsLeft = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft == 0) {
        t.cancel();
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _onCodeChanged(String code) {
    setState(() {
      _code = code;
      if (_hasError) {
        _hasError = false; // on efface l'erreur dès que l'utilisateur corrige
      }
    });
  }

  Future<void> _verify() async {
    final isVerifying = ref.read(verifyOtpProvider).isLoading;
    if (_code.length != _otpLength || isVerifying) return;

    FocusScope.of(context).unfocus();

    await ref.read(verifyOtpProvider.notifier).verify(code: _code);

    if (!mounted) return;

    final result = ref.read(verifyOtpProvider);

    if (result.hasError) {
      _handleVerifyError(result.error!);
      return;
    }

    if (result.value != null) {
      _goToRegistration();
    }
  }

  void _handleVerifyError(Object error) {
    // Code faux ou expiré : on garde le comportement visuel de la maquette.
    if (error is ApiException && error.code == 'OTP_INVALIDE') {
      setState(() {
        _hasError = true;
        _attemptsLeft -= 1;
      });
      if (_attemptsLeft <= 0) {
        _showBlockedDialog();
      }
      return;
    }

    // Autre erreur (réseau, session…) : on affiche le message du backend.
    _showSnack(errorMessage(error));
  }

  // OtpInput.onCompleted exige un callback, mais conformément à la maquette
  // la validation ne se déclenche qu'au tap explicite sur "Vérifier".
  void _onCompleted(String code) {}

  Future<void> _resend() async {
    setState(() => _hasError = false);

    await ref.read(sendOtpProvider.notifier).resend();
    if (!mounted) return;

    final result = ref.read(sendOtpProvider);
    if (result.hasError) {
      _showSnack(errorMessage(result.error!));
      return;
    }

    _startTimer();
    _showSnack('Un nouveau code a été envoyé.');
  }

  void _goToRegistration() {
    final verified = ref.read(verifyOtpProvider).value;
    if (verified == null || verified.temporaryToken.trim().isEmpty) {
      _showSnack('La vérification du code a échoué. Recommencez.');
      return;
    }

    Navigator.of(context).pushReplacementNamed(
      AppRoutes.registration,
      arguments: widget.args,
    );
  }

  void _showBlockedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Trop de tentatives'),
        content: const Text(
          'Vous avez saisi un code incorrect 3 fois. Réessayez dans 15 minutes.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).popUntil(
                (r) => r.settings.name == AppRoutes.login || r.isFirst),
            child: const Text('Retour à l\'accueil'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.args.profileType.color;
    final isVerifying = ref.watch(verifyOtpProvider).isLoading;

    // Le canal (SMS ou email) vient de la réponse de send-otp
    final sent = ref.watch(sendOtpProvider).value;
    final byEmail = sent?.canal == 'EMAIL';
    final subtitle = byEmail
        ? 'Saisissez le code envoyé par email à ${sent?.emailMasque ?? 'votre adresse'}.'
        : 'Saisissez le code envoyé par SMS au ${widget.args.contact}.';

    return GjAuthScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AuthIconAvatar(
            icon: Icons.lock_outline_rounded,
            background: color.withValues(alpha: 0.12),
            iconColor: color,
          ),
          AuthTitleBlock(
            title: 'Vérification du compte',
            subtitle: subtitle,
          ),
          OtpInput(
            onCompleted: _onCompleted,
            onChanged: _onCodeChanged,
            hasError: _hasError,
          ),
          if (_hasError) ...[
            const SizedBox(height: AppSpacing.sm),
            Center(
              child: Text(
                'Code incorrect ou expiré. $_attemptsLeft tentative(s) restante(s).',
                style:
                    AppTextStyles.caption.copyWith(color: AppColors.errorRed),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.successGreen),
            onPressed:
                _code.length == _otpLength && !isVerifying ? _verify : null,
            icon: isVerifying
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                : const Icon(Icons.check_circle_outline, size: 18),
            label: const Text('Vérifier'),
          ),
          const SizedBox(height: AppSpacing.md),
          Center(
            child: TextButton(
              onPressed: _secondsLeft == 0 ? _resend : null,
              child: Text(
                _secondsLeft == 0
                    ? 'Renvoyer le code'
                    : 'Renvoyer le code (${_secondsLeft}s)',
                style: TextStyle(color: color),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
