import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/password_reset_models.dart';
import '../providers/locale_provider.dart';
import '../theme/theme.dart';

class PasswordRequirementsWidget extends ConsumerWidget {
  const PasswordRequirementsWidget({
    super.key,
    required this.password,
  });

  final String password;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final criteria = PasswordCriteria.validate(password);
    final theme = Theme.of(context);
    final strings = ref.watch(stringsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            strings.passwordMustContain,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              fontSize: 13,
            ),
          ),
        ),
        _RequirementItem(
          label: strings.reqMinLength,
          isSatisfied: criteria.hasMinLength,
        ),
        const SizedBox(height: 8),
        _RequirementItem(
          label: strings.reqUppercase,
          isSatisfied: criteria.hasUppercase,
        ),
        const SizedBox(height: 8),
        _RequirementItem(
          label: strings.reqLowercase,
          isSatisfied: criteria.hasLowercase,
        ),
        const SizedBox(height: 8),
        _RequirementItem(
          label: strings.reqNumber,
          isSatisfied: criteria.hasNumber,
        ),
        const SizedBox(height: 8),
        _RequirementItem(
          label: strings.reqSpecialChar,
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
    const satisfiedColor = Color(0xFF2E7D32);
    const inactiveColor = Color(0xFF9CA3AF);

    return AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 200),
      style: theme.textTheme.bodyMedium!.copyWith(
        color: isSatisfied ? AppColors.textPrimary : inactiveColor,
        fontWeight: isSatisfied ? FontWeight.w500 : FontWeight.normal,
        fontSize: 13.5,
      ),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            child: Icon(
              isSatisfied
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked_rounded,
              size: 18,
              color: isSatisfied ? satisfiedColor : inactiveColor,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(label),
          ),
        ],
      ),
    );
  }
}
