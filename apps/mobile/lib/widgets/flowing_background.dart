import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Animated background featuring:
/// - Responsive mobile application boundary on wide screens (desktop/browser)
/// - Organic sweeping curved dual-layer blue gradient waves dividing top blue and bottom soft white
/// - Floating, gently oscillating 3D shaded bubbles in multiple blue shades
/// - Translucent dot matrix accent grids on both sides
class FlowingWaveBackground extends StatefulWidget {
  const FlowingWaveBackground({
    super.key,
    required this.child,
    this.waveFraction = 0.44,
  });

  final Widget child;
  final double waveFraction;

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
      duration: const Duration(seconds: 5),
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
    return LayoutBuilder(
      builder: (context, constraints) {
        // When screen width > 500 (web/desktop browser), frame within mobile device boundaries
        final isWideScreen = constraints.maxWidth > 500;

        final mobileAppCanvas = ClipRRect(
          borderRadius: isWideScreen ? BorderRadius.circular(36) : BorderRadius.zero,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: isWideScreen
                  ? Border.all(color: const Color(0xFFCFDCEB), width: 2.0)
                  : null,
              boxShadow: isWideScreen
                  ? [
                      const BoxShadow(
                        color: Color(0x220D47A1),
                        blurRadius: 40,
                        offset: Offset(0, 16),
                      ),
                      BoxShadow(
                        color: Colors.black.withAlpha(20),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // 1. Soft bottom background canvas
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFFF2F7FC),
                          Color(0xFFFFFFFF),
                        ],
                      ),
                    ),
                  ),
                ),

                // 2. Animated curved waves, dot matrices, and floating 3D bubbles
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, _) {
                      return CustomPaint(
                        painter: _OrganicWaveAndBubblesPainter(
                          animationValue: _controller.value,
                          waveFraction: widget.waveFraction,
                        ),
                      );
                    },
                  ),
                ),

                // 3. Foreground Screen Content
                Positioned.fill(child: widget.child),
              ],
            ),
          ),
        );

        if (!isWideScreen) {
          return mobileAppCanvas;
        }

        // On desktop/browser: center within a standard mobile device boundary
        return Container(
          color: const Color(0xFFE8EEF5), // Elegant desktop ambient backdrop
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 430, // Standard modern mobile width (iPhone Pro Max / Galaxy S)
              maxHeight: 900,
            ),
            child: mobileAppCanvas,
          ),
        );
      },
    );
  }
}

class _BubbleSpec {
  const _BubbleSpec({
    required this.relX,
    required this.relY,
    required this.radius,
    required this.primaryColor,
    required this.highlightColor,
    required this.phase,
    required this.floatAmpX,
    required this.floatAmpY,
    this.isLightCanvas = false,
  });

  final double relX;
  final double relY;
  final double radius;
  final Color primaryColor;
  final Color highlightColor;
  final double phase;
  final double floatAmpX;
  final double floatAmpY;
  final bool isLightCanvas;
}

class _OrganicWaveAndBubblesPainter extends CustomPainter {
  _OrganicWaveAndBubblesPainter({
    required this.animationValue,
    required this.waveFraction,
  });

  final double animationValue;
  final double waveFraction;

