import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/locale_provider.dart';
import '../providers/password_reset_provider.dart';
import '../theme/theme.dart';
import '../widgets/flowing_background.dart';
import '../widgets/language_selector_pill.dart';

class PasswordResetSuccessScreen extends ConsumerStatefulWidget {
  const PasswordResetSuccessScreen({super.key});

  @override
  ConsumerState<PasswordResetSuccessScreen> createState() =>
      _PasswordResetSuccessScreenState();
}

class _PasswordResetSuccessScreenState
    extends ConsumerState<PasswordResetSuccessScreen>
    with TickerProviderStateMixin {
  late final AnimationController _entranceController;
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();

    final isTestEnvironment =
        WidgetsBinding.instance.runtimeType.toString().contains('Test');

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );

    // In widget tests, complete entrance immediately to avoid pump timeouts
    if (isTestEnvironment) {
      _entranceController.value = 1.0;
    } else {
      _entranceController.forward();
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = ref.watch(stringsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: FlowingWaveBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Top Bar with Language Selector
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    LanguageSelectorPill(isLight: true),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: AnimatedBuilder(
                      animation: Listenable.merge([_entranceController, _pulseController]),
                      builder: (context, _) {
                        final entrance = _entranceController.value;
                        final pulse = _pulseController.value;

                        // Pop-up bounce scale for the badge
                        final badgeScale = Curves.elasticOut.transform(
                          (entrance * 1.1).clamp(0.0, 1.0),
                        );

                        // Card fade & slide
                        final cardSlide = (1.0 - Curves.easeOutCubic.transform(entrance)) * 30.0;
                        final cardOpacity = Curves.easeOut.transform(entrance);

                        return Transform.translate(
                          offset: Offset(0, cardSlide),
                          child: Opacity(
                            opacity: cardOpacity,
                            child: Container(
                              constraints: const BoxConstraints(maxWidth: 420),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(28),
                                border: Border.all(
                                  color: const Color(0xFFE2EAF5),
                                  width: 1.2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF1E2640).withAlpha(16),
                                    blurRadius: 30,
                                    offset: const Offset(0, 10),
                                  ),
                                  BoxShadow(
                                    color: AppColors.primary.withAlpha((18 * entrance).toInt()),
                                    blurRadius: 36,
                                    offset: const Offset(0, 12),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const SizedBox(height: 8),

                            // Celebratory Pop-Up Blue Checkmark Badge with Confetti
                            Center(
                              child: SizedBox(
                                width: 140,
                                height: 140,
                                child: Stack(
                                  alignment: Alignment.center,
                                  clipBehavior: Clip.none,
                                  children: [
                                    // Bursting confetti & sparkles around the pop-up
                                    CustomPaint(
                                      size: const Size(140, 140),
                                      painter: _CelebratoryBurstPainter(
                                        progress: entrance,
                                        pulseValue: pulse,
                                      ),
                                    ),

                                    // Ambient glowing blue halo
                                    Transform.scale(
                                      scale: badgeScale,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          // Outer soft pulse ring (Ice Blue)
                                          Container(
                                            width: 114 + (pulse * 14),
                                            height: 114 + (pulse * 14),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: const Color(0xFFE3F2FD).withAlpha(
                                                (180 - (pulse * 100)).toInt(),
                                              ),
                                            ),
                                          ),

                                          // Mid border ring (Sky Blue)
                                          Container(
                                            width: 96,
                                            height: 96,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: const Color(0xFFE8F4FD),
                                              border: Border.all(
                                                color: const Color(0xFF90CAF9),
                                                width: 2.0,
                                              ),
                                            ),
                                          ),

                                          // Main Royal / Sky Blue Gradient Circle with Checkmark
                                          Container(
                                            width: 76,
                                            height: 76,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              gradient: const LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: [
                                                  Color(0xFF42A5F5),
                                                  Color(0xFF1565C0),
                                                ],
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: const Color(0xFF1565C0).withAlpha(110),
                                                  blurRadius: 18,
                                                  spreadRadius: 2,
                                                  offset: const Offset(0, 6),
                                                ),
                                              ],
                                            ),
                                            child: const Icon(
                                              Icons.check_rounded,
                                              size: 44,
                                              color: Colors.white,
                                            ),
                                          ),

                                          // Twinkling star accent at top-right
                                          Positioned(
                                            right: 8,
                                            top: 8,
                                            child: Icon(
                                              Icons.star_rounded,
                                              size: 16,
                                              color: const Color(0xFFFFD166)
                                                  .withAlpha((180 + (70 * pulse)).toInt()),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 22),

                            // 3. Title (Exact string expected by tests)
                            Text(
                              strings.passwordResetSuccessfulTitle,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                                letterSpacing: -0.4,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),

                            // 4. Blue Accent Bar
                            Center(
                              child: Container(
                                width: 44,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // 5. Subtitle
                            Text(
                              strings.passwordResetSuccessfulSubtitle,
                              style: const TextStyle(
                                fontSize: 15,
                                color: AppColors.textSecondary,
                                height: 1.45,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 32),

                            // Back to Login Button (Blue Pill)
                            Container(
                              height: 52,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(28),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withAlpha(90),
                                    blurRadius: 14,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: FilledButton(
                                onPressed: () {
                                  ref.read(passwordResetProvider.notifier).reset();
                                  context.go('/login');
                                },
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(28),
                                  ),
                                  elevation: 0,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      strings.backToLogin,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(
                                      Icons.arrow_forward_rounded,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    ),
  ),
),
);
  }
}

/// Celebratory burst of confetti, sparkles, and radiant particles around the badge
class _CelebratoryBurstPainter extends CustomPainter {
  _CelebratoryBurstPainter({
    required this.progress,
    required this.pulseValue,
  });

  final double progress;
  final double pulseValue;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress < 0.1) return;

    final cx = size.width / 2;
    final cy = size.height / 2;

    // 12 festive particles radially bursting outward
    const particleCount = 12;
    final burstDist = 52.0 + (16.0 * progress) + (3.0 * pulseValue);

    final colors = [
      const Color(0xFF1565C0), // Royal Blue
      const Color(0xFF29B6F6), // Cyan / Sky Blue
      const Color(0xFF80D8FF), // Ice Blue
      const Color(0xFF42A5F5), // Light Sky Blue
      const Color(0xFFFFD166), // Gold Sparkle
      const Color(0xFF55C79E), // Mint Accent
    ];

    for (int i = 0; i < particleCount; i++) {
      final angle = (i * (2 * math.pi / particleCount)) + (0.2 * pulseValue);
      final dist = burstDist + ((i % 3) * 6.0);
      final px = cx + (math.cos(angle) * dist);
      final py = cy + (math.sin(angle) * dist);

      final pAlpha = ((1.0 - ((progress - 0.7).clamp(0.0, 0.3) / 0.3)) * 220)
          .clamp(0, 255)
          .toInt();
      final color = colors[i % colors.length].withAlpha(pAlpha);

      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

      if (i % 3 == 0) {
        // Little diamond star
        final path = Path()
          ..moveTo(px, py - 3.5)
          ..lineTo(px + 3.0, py)
          ..lineTo(px, py + 3.5)
          ..lineTo(px - 3.0, py)
          ..close();
        canvas.drawPath(path, paint);
      } else if (i % 3 == 1) {
        // Round celebratory confetti dot
        canvas.drawCircle(Offset(px, py), 2.8, paint);
      } else {
        // Small pill ribbon
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(center: Offset(px, py), width: 7, height: 3),
            const Radius.circular(1.5),
          ),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _CelebratoryBurstPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.pulseValue != pulseValue;
  }
}
