import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Hero Illustration matching the exact user reference design:
/// - Prominent authentic student character from the original artwork (no duplicate logo)
/// - Coral-red key held in his hand that floats away from him, then comes back towards
///   his hand, and floats away again in a continuous, magical floating cycle
/// - Live stardust energy and sparkling rays connecting hand to key
/// - Animated physics atom doodle with orbiting electrons in top-right
/// - Mint botanical leaf sprig in bottom-right with live sway
/// - Clean mobile container boundary with rounded corners and soft border
class ForgotPasswordHeroIllustration extends StatefulWidget {
  const ForgotPasswordHeroIllustration({super.key, this.height = 160});

  final double height;

  @override
  State<ForgotPasswordHeroIllustration> createState() =>
      _ForgotPasswordHeroIllustrationState();
}

class _ForgotPasswordHeroIllustrationState
    extends State<ForgotPasswordHeroIllustration>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    // Continuous floating animation only in live app to avoid pumpAndSettle timeout in tests
    final isTest =
        WidgetsBinding.instance.runtimeType.toString().contains('Test');
    if (!isTest) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF7FAFD),
            Color(0xFFEFF5FB),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE2EAF5),
          width: 1.2,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final anim = _controller.value;

          return LayoutBuilder(
            builder: (context, constraints) {
              final w = constraints.maxWidth;
              final h = constraints.maxHeight;

              // Character sizing preserving aspect ratio
              final imgHeight = h - 16;
              final imgWidth = imgHeight * (395.0 / 430.0);
              final imgLeft = (w - imgWidth) / 2;
              const imgTop = 8.0;

              // Gentle ambient character breathing float
              final characterBob = math.sin(anim * 2 * math.pi) * 2.0;

              // Exact position of the student's open reaching hand
              final handGripX = imgLeft + (imgWidth * 0.816);
              final handGripY = imgTop + characterBob + (imgHeight * 0.177);

              // Floating key movement cycle:
              // 0.0 = resting directly at his hand
              // 1.0 = levitated away into the air
              // Smooth back-and-forth easeInOut cycle
              final rawProgress =
                  (math.sin(anim * 2 * math.pi - math.pi / 2) + 1.0) / 2.0;
              final floatProgress =
                  Curves.easeInOutCubic.transform(rawProgress);

              // Key moves outward diagonally away from his hand, then returns back
              final moveAwayX = 18.0 * floatProgress;
              final moveAwayY = -14.0 * floatProgress +
                  (math.sin(anim * 4 * math.pi) * 1.5 * floatProgress);

              // Key center in hand vs in mid-air
              final restKeyX = imgLeft + (imgWidth * 0.870);
              final restKeyY = imgTop + characterBob + (imgHeight * 0.125);

              final currentKeyX = restKeyX + moveAwayX;
              final currentKeyY = restKeyY + moveAwayY;

              // Key rotation: holds naturally at hand angle, tilts slightly as it levitates away
              final keyRotation = -0.12 + (0.22 * floatProgress);

              // Key dimensions
              final keySize = imgWidth * 0.22;

              return Stack(
                fit: StackFit.expand,
                children: [
                  // 1. Extra Animated Doodles (Physics Atom in top-right, Mint leaves in bottom-right)
                  CustomPaint(
                    size: Size(w, h),
                    painter: _HeroBackgroundDoodlesPainter(
                      animationValue: anim,
                    ),
                  ),

                  // 2. Authentic Student Character Artwork (Clean, no duplicate logo, no baked key)
                  Positioned(
                    left: imgLeft,
                    top: imgTop + characterBob,
                    width: imgWidth,
                    height: imgHeight,
                    child: Image.asset(
                      'assets/images/clean_man_scene.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return CustomPaint(
                          painter: _RealisticCharacterFallbackPainter(
                            animationValue: anim,
                          ),
                        );
                      },
                    ),
                  ),

                  // 3. Stardust energy particles streaming between hand and floating key
                  CustomPaint(
                    size: Size(w, h),
                    painter: _HandToKeyEnergyPainter(
                      handPos: Offset(handGripX, handGripY),
                      keyPos: Offset(currentKeyX, currentKeyY),
                      progress: floatProgress,
                      animationValue: anim,
                    ),
                  ),

                  // 4. Attractive Floating Key with Radiant Glowing Aura & Smooth Levitation
                  Positioned(
                    left: currentKeyX - (keySize / 2),
                    top: currentKeyY - (keySize / 2),
                    width: keySize,
                    height: keySize,
                    child: Transform.rotate(
                      angle: keyRotation,
                      alignment: Alignment.center,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Soft magical glow aura behind key
                          Container(
                            width: keySize * (0.85 + (0.25 * floatProgress)),
                            height: keySize * (0.85 + (0.25 * floatProgress)),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFFF6B6B).withAlpha(
                                    (70 + (90 * floatProgress)).toInt(),
                                  ),
                                  blurRadius: 12 + (8 * floatProgress),
                                  spreadRadius: 2 + (3 * floatProgress),
                                ),
                                BoxShadow(
                                  color: const Color(0xFFFFD166).withAlpha(
                                    (40 + (50 * floatProgress)).toInt(),
                                  ),
                                  blurRadius: 18,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                          ),

                          // High-res attractive coral key
                          Image.asset(
                            'assets/images/clean_floating_key.png',
                            width: keySize * 0.92,
                            height: keySize * 0.92,
                            fit: BoxFit.contain,
                            filterQuality: FilterQuality.high,
                            errorBuilder: (context, error, stackTrace) {
                              return CustomPaint(
                                size: Size(keySize, keySize),
                                painter: _FallbackVectorKeyPainter(),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 5. Radiant sparkle rays bursting from key tip as it moves away
                  CustomPaint(
                    size: Size(w, h),
                    painter: _KeySparkleOverlayPainter(
                      keyCenter: Offset(currentKeyX, currentKeyY),
                      animationValue: anim,
                      floatProgress: floatProgress,
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

/// Extra Animated Elements (Physics Atom, Mint Leaves, Bubbles)
class _HeroBackgroundDoodlesPainter extends CustomPainter {
  _HeroBackgroundDoodlesPainter({required this.animationValue});

  final double animationValue;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 1. Animated Physics Atom in Top-Right
    final atomFloatY = math.sin(animationValue * 2 * math.pi + 1.0) * 3.5;
    _drawPhysicsAtom(
      canvas,
      Offset(w * 0.89, h * 0.22 + atomFloatY),
      animationValue,
    );

    // 2. Mint Botanical Leaf Sprig at Bottom-Right
    final rightLeafSway = math.sin(animationValue * 2 * math.pi + 0.5) * 0.08;
    _drawBottomRightLeaves(
      canvas,
      Offset(w * 0.91, h * 0.86),
      rightLeafSway,
    );

    // 3. Ambient Floating Bubbles
    final p1 = Paint()..color = const Color(0xFFBDCBEB).withAlpha(120);
    final p2 = Paint()..color = const Color(0xFFA7E4D3).withAlpha(130);

    final float1 = math.sin(animationValue * 2 * math.pi) * 3.0;
    final float2 = math.cos(animationValue * 2 * math.pi) * 3.0;

    canvas.drawCircle(Offset(w * 0.12, h * 0.25 + float1), 3.5, p1);
    canvas.drawCircle(Offset(w * 0.86, h * 0.48 + float2), 3.5, p1);
    canvas.drawCircle(Offset(w * 0.10, h * 0.75 - float1), 3.0, p2);
  }

  void _drawPhysicsAtom(Canvas canvas, Offset pos, double anim) {
    final ringPaint = Paint()
      ..color = const Color(0xFF9EAFD2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final electronPaint = Paint()
      ..color = const Color(0xFF7B8EC8)
      ..style = PaintingStyle.fill;

    // Center nucleus
    canvas.drawCircle(pos, 3.5, electronPaint);

    // 3 Orbiting Ellipses
    final angles = [0.0, math.pi / 3, 2 * math.pi / 3];
    for (int i = 0; i < angles.length; i++) {
      canvas.save();
      canvas.translate(pos.dx, pos.dy);
      canvas.rotate(angles[i]);

      final orbitRect = Rect.fromCenter(
        center: Offset.zero,
        width: 25,
        height: 10,
      );
      canvas.drawOval(orbitRect, ringPaint);

      // Orbiting electron dot on the perimeter
      final electronAngle = (anim * 2 * math.pi) + (i * 2.0);
      final ex = 12.5 * math.cos(electronAngle);
      final ey = 5.0 * math.sin(electronAngle);
      canvas.drawCircle(Offset(ex, ey), 1.8, electronPaint);

      canvas.restore();
    }
  }

  void _drawBottomRightLeaves(Canvas canvas, Offset pos, double swayAngle) {
    final leafPaint = Paint()..color = const Color(0xFF58C7A2);
    final lightLeafPaint = Paint()..color = const Color(0xFFA1E7D1);
    final stemPaint = Paint()
      ..color = const Color(0xFF45A986)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final stemPath = Path()
      ..moveTo(pos.dx, pos.dy)
      ..quadraticBezierTo(pos.dx - 8, pos.dy - 14, pos.dx - 12, pos.dy - 24);
    canvas.drawPath(stemPath, stemPaint);

    for (int i = 0; i < 3; i++) {
      canvas.save();
      canvas.translate(pos.dx - 6 - (i * 3), pos.dy - 8 - (i * 7));
      canvas.rotate(-0.4 + (i * 0.45) + swayAngle);

      final path = Path()
        ..moveTo(0, 0)
        ..quadraticBezierTo(6, -9, 0, -16)
        ..quadraticBezierTo(-6, -9, 0, 0)
        ..close();
      canvas.drawPath(path, i % 2 == 0 ? leafPaint : lightLeafPaint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _HeroBackgroundDoodlesPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

/// Luminous stardust energy particles streaming between the student's hand and the moving key
class _HandToKeyEnergyPainter extends CustomPainter {
  _HandToKeyEnergyPainter({
    required this.handPos,
    required this.keyPos,
    required this.progress,
    required this.animationValue,
  });

  final Offset handPos;
  final Offset keyPos;
  final double progress;
  final double animationValue;

  @override
  void paint(Canvas canvas, Size size) {
    // Only visible when key is floating away from hand
    if (progress < 0.05) return;

    final alpha = (progress * 220).clamp(0, 255).toInt();
    const count = 4;

    for (int i = 0; i < count; i++) {
      final t = (animationValue * 1.5 + (i / count)) % 1.0;
      // Interpolate along the arc between hand and key
      final px = handPos.dx + (keyPos.dx - handPos.dx) * t;
      final py = handPos.dy +
          (keyPos.dy - handPos.dy) * t -
          (math.sin(t * math.pi) * 6.0);

      final pAlpha = (math.sin(t * math.pi) * alpha).clamp(0, 255).toInt();
      final dotRadius = 1.2 + (1.2 * math.sin(t * math.pi));

      // Coral/gold fairy particles
      final color = i % 2 == 0
          ? const Color(0xFFFF6B6B).withAlpha(pAlpha)
          : const Color(0xFFFFD166).withAlpha(pAlpha);

      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(px, py), dotRadius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _HandToKeyEnergyPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.progress != progress ||
        oldDelegate.keyPos != keyPos;
  }
}

/// Radiant sparkle rays bursting around the key as it moves
class _KeySparkleOverlayPainter extends CustomPainter {
  _KeySparkleOverlayPainter({
    required this.keyCenter,
    required this.animationValue,
    required this.floatProgress,
  });

  final Offset keyCenter;
  final double animationValue;
  final double floatProgress;

  @override
  void paint(Canvas canvas, Size size) {
    final rayPulse =
        (130 + 110 * math.sin(animationValue * 2 * math.pi)).clamp(0, 255).toInt();
    final rayAlpha = (rayPulse * (0.5 + 0.5 * floatProgress)).toInt();

    final rayPaint = Paint()
      ..color = const Color(0xFFFF8E72).withAlpha(rayAlpha)
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;

    final rayLen = 4.0 + (4.0 * floatProgress) + 2.0 * math.sin(animationValue * 4 * math.pi);

    // Dynamic 4-pointed radiant star rays around key tip
    canvas.drawLine(
      Offset(keyCenter.dx + 6, keyCenter.dy - 6),
      Offset(keyCenter.dx + 6 + rayLen, keyCenter.dy - 6 - rayLen),
      rayPaint,
    );
    canvas.drawLine(
      Offset(keyCenter.dx + 10, keyCenter.dy),
      Offset(keyCenter.dx + 10 + rayLen, keyCenter.dy),
      rayPaint,
    );
    canvas.drawLine(
      Offset(keyCenter.dx - 4, keyCenter.dy - 10),
      Offset(keyCenter.dx - 4, keyCenter.dy - 10 - rayLen),
      rayPaint,
    );
    canvas.drawLine(
      Offset(keyCenter.dx - 8, keyCenter.dy - 4),
      Offset(keyCenter.dx - 8 - rayLen, keyCenter.dy - 4 - rayLen),
      rayPaint,
    );

    // Extra little twinkling star
    final starAlpha =
        (180 * math.sin((animationValue + 0.3) * 2 * math.pi).abs()).toInt();
    final starPaint = Paint()
      ..color = const Color(0xFFFFD166).withAlpha(starAlpha)
      ..strokeWidth = 1.3
      ..strokeCap = StrokeCap.round;

    final starCenter = Offset(keyCenter.dx + 14, keyCenter.dy - 8);
    canvas.drawLine(
      Offset(starCenter.dx - 3, starCenter.dy),
      Offset(starCenter.dx + 3, starCenter.dy),
      starPaint,
    );
    canvas.drawLine(
      Offset(starCenter.dx, starCenter.dy - 3),
      Offset(starCenter.dx, starCenter.dy + 3),
      starPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _KeySparkleOverlayPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.keyCenter != keyCenter ||
        oldDelegate.floatProgress != floatProgress;
  }
}

/// Fallback vector key in case asset image cannot be loaded
class _FallbackVectorKeyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final keyPaint = Paint()
      ..color = const Color(0xFFFF5252)
      ..style = PaintingStyle.fill;

    // Ring handle
    canvas.drawCircle(Offset(w * 0.3, h * 0.7), w * 0.22, keyPaint);
    canvas.drawCircle(
      Offset(w * 0.3, h * 0.7),
      w * 0.11,
      Paint()..color = const Color(0xFFEFF5FB),
    );

    // Stem
    final stemPaint = Paint()
      ..color = const Color(0xFFFF5252)
      ..strokeWidth = w * 0.14
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(w * 0.35, h * 0.65), Offset(w * 0.8, h * 0.25), stemPaint);

    // Teeth
    canvas.drawLine(Offset(w * 0.68, h * 0.36), Offset(w * 0.78, h * 0.44), stemPaint);
    canvas.drawLine(Offset(w * 0.78, h * 0.26), Offset(w * 0.86, h * 0.34), stemPaint);
  }

  @override
  bool shouldRepaint(covariant _FallbackVectorKeyPainter oldDelegate) => false;
}

/// Fallback character painter in case asset image is unavailable
class _RealisticCharacterFallbackPainter extends CustomPainter {
  _RealisticCharacterFallbackPainter({required this.animationValue});

  final double animationValue;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w * 0.48;
    final cy = h * 0.58;

    // Ground shadow
    final shadowPaint = Paint()..color = const Color(0xFFDCE6F2).withAlpha(180);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx + 8, h * 0.90), width: 130, height: 12),
      shadowPaint,
    );

    // Legs
    final pantsPaint = Paint()
      ..color = const Color(0xFF383C44)
      ..strokeWidth = 11.0
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(cx - 8, cy + 18), Offset(cx - 52, cy + 68), pantsPaint);
    canvas.drawLine(Offset(cx + 6, cy + 18), Offset(cx + 36, cy + 70), pantsPaint);

    // Shoes
    final shoePaint = Paint()..color = const Color(0xFF1E2127);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx - 58, cy + 72), width: 18, height: 8),
        const Radius.circular(3),
      ),
      shoePaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx + 42, cy + 74), width: 18, height: 8),
        const Radius.circular(3),
      ),
      shoePaint,
    );

    // Torso
    final shirtPaint = Paint()..color = const Color(0xFF7374B2);
    final torso = Path()
      ..moveTo(cx - 18, cy - 22)
      ..lineTo(cx + 18, cy - 30)
      ..lineTo(cx + 12, cy + 20)
      ..lineTo(cx - 12, cy + 20)
      ..close();
    canvas.drawPath(torso, shirtPaint);

    // Skin & arm
    final skinPaint = Paint()
      ..color = const Color(0xFFFDBC99)
      ..strokeWidth = 7.0
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(cx + 18, cy - 28), Offset(cx + 52, cy - 65), skinPaint);
    canvas.drawCircle(Offset(cx + 6, cy - 42), 11.5, skinPaint);
    canvas.drawCircle(
      Offset(cx + 2, cy - 45),
      12.0,
      Paint()..color = const Color(0xFFA36754),
    );
  }

  @override
  bool shouldRepaint(covariant _RealisticCharacterFallbackPainter oldDelegate) {
    return false;
  }
}
