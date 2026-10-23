import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/locale_provider.dart';
import '../providers/password_reset_provider.dart';
import '../theme/theme.dart';
import '../widgets/flowing_background.dart';
import '../widgets/language_selector_pill.dart';
import '../widgets/otp_input.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  ConsumerState<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  String _otp = '';
  final GlobalKey<OtpInputWidgetState> _otpKey = GlobalKey<OtpInputWidgetState>();

  String _maskEmail(String email) {
    if (!email.contains('@')) return email;
    final parts = email.split('@');
    final username = parts[0];
    final domain = parts[1];

    if (username.length <= 2) {
      return '${username[0]}*@$domain';
    }
    return '${username[0]}${'*' * (username.length - 2)}${username[username.length - 1]}@$domain';
  }

  Future<void> _handleVerifyOtp() async {
    if (_otp.length != 6) return;
    FocusScope.of(context).unfocus();

    final success = await ref.read(passwordResetProvider.notifier).verifyOtp(_otp);

    if (mounted) {
      if (success) {
        context.push('/reset-password');
      } else {
        final strings = ref.read(stringsProvider);
        final errorMsg = ref.read(passwordResetProvider).errorMessage ??
            strings.invalidOtpError;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMsg),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _handleResendOtp() async {
    final success = await ref.read(passwordResetProvider.notifier).resendOtp();

    if (mounted) {
      final strings = ref.read(stringsProvider);
      if (success) {
        _otpKey.currentState?.clear();
        setState(() {
          _otp = '';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(strings.demoOtpBanner),
            backgroundColor: AppColors.primary,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        final errorMsg = ref.read(passwordResetProvider).errorMessage ??
            strings.failedToResendOtp;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMsg),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _handleBack() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/forgot-password');
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(passwordResetProvider);
    final strings = ref.watch(stringsProvider);
    final isLoading = state.isLoading;
    final email = state.email.isNotEmpty ? state.email : strings.yourEmailFallback;
    final maskedEmail = _maskEmail(email);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: FlowingWaveBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Column(
                  children: [
                    // Top Bar: Back to Login (Left) & Language Selector Pill (Right)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: _handleBack,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(45),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withAlpha(60),
                                width: 1,
                              ),
                            ),
                            child: const Icon(
                              Icons.arrow_back_rounded,
                              size: 22,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const LanguageSelectorPill(isLight: true),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Header: Floating Squircle Badge + Title + Subtitle
                    Container(
                      width: 76,
                      height: 76,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(30),
                            blurRadius: 18,
                            offset: const Offset(0, 6),
                          ),
                          BoxShadow(
                            color: AppColors.royalBlue.withAlpha(40),
                            blurRadius: 24,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.mark_email_read_rounded,
                          color: AppColors.royalBlue,
                          size: 40,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Title
                    Text(
                      strings.verifyOtpTitle,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),

                    // Subtitle with highlighted email
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFFE1F5FE),
                            height: 1.4,
                          ),
                          children: [
                            TextSpan(
                              text: strings.verifyOtpSubtitlePrefix,
                            ),
                            TextSpan(
                              text: maskedEmail,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Elevated Floating White Card
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          const BoxShadow(
                            color: Color(0x180D47A1),
                            blurRadius: 30,
                            offset: Offset(0, 12),
                          ),
                          BoxShadow(
                            color: Colors.black.withAlpha(12),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 8),

                          // OTP 6-circle input
                          Center(
                            child: OtpInputWidget(
                              key: _otpKey,
                              onChanged: (val) {
                                setState(() {
                                  _otp = val;
                                });
                                ref.read(passwordResetProvider.notifier).setOtp(val);
                              },
                              onCompleted: (val) {
                                setState(() {
                                  _otp = val;
                                });
                                if (!isLoading) {
                                  _handleVerifyOtp();
                                }
                              },
                            ),
                          ),
                          const SizedBox(height: 22),

                          // Resend OTP & Countdown Timer
                          Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                strings.didntReceiveCode,
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 14,
                                ),
                              ),
                              if (state.isResendActive)
                                TextButton(
                                  onPressed: isLoading ? null : _handleResendOtp,
                                  child: Text(
                                    strings.resendOtp,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.royalBlue,
                                    ),
                                  ),
                                )
                              else
                                Text(
                                  strings.resendInSeconds(state.resendCountdown),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.royalBlue,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Verify OTP Button
                          Container(
                            height: 52,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(28),
                              boxShadow: (_otp.length == 6 && !isLoading)
                                  ? [
                                      BoxShadow(
                                        color: AppColors.royalBlue.withAlpha(85),
                                        blurRadius: 14,
                                        offset: const Offset(0, 5),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: FilledButton(
                              onPressed: (_otp.length == 6 && !isLoading)
                                  ? _handleVerifyOtp
                                  : null,
                              style: FilledButton.styleFrom(
                                backgroundColor: AppColors.royalBlue,
                                foregroundColor: Colors.white,
                                disabledBackgroundColor: AppColors.royalBlue.withAlpha(90),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28),
                                ),
                                elevation: 0,
                              ),
                              child: isLoading
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          strings.verifyOtpButton,
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
                          const SizedBox(height: 20),

                          // Tip Card matching the design with Demo Mode info
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.cardBackground,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.inputBorder,
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.lightbulb_outline_rounded,
                                  color: AppColors.softBlue,
                                  size: 22,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        strings.tipDemoModeTitle,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      RichText(
                                        text: TextSpan(
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: AppColors.textSecondary,
                                            height: 1.4,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: strings.tipDemoModeTextPrefix,
                                            ),
                                            const TextSpan(
                                              text: '123456',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.royalBlue,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
