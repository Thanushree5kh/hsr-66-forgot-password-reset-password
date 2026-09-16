import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/password_reset_provider.dart';
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
          SnackBar(
            content: const Text('A new 6-digit OTP has been sent to your email.'),
            backgroundColor: Theme.of(context).colorScheme.primary,
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(passwordResetProvider);
    final isLoading = state.isLoading;
    final email = state.email.isNotEmpty ? state.email : 'your email';
    final maskedEmail = _maskEmail(email);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/forgot-password');
            }
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              Center(
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer.withAlpha(128),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.mark_email_read_outlined,
                    size: 38,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Verify OTP',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                  children: [
                    const TextSpan(text: 'Enter the 6-digit verification code sent to\n'),
                    TextSpan(
                      text: maskedEmail,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // OTP Input Widget
              OtpInputWidget(
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
              const SizedBox(height: 24),

              // Resend OTP & Countdown Timer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't receive the code? ",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (state.isResendActive)
                    TextButton(
                      onPressed: isLoading ? null : _handleResendOtp,
                      child: const Text(
                        'Resend OTP',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  else
                    Text(
                      'Resend in ${state.resendCountdown}s',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 24),

              // Verify OTP Button
              SizedBox(
                height: 52,
                child: FilledButton(
                  onPressed: (_otp.length == 6 && !isLoading)
                      ? _handleVerifyOtp
                      : null,
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isLoading
                      ? SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: theme.colorScheme.onPrimary,
                          ),
                        )
                      : const Text(
                          'Verify OTP',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
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
