import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Cercle de progression animé du score de complétion de profil.
/// Couleur adaptative : rouge < 40% / orange 40-70% / vert > 70%.
/// Conforme au Module M16 (score de complétion gamifié).
class ProfileScoreCircle extends StatelessWidget {
  final int score; // 0-100
  final double size;

  const ProfileScoreCircle({super.key, required this.score, this.size = 96});

  Color get _color {
    if (score < 40) return AppColors.errorRed;
    if (score < 70) return AppColors.warningOrange;
    return AppColors.successGreen;
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: score / 100),
      duration: const Duration(milliseconds: 1200),
      curve: Curves.easeOut,
      builder: (context, value, _) {
        return SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _ArcPainter(progress: value, color: _color),
            child: Center(
              child: Text(
                '${(value * 100).round()}%',
                style: AppTextStyles.h2.copyWith(color: _color, fontSize: size * 0.24),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ArcPainter extends CustomPainter {
  final double progress;
  final Color color;

  _ArcPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;

    final bgPaint = Paint()
      ..color = AppColors.borderNeutral
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bgPaint);

    final fgPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ArcPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}
