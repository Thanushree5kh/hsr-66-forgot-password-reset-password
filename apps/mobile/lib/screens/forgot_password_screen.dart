import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/locale_provider.dart';
import '../providers/password_reset_provider.dart';
import '../theme/theme.dart';
import '../widgets/flowing_background.dart';
import '../widgets/language_selector_pill.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _emailController;
  late final AnimationController _badgeAnimController;
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

    _badgeAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    final isTestEnvironment =
        WidgetsBinding.instance.runtimeType.toString().contains('Test');
    if (!isTestEnvironment) {
      _badgeAnimController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _badgeAnimController.dispose();
    super.dispose();
  }

  void _validateEmail(String value) {
    final trimmed = value.trim();
    final strings = ref.read(stringsProvider);
    if (trimmed.isEmpty) {
      setState(() {
        _isEmailValid = false;
        _emailError = null;
      });
    } else if (!_emailRegex.hasMatch(trimmed)) {
      setState(() {
        _isEmailValid = false;
        _emailError = strings.emailValidationError;
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

    final strings = ref.read(stringsProvider);
    final email = _emailController.text.trim();
    final success = await ref.read(passwordResetProvider.notifier).sendOtp(email);

    if (mounted) {
      if (success) {
        context.push('/verify-otp');
      } else {
        final errorMsg = ref.read(passwordResetProvider).errorMessage ??
            strings.failedToSendOtp;
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
    final state = ref.watch(passwordResetProvider);
    final strings = ref.watch(stringsProvider);
    final isLoading = state.isLoading;

    return Scaffold(
      body: FlowingWaveBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Column(
                  children: [
                    // 1. Top Bar: Back button (left) & Language Selector Pill (right)
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
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                        const LanguageSelectorPill(isLight: true),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // 2. Header: Floating Squircle Lock Badge + Title + Subtitle
                    _buildFloatingLockBadge(),
                    const SizedBox(height: 14),

                    // Title
                    Text(
                      strings.forgotPasswordTitle,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),

                    // Subtitle
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        strings.forgotPasswordSubtitle,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFFE1F5FE),
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 3. Elevated Floating White Card (Matches Image 1 Exactly)
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
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 26),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Outer Label matching screenshot
                            Text(
                              strings.emailAddressLabel,
                              style: const TextStyle(
                                color: AppColors.royalBlue,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Email Address Input Field with '@' Icon
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) => _handleSendOtp(),
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: InputDecoration(
                                hintText: strings.emailAddressHint,
                                prefixIcon: const Icon(
                                  Icons.alternate_email_rounded,
                                  color: AppColors.royalBlue,
                                  size: 20,
                                ),
                                errorText: _emailError,
                                filled: true,
                                fillColor: const Color(0xFFFBFDFF),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 15,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFBBDEFB),
                                    width: 1.5,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(
                                    color: _isEmailValid
                                        ? AppColors.skyBlue
                                        : const Color(0xFFBBDEFB),
                                    width: 1.5,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(
                                    color: AppColors.royalBlue,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              onChanged: _validateEmail,
                            ),
                            const SizedBox(height: 22),

                            // Send OTP Button in Royal Blue with Paper-Plane Send Icon
                            Container(
                              height: 52,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: (_isEmailValid && !isLoading)
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
                                onPressed:
                                    (_isEmailValid && !isLoading) ? _handleSendOtp : null,
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.royalBlue,
                                  foregroundColor: Colors.white,
                                  disabledBackgroundColor:
                                      AppColors.royalBlue.withAlpha(90),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
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
                                          const Icon(
                                            Icons.send_rounded,
                                            size: 18,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            strings.sendOtp,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Back to sign in link
                            Center(
                              child: InkWell(
                                onTap: _handleBack,
                                borderRadius: BorderRadius.circular(10),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.arrow_back_rounded,
                                        size: 18,
                                        color: AppColors.royalBlue,
                                      ),
                                      const SizedBox(width: 6),
                                      Flexible(
                                        child: Text(
                                          strings.backToSignIn,
                                          style: const TextStyle(
                                            color: AppColors.royalBlue,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14.5,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
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

  /// White squircle lock badge with blue reload/reset lock icon
  Widget _buildFloatingLockBadge() {
    return AnimatedBuilder(
      animation: _badgeAnimController,
      builder: (context, _) {
        final floatBob =
            math.sin(_badgeAnimController.value * 2 * math.pi) * 3.5;

        return Transform.translate(
          offset: Offset(0, floatBob),
          child: Container(
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
                Icons.lock_reset_rounded,
                color: AppColors.royalBlue,
                size: 42,
              ),
            ),
          ),
        );
      },
    );
  }
}
