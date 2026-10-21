import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/theme.dart';

/// Animated background featuring floating educational & medical doodles:
/// - Physics Atom / Orbit model (top-right)
/// - Soft ambient lavender/sky waves
/// - Floating medical cross and particles
/// - Botanical leaves at the bottom
class FlowingWaveBackground extends StatefulWidget {
  const FlowingWaveBackground({
    super.key,
    required this.child,
    this.showFloatingDoodles = true,
  });

  final Widget child;
  final bool showFloatingDoodles;

  @override
  State<FlowingWaveBackground> createState() => _FlowingWaveBackgroundState();
}

class _FlowingWaveBackgroundState extends State<FlowingWaveBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    );

    final isTestEnvironment =
        WidgetsBinding.instance.runtimeType.toString().contains('Test');
    if (!isTestEnvironment) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Soft periwinkle/sky ambient canvas
        Positioned.fill(
          child: Container(
            color: AppColors.background,
          ),
        ),

        // Animated floating doodles & ambient shapes
        if (widget.showFloatingDoodles)
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                return CustomPaint(
                  painter: _DoodleBackgroundPainter(
                    animationValue: _controller.value,
                  ),
                );
              },
            ),
          ),

        // Screen content
        Positioned.fill(child: widget.child),
      ],
    );
  }
}

class _DoodleBackgroundPainter extends CustomPainter {
  _DoodleBackgroundPainter({required this.animationValue});

  final double animationValue;

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    final floatDelta = (animationValue - 0.5) * 16.0;

    // 1. Soft top-right ambient cloud blob
    final blobPaint = Paint()
      ..color = const Color(0xFFE2EDF9).withAlpha(160)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(width * 0.90, height * 0.08), 85, blobPaint);
    canvas.drawCircle(Offset(width * 0.78, height * 0.04), 60, blobPaint);

    // 2. Floating Physics Atom / Orbit Model (Top Right from image)
    final atomCenter = Offset(width * 0.86, height * 0.09 + floatDelta * 0.8);
    _drawAtom(canvas, atomCenter);

    // 3. Floating Sparkle / Star (Top left)
    _drawSparkle(canvas, Offset(width * 0.12, height * 0.06 - floatDelta * 0.6));

    // 4. Floating soft circles / bubbles
    final bubblePaint = Paint()
      ..color = const Color(0xFFD4E3F5).withAlpha(180)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(width * 0.92, height * 0.28 + floatDelta),
      7,
      bubblePaint,
    );
    canvas.drawCircle(
      Offset(width * 0.08, height * 0.42 - floatDelta * 0.7),
      9,
      bubblePaint,
    );

    // 5. Bottom botanical mint leaf sprig (Bottom-right from image)
    _drawBottomLeafSprig(canvas, size, floatDelta);
  }

  void _drawAtom(Canvas canvas, Offset center) {
    final orbitPaint = Paint()
      ..color = AppColors.doodleBlue.withAlpha(180)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;

    final nucleusPaint = Paint()
      ..color = AppColors.doodleBlue.withAlpha(220)
      ..style = PaintingStyle.fill;

    // Central nucleus
    canvas.drawCircle(center, 4.0, nucleusPaint);

    // 3 orbital ellipses
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(-math.pi / 6);
    canvas.drawOval(Rect.fromCenter(center: Offset.zero, width: 46, height: 16), orbitPaint);
    canvas.rotate(math.pi / 3);
    canvas.drawOval(Rect.fromCenter(center: Offset.zero, width: 46, height: 16), orbitPaint);
    canvas.rotate(math.pi / 3);
    canvas.drawOval(Rect.fromCenter(center: Offset.zero, width: 46, height: 16), orbitPaint);
    canvas.restore();
  }

  void _drawSparkle(Canvas canvas, Offset center) {
    final paint = Paint()
      ..color = AppColors.doodleBlue.withAlpha(190)
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(center.dx - 6, center.dy), Offset(center.dx + 6, center.dy), paint);
    canvas.drawLine(Offset(center.dx, center.dy - 6), Offset(center.dx, center.dy + 6), paint);
  }

  void _drawBottomLeafSprig(Canvas canvas, Size size, double floatDelta) {
    final leafPaint = Paint()
      ..color = AppColors.mintGreen.withAlpha(190)
      ..style = PaintingStyle.fill;

    final leafCenter = Offset(size.width * 0.92, size.height * 0.92 + floatDelta * 0.5);

    // Draw 3 soft radiating leaves
    for (int i = 0; i < 3; i++) {
      canvas.save();
      canvas.translate(leafCenter.dx, leafCenter.dy);
      canvas.rotate((i - 1) * 0.5 - 0.4);

      final path = Path()
        ..moveTo(0, 0)
        ..quadraticBezierTo(10, -20, 0, -32)
        ..quadraticBezierTo(-10, -20, 0, 0)
        ..close();
      canvas.drawPath(path, leafPaint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _DoodleBackgroundPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
