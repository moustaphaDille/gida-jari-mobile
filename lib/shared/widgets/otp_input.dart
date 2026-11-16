import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../app/theme/app_colors.dart';

/// 6 cases OTP avec auto-focus et validation automatique au 6ème chiffre.
/// Les cases s'adaptent à la largeur disponible pour rester visibles sur mobile.
/// Les chiffres saisis sont conservés en cas d'erreur pour permettre la correction.
class OtpInput extends StatefulWidget {
  /// Appelé dès que le 6ème chiffre est saisi (auto-soumission).
  final void Function(String code) onCompleted;

  /// Appelé à chaque frappe, avec le code partiel — utile pour activer/
  /// désactiver un bouton "Vérifier" explicite sans auto-soumission.
  final ValueChanged<String>? onChanged;

  final bool hasError;

  const OtpInput({
    super.key,
    required this.onCompleted,
    this.onChanged,
    this.hasError = false,
  });

  @override
  State<OtpInput> createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInput>
    with SingleTickerProviderStateMixin {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  late AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void didUpdateWidget(covariant OtpInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.hasError && !oldWidget.hasError) {
      _shakeController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    _shakeController.dispose();
    super.dispose();
  }

  void _onChanged(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    final code = _controllers.map((c) => c.text).join();
    widget.onChanged?.call(code);
    if (code.length == 6) {
      FocusScope.of(context).unfocus();
      widget.onCompleted(code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shakeController,
      builder: (context, child) {
        final t = _shakeController.value;
        final offset =
            t == 0 ? 0.0 : (8 * (1 - t)) * ((t * 20).floor() % 2 == 0 ? 1 : -1);
        return Transform.translate(offset: Offset(offset, 0), child: child);
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          const gap = 8.0;
          final boxWidth = (constraints.maxWidth - (gap * 5)) / 6;

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(6, (index) {
              return SizedBox(
                width: boxWidth,
                height: 56,
                child: TextField(
                  controller: _controllers[index],
                  focusNode: _focusNodes[index],
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  maxLength: 1,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    counterText: '',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: widget.hasError
                            ? AppColors.errorRed
                            : AppColors.borderNeutral,
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: AppColors.primaryBlue,
                        width: 2,
                      ),
                    ),
                  ),
                  onChanged: (value) => _onChanged(index, value),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
