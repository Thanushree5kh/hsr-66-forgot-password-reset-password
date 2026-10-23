import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/password_reset_models.dart';
import '../providers/locale_provider.dart';
import '../providers/password_reset_provider.dart';
import '../theme/theme.dart';
import '../widgets/flowing_background.dart';
import '../widgets/language_selector_pill.dart';
import '../widgets/password_field.dart';
import '../widgets/password_requirements.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  String _password = '';
  String _confirmPassword = '';

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool get _isPasswordValid => PasswordCriteria.validate(_password).isAllSatisfied;
  bool get _isConfirmMatching =>
      _confirmPassword.isNotEmpty && _password == _confirmPassword;

  bool get _isFormValid => _isPasswordValid && _isConfirmMatching;

  Future<void> _handleResetPassword() async {
    if (!_isFormValid) return;
    FocusScope.of(context).unfocus();

    final success = await ref.read(passwordResetProvider.notifier).resetPassword(
          newPassword: _password,
          confirmPassword: _confirmPassword,
        );

    if (mounted) {
      if (success) {
        context.go('/password-reset-success');
      } else {
        final strings = ref.read(stringsProvider);
        final errorMsg = ref.read(passwordResetProvider).errorMessage ??
            strings.failedToResetPassword;
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
      context.go('/verify-otp');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(passwordResetProvider);
    final strings = ref.watch(stringsProvider);
    final isLoading = state.isLoading;

    final showMismatch =
        _confirmPassword.isNotEmpty && _password != _confirmPassword;
    final showMatch = _confirmPassword.isNotEmpty &&
        _password == _confirmPassword &&
        _isPasswordValid;

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
                          Icons.lock_reset_rounded,
                          color: AppColors.royalBlue,
                          size: 40,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Title
                    Text(
                      strings.createNewPasswordTitle,
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
                        strings.createNewPasswordSubtitle,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFFE1F5FE),
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
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
                          // New Password Field
                          PasswordField(
                            controller: _passwordController,
                            labelText: strings.newPasswordLabel,
                            hintText: strings.newPasswordHint,
                            onChanged: (val) {
                              setState(() {
                                _password = val;
                              });
                            },
                          ),
                          const SizedBox(height: 16),

                          // Confirm Password Field
                          PasswordField(
                            controller: _confirmPasswordController,
                            labelText: strings.confirmPasswordLabel,
                            hintText: strings.confirmPasswordHint,
                            textInputAction: TextInputAction.done,
                            onChanged: (val) {
                              setState(() {
                                _confirmPassword = val;
                              });
                            },
                            onFieldSubmitted: (_) {
                              if (_isFormValid && !isLoading) {
                                _handleResetPassword();
                              }
                            },
                          ),
                          if (showMismatch) ...[
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.cancel_rounded,
                                  size: 16,
                                  color: theme.colorScheme.error,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  strings.passwordsDoNotMatch,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.error,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ] else if (showMatch) ...[
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.check_circle_rounded,
                                  size: 16,
                                  color: Color(0xFF2E7D32),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  strings.passwordsMatch,
                                  style: const TextStyle(
                                    color: Color(0xFF2E7D32),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                          const SizedBox(height: 18),

                          // Requirements Checklist Card
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.cardBackground,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.inputBorder,
                              ),
                            ),
                            child: PasswordRequirementsWidget(password: _password),
                          ),
                          const SizedBox(height: 24),

                          // Reset Password Button (Blue Pill)
                          Container(
                            height: 52,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(28),
                              boxShadow: (_isFormValid && !isLoading)
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
                              onPressed: (_isFormValid && !isLoading)
                                  ? _handleResetPassword
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
                                          strings.resetPasswordButton,
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
