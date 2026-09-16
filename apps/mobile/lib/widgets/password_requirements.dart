import 'package:flutter/material.dart';
import '../models/password_reset_models.dart';

class PasswordRequirementsWidget extends StatelessWidget {
  const PasswordRequirementsWidget({
    super.key,
    required this.password,
  });

  final String password;

  @override
  Widget build(BuildContext context) {
    final criteria = PasswordCriteria.validate(password);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            'Password Requirements:',
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        _RequirementItem(
          label: 'At least 8 characters',
          isSatisfied: criteria.hasMinLength,
        ),
        const SizedBox(height: 6),
        _RequirementItem(
          label: 'One uppercase letter (A-Z)',
          isSatisfied: criteria.hasUppercase,
        ),
        const SizedBox(height: 6),
        _RequirementItem(
          label: 'One lowercase letter (a-z)',
          isSatisfied: criteria.hasLowercase,
        ),
        const SizedBox(height: 6),
        _RequirementItem(
          label: 'One number (0-9)',
          isSatisfied: criteria.hasNumber,
        ),
        const SizedBox(height: 6),
        _RequirementItem(
          label: 'One special character (!@#\$%^&*...)',
          isSatisfied: criteria.hasSpecialChar,
        ),
      ],
    );
  }
}

class _RequirementItem extends StatelessWidget {
  const _RequirementItem({
    required this.label,
    required this.isSatisfied,
  });

  final String label;
  final bool isSatisfied;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final greenColor = Colors.green.shade600;
    final inactiveColor = theme.colorScheme.onSurfaceVariant.withAlpha(128);

    return Row(
      children: [
        Icon(
          isSatisfied
              ? Icons.check_circle_rounded
              : Icons.radio_button_unchecked_rounded,
          size: 18,
          color: isSatisfied ? greenColor : inactiveColor,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isSatisfied
                  ? theme.colorScheme.onSurface
                  : inactiveColor,
              fontWeight: isSatisfied ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }
}
