import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/password_reset_provider.dart';
import '../theme/theme.dart';
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
        final errorMsg = ref.read(passwordResetProvider).errorMessage ??
            'Invalid OTP. Please check the code and try again.';
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
      if (success) {
        _otpKey.currentState?.clear();
        setState(() {
          _otp = '';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Demo OTP: 123456 (Check the tip card below)'),
            backgroundColor: AppColors.primary,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        final errorMsg = ref.read(passwordResetProvider).errorMessage ??
            'Failed to resend OTP. Please try again.';
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
    final isLoading = state.isLoading;
    final email = state.email.isNotEmpty ? state.email : 'your email';
    final maskedEmail = _maskEmail(email);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar: Back to Login
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Row(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: _handleBack,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.arrow_back_rounded,
                            size: 20,
                            color: AppColors.textPrimary,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Back to Login',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 440),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: const Color(0xFFE2EAF5),
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF1E2640).withAlpha(14),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 6),

                          // Title (Left-aligned matching other application pages)
                          const Text(
                            'Verify OTP',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 6),

                          // Coral Red Accent Underline Bar
                          Align(
                            alignment: Alignment.centerLeft,
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

                          // Subtitle with highlighted email
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 14.5,
                                color: AppColors.textSecondary,
                                height: 1.5,
                              ),
                              children: [
                                const TextSpan(
                                  text: 'Enter the 6-digit verification code sent to\n',
                                ),
                                TextSpan(
                                  text: maskedEmail,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 28),

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
                              const Text(
                                "Didn't receive the code? ",
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 14,
                                ),
                              ),
                              if (state.isResendActive)
                                TextButton(
                                  onPressed: isLoading ? null : _handleResendOtp,
                                  child: const Text(
                                    'Resend OTP',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                )
                              else
                                Text(
                                  'Resend in ${state.resendCountdown}s',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
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
                                        color: AppColors.primary.withAlpha(90),
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
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                disabledBackgroundColor: AppColors.primary.withAlpha(90),
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
                                  : const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Verify OTP',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Icon(
                                          Icons.arrow_forward_rounded,
                                          size: 20,
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                          const SizedBox(height: 22),

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
                                      const Text(
                                        'Tip (Demo Mode)',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      RichText(
                                        text: const TextSpan(
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: AppColors.textSecondary,
                                            height: 1.4,
                                          ),
                                          children: [
                                            TextSpan(
                                              text:
                                                  'Check your spam folder if needed. For testing before backend deployment, use Demo OTP: ',
                                            ),
                                            TextSpan(
                                              text: '123456',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.primary,
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
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
