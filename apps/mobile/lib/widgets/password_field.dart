import 'package:flutter/material.dart';
import '../theme/theme.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    required this.controller,
    required this.labelText,
    this.hintText,
    this.errorText,
    this.helperText,
    this.onChanged,
    this.textInputAction = TextInputAction.next,
    this.onFieldSubmitted,
    this.focusNode,
  });

  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final String? errorText;
  final String? helperText;
  final ValueChanged<String>? onChanged;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final FocusNode? focusNode;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      obscureText: _obscureText,
      textInputAction: widget.textInputAction,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onFieldSubmitted,
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        errorText: widget.errorText,
        helperText: widget.helperText,
        prefixIcon: const Icon(
          Icons.lock_outline_rounded,
          color: AppColors.softBlue,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: AppColors.textSecondary,
          ),
          tooltip: _obscureText ? 'Show password' : 'Hide password',
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
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
    );
  }
}
