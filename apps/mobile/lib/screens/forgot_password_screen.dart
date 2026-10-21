import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/password_reset_provider.dart';
import '../theme/theme.dart';
import '../widgets/flowing_background.dart';
import '../widgets/forgot_password_hero.dart';
import '../widgets/neet_logo.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  late final TextEditingController _emailController;
  final _formKey = GlobalKey<FormState>();
  String? _emailError;
  bool _isEmailValid = false;

  final RegExp _emailRegex = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );

  @override
  void initState() {
    super.initState();
    final currentEmail = ref.read(passwordResetProvider).email;
    _emailController = TextEditingController(text: currentEmail);
    _validateEmail(currentEmail);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _validateEmail(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      setState(() {
        _isEmailValid = false;
        _emailError = null;
      });
    } else if (!_emailRegex.hasMatch(trimmed)) {
      setState(() {
        _isEmailValid = false;
        _emailError = 'Please enter a valid email address.';
      });
    } else {
      setState(() {
        _isEmailValid = true;
        _emailError = null;
      });
    }
  }

  Future<void> _handleSendOtp() async {
    if (!_isEmailValid) return;
    FocusScope.of(context).unfocus();

    final email = _emailController.text.trim();
    final success = await ref.read(passwordResetProvider.notifier).sendOtp(email);

    if (mounted) {
      if (success) {
        context.push('/verify-otp');
      } else {
        final errorMsg = ref.read(passwordResetProvider).errorMessage ??
            'Failed to send OTP. Please try again.';
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
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(passwordResetProvider);
    final isLoading = state.isLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: FlowingWaveBackground(
        child: SafeArea(
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
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
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
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
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
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // NEET Community Logo (Top Left matching image)
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: NeetCommunityLogo(scale: 0.88),
                              ),
                              const SizedBox(height: 10),

                              // Hero Illustration: Realistic character + floating key safely IN FRAME + animated extras
                              const ForgotPasswordHeroIllustration(height: 160),
                              const SizedBox(height: 14),

                              // "Forgot Password?" Heading in bold deep navy
                              const Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.textPrimary,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 6),

                              // Signature Coral Red Accent Underline Bar (from uploaded image)
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
                              const SizedBox(height: 10),

                              // Subtitle with comfortable, breathable line height
                              const Text(
                                'Enter your registered email to get back to your NEET prep community.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                  height: 1.45,
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Email Input Field (Matching image style)
                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.done,
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Email Address',
                                  hintText: 'Enter your registered email',
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.mail_outline_rounded,
                                    color: AppColors.softBlue,
                                  ),
                                  errorText: _emailError,
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(color: AppColors.inputBorder),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(color: AppColors.inputBorder),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(
                                      color: AppColors.softBlue,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                onChanged: (val) {
                                  _validateEmail(val);
                                  ref.read(passwordResetProvider.notifier).setEmail(val.trim());
                                },
                                onFieldSubmitted: (_) {
                                  if (_isEmailValid && !isLoading) {
                                    _handleSendOtp();
                                  }
                                },
                              ),
                              const SizedBox(height: 16),

                              // Vibrant Coral Red Pill Button with soft glow drop shadow
                              Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(28),
                                  boxShadow: (_isEmailValid && !isLoading)
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
                                  onPressed: (_isEmailValid && !isLoading)
                                      ? _handleSendOtp
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
                                              'Send OTP',
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
                              const SizedBox(height: 16),

                              // Back to Login Link
                              Wrap(
                                alignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text(
                                    'Remember your password? ',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () => context.go('/login'),
                                    child: const Text(
                                      'Log in',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
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
