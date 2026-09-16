import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/password_reset_models.dart';
import '../providers/password_reset_provider.dart';
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
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/verify-otp');
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
                    Icons.lock_reset_rounded,
                    size: 38,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Create New Password',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Your new password must be unique and satisfy all security criteria.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

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

              // Reusable Password Requirements Checklist
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withAlpha(80),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.outlineVariant.withAlpha(128),
                  ),
                ),
                child: PasswordRequirementsWidget(password: _password),
              ),
              const SizedBox(height: 20),

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
                Row(
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      size: 16,
                      color: Colors.green.shade600,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Passwords match.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.green.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 32),

              // Reset Password Button
              SizedBox(
                height: 52,
                child: FilledButton(
                  onPressed: (_isFormValid && !isLoading)
                      ? _handleResetPassword
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
                          'Reset Password',
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
