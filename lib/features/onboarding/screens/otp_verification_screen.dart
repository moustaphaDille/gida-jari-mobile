import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/models/user_profile.dart';
import '../../../shared/widgets/otp_input.dart';
import '../../../shared/widgets/gj_auth_scaffold.dart';

/// Étape 4 — Code OTP à 4 chiffres. 3 tentatives max puis blocage 15 min
/// (règle non-négociable — cf. Action 1.1 / OTPVerification du MCD).
class OtpVerificationScreen extends StatefulWidget {
  final OtpVerificationArgs args;

  const OtpVerificationScreen({super.key, required this.args});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  bool _hasError = false;
  bool _isVerifying = false;
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

  void _onCodeChanged(String code) {
    setState(() {
      _code = code;
      if (_hasError)
        _hasError = false; // on efface l'erreur dès que l'utilisateur corrige
    });
  }

  Future<void> _verify() async {
    if (_code.length != 4 || _isVerifying) return;
    setState(() => _isVerifying = true);
    // TODO: appel API Spring Boot — POST /api/auth/otp/verify { phone, code }
    await Future.delayed(const Duration(milliseconds: 500));
    final isValid = _code.length == 4; // simulation locale

    if (!mounted) return;
    setState(() => _isVerifying = false);

    if (isValid) {
      _goToRegistration();
    } else {
      setState(() {
        _hasError = true;
        _attemptsLeft -= 1;
      });
      if (_attemptsLeft <= 0) {
        _showBlockedDialog();
      }
    }
  }

  // OtpInput.onCompleted exige un callback, mais conformément à la maquette
  // la validation ne se déclenche qu'au tap explicite sur "Vérifier".
  void _onCompleted(String code) {}

  void _goToRegistration() {
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
    return GjAuthScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AuthIconAvatar(
            icon: Icons.lock_outline_rounded,
            background: color.withOpacity(0.12),
            iconColor: color,
          ),
          AuthTitleBlock(
            title: 'Vérification du compte',
            subtitle:
                'Saisissez le code envoyé par SMS au ${widget.args.phone}.',
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
                'Code incorrect. $_attemptsLeft tentative(s) restante(s).',
                style:
                    AppTextStyles.caption.copyWith(color: AppColors.errorRed),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.successGreen),
            onPressed: _code.length == 4 && !_isVerifying ? _verify : null,
            icon: _isVerifying
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
              onPressed: _secondsLeft == 0
                  ? () {
                      setState(() => _hasError = false);
                      _startTimer();
                      // TODO: renvoyer le SMS
                    }
                  : null,
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