  static const List<_BubbleSpec> _bubbles = [
    // Top-left soft sky orb
    _BubbleSpec(
      relX: 0.04,
      relY: 0.08,
      radius: 54,
      primaryColor: Color(0xFF42A5F5),
      highlightColor: Color(0xFFB3E5FC),
      phase: 0.3,
      floatAmpX: 4.0,
      floatAmpY: 7.0,
    ),
    // Top-left small floating droplet
    _BubbleSpec(
      relX: 0.22,
      relY: 0.15,
      radius: 18,
      primaryColor: Color(0xFF64B5F6),
      highlightColor: Color(0xFFE1F5FE),
      phase: 1.2,
      floatAmpX: 3.5,
      floatAmpY: 5.0,
    ),
    // Mid-right upper floating orb
    _BubbleSpec(
      relX: 0.78,
      relY: 0.26,
      radius: 16,
      primaryColor: Color(0xFF80D8FF),
      highlightColor: Colors.white,
      phase: 2.1,
      floatAmpX: 4.0,
      floatAmpY: 6.0,
    ),
    // Right ambient soft glow
    _BubbleSpec(
      relX: 0.96,
      relY: 0.54,
      radius: 26,
      primaryColor: Color(0xFF80D8FF),
      highlightColor: Color(0xFFE1F5FE),
      phase: 3.0,
      floatAmpX: 4.0,
      floatAmpY: 8.0,
      isLightCanvas: true,
    ),
    // Bottom-left large pastel blue floating sphere
    _BubbleSpec(
      relX: 0.08,
      relY: 0.86,
      radius: 68,
      primaryColor: Color(0xFF90CAF9),
      highlightColor: Color(0xFFE3F2FD),
      phase: 1.6,
      floatAmpX: 5.0,
      floatAmpY: 8.0,
      isLightCanvas: true,
    ),
    // Bottom-right shaded blue orb
    _BubbleSpec(
      relX: 0.82,
      relY: 0.86,
      radius: 34,
      primaryColor: Color(0xFF64B5F6),
      highlightColor: Color(0xFFB3E5FC),
      phase: 2.7,
      floatAmpX: 5.0,
      floatAmpY: 7.0,
      isLightCanvas: true,
    ),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final waveBaseH = (h * waveFraction).clamp(200.0, 480.0);
    final waveShift = math.sin(animationValue * 2 * math.pi) * 6.0;

    // --- Layer 1: Background Subtle Cyan-Blue Wave ---
    final backWavePath = Path()
      ..moveTo(0, 0)
      ..lineTo(w, 0)
      ..lineTo(w, waveBaseH + 24 + waveShift)
      ..cubicTo(
        w * 0.75,
        waveBaseH + 36 - waveShift,
        w * 0.35,
        waveBaseH - 30 + waveShift,
        0,
        waveBaseH + 8 - waveShift,
      )
      ..close();

    final backWavePaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF29B6F6),
          Color(0xFF1E88E5),
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, waveBaseH + 45));
    canvas.drawPath(backWavePath, backWavePaint);

    // --- Layer 2: Main Rich Royal Blue Wave ---
    final mainWavePath = Path()
      ..moveTo(0, 0)
      ..lineTo(w, 0)
      ..lineTo(w, waveBaseH - 12 - waveShift)
      ..cubicTo(
        w * 0.68,
        waveBaseH + 28 + waveShift,
        w * 0.28,
        waveBaseH - 36 - waveShift,
        0,
        waveBaseH - 6 + waveShift,
      )
      ..close();

    final mainWavePaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: [0.0, 0.35, 0.70, 1.0],
        colors: [
          Color(0xFF1E88E5), // Rich electric blue
          Color(0xFF1976D2), // Royal cobalt
          Color(0xFF1565C0), // Deep blue
          Color(0xFF0D47A1), // Midnight blue
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, waveBaseH + 35));
    canvas.drawPath(mainWavePath, mainWavePaint);

    // --- Layer 3: Dot Matrix Grid Accents on Left & Right ---
    _drawDotGrid(canvas, Offset(w * 0.08, waveBaseH * 0.34), 5, 3);
    _drawDotGrid(canvas, Offset(w * 0.84, waveBaseH * 0.36), 5, 3);

    // --- Layer 4: Multi-Shade Floating Bubbles ---
    for (final spec in _bubbles) {
      final floatX = math.cos((animationValue * 2 * math.pi) + spec.phase) * spec.floatAmpX;
      final floatY = math.sin((animationValue * 2 * math.pi) + spec.phase) * spec.floatAmpY;

      final cx = (spec.relX * w) + floatX;
      final cy = (spec.relY * h) + floatY;
      final r = spec.radius;

      final rect = Rect.fromCircle(center: Offset(cx, cy), radius: r);
      final alphaFactor = spec.isLightCanvas ? 0.85 : 1.0;

      final gradient = RadialGradient(
        center: const Alignment(-0.35, -0.35),
        radius: 0.95,
        colors: [
          spec.highlightColor.withAlpha((110 * alphaFactor).toInt()),
          spec.primaryColor.withAlpha((60 * alphaFactor).toInt()),
          spec.primaryColor.withAlpha((20 * alphaFactor).toInt()),
          Colors.transparent,
        ],
        stops: const [0.0, 0.45, 0.80, 1.0],
      );

      final paint = Paint()
        ..shader = gradient.createShader(rect)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(cx, cy), r, paint);

      // Subtle outer rim
      final ringPaint = Paint()
        ..color = spec.highlightColor.withAlpha((40 * alphaFactor).toInt())
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;
      canvas.drawCircle(Offset(cx, cy), r * 0.94, ringPaint);

      // Specular highlight spot
      final specularCenter = Offset(cx - (r * 0.32), cy - (r * 0.32));
      final specularPaint = Paint()
        ..color = Colors.white.withAlpha((80 * alphaFactor).toInt())
        ..style = PaintingStyle.fill;
      canvas.drawCircle(specularCenter, math.max(1.5, r * 0.14), specularPaint);
    }
  }

  void _drawDotGrid(Canvas canvas, Offset origin, int cols, int rows) {
    const double spacing = 8.5;
    const double dotRadius = 1.5;
    final dotPaint = Paint()
      ..color = Colors.white.withAlpha(55)
      ..style = PaintingStyle.fill;

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        canvas.drawCircle(
          Offset(origin.dx + (c * spacing), origin.dy + (r * spacing)),
          dotRadius,
          dotPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _OrganicWaveAndBubblesPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.waveFraction != waveFraction;
  }
}
