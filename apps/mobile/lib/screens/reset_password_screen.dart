import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/password_reset_models.dart';
import '../providers/password_reset_provider.dart';
import '../theme/theme.dart';
import '../widgets/flowing_background.dart';
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
        final errorMsg = ref.read(passwordResetProvider).errorMessage ??
            'Failed to reset password. Please try again.';
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
                        const SizedBox(height: 8),

                        // Title
                        const Text(
                          'Create New Password',
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
                            width: 48,
                            height: 4,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        const Text(
                          'Your new password must be different from your previous password.',
                          style: TextStyle(
                            fontSize: 14.5,
                            color: AppColors.textSecondary,
                            height: 1.45,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // New Password Field
                        PasswordField(
                          controller: _passwordController,
                          labelText: 'New Password',
                          hintText: 'Enter new password',
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
                          labelText: 'Confirm Password',
                          hintText: 'Re-enter new password',
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
                                'Passwords do not match.',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.error,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ] else if (showMatch) ...[
                          const SizedBox(height: 8),
                          const Row(
                            children: [
                              Icon(
                                Icons.check_circle_rounded,
                                size: 16,
                                color: Color(0xFF2E7D32),
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Passwords match.',
                                style: TextStyle(
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

                        // Reset Password Button (Coral Red Pill)
                        Container(
                          height: 52,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: (_isFormValid && !isLoading)
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
                            onPressed: (_isFormValid && !isLoading)
                                ? _handleResetPassword
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
                                        'Reset Password',
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
                        const SizedBox(height: 20),

                        // Motivation Card from design
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: AppColors.cardBackground,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.inputBorder,
                            ),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.insights_rounded,
                                color: AppColors.softBlue,
                                size: 22,
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  "You're one step closer to your dream.",
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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
      ),
    );
  }
}
