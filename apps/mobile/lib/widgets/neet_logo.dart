import 'package:flutter/material.dart';
import '../theme/theme.dart';

/// NEET Community Logo:
/// - "NEET" & "Community" in AppColors.textPrimary (same font color as "Forgot Password?")
/// - Medical ECG heartbeat pulse wave matching the logo color
/// - "Learn • Discuss • Grow Together" subtitle in AppColors.textSecondary
class NeetCommunityLogo extends StatelessWidget {
  const NeetCommunityLogo({
    super.key,
    this.scale = 1.0,
    this.alignment = CrossAxisAlignment.start,
    this.color = AppColors.textPrimary,
  });

  final double scale;
  final CrossAxisAlignment alignment;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final brandColor = color;
    const subtitleColor = AppColors.textSecondary;

    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: alignment == CrossAxisAlignment.center
          ? Alignment.center
          : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: alignment,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'NEET',
                style: TextStyle(
                  fontSize: 32 * scale,
                  fontWeight: FontWeight.w900,
                  color: brandColor,
                  letterSpacing: -0.5,
                  height: 1.05,
                ),
              ),
              SizedBox(width: 8 * scale),
              CustomPaint(
                size: Size(48 * scale, 32 * scale),
                painter: _EcgPulsePainter(color: brandColor),
              ),
            ],
          ),
          Text(
            'Community',
            style: TextStyle(
              fontSize: 26 * scale,
              fontWeight: FontWeight.w600,
              color: brandColor,
              letterSpacing: -0.5,
              height: 1.15,
            ),
          ),
          SizedBox(height: 5 * scale),
          Text(
            'Learn  •  Discuss  •  Grow Together',
            style: TextStyle(
              fontSize: 12.5 * scale,
              fontWeight: FontWeight.w500,
              color: subtitleColor,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _EcgPulsePainter extends CustomPainter {
  const _EcgPulsePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final w = size.width;
    final h = size.height;
    final midY = h * 0.62;

    final path = Path()
      ..moveTo(0, midY)
      ..lineTo(w * 0.22, midY)
      // First small dip
      ..lineTo(w * 0.28, midY + (h * 0.08))
      // High upward systolic spike
      ..lineTo(w * 0.44, h * 0.08)
      // Deep downward diastolic dip
      ..lineTo(w * 0.60, h * 0.94)
      // Recovery upward notch
      ..lineTo(w * 0.76, midY - (h * 0.12))
      // Baseline return
      ..lineTo(w * 0.85, midY)
      ..lineTo(w, midY);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _EcgPulsePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
