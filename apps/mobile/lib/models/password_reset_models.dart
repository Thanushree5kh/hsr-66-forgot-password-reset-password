import 'package:flutter/foundation.dart';

/// Live validation criteria for password strength checklist.
@immutable
class PasswordCriteria {
  const PasswordCriteria({
    required this.hasMinLength,
    required this.hasUppercase,
    required this.hasLowercase,
    required this.hasNumber,
    required this.hasSpecialChar,
  });

  final bool hasMinLength;
  final bool hasUppercase;
  final bool hasLowercase;
  final bool hasNumber;
  final bool hasSpecialChar;

  bool get isAllSatisfied =>
      hasMinLength &&
      hasUppercase &&
      hasLowercase &&
      hasNumber &&
      hasSpecialChar;

  factory PasswordCriteria.validate(String password) {
    return PasswordCriteria(
      hasMinLength: password.length >= 8,
      hasUppercase: RegExp(r'[A-Z]').hasMatch(password),
      hasLowercase: RegExp(r'[a-z]').hasMatch(password),
      hasNumber: RegExp(r'[0-9]').hasMatch(password),
      hasSpecialChar: RegExp(r'[!@#\$%^&*(),.?":{}|<>\-_+=\/\\\[\];`~]').hasMatch(password),
    );
  }

  static const initial = PasswordCriteria(
    hasMinLength: false,
    hasUppercase: false,
    hasLowercase: false,
    hasNumber: false,
    hasSpecialChar: false,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PasswordCriteria &&
          runtimeType == other.runtimeType &&
          hasMinLength == other.hasMinLength &&
          hasUppercase == other.hasUppercase &&
          hasLowercase == other.hasLowercase &&
          hasNumber == other.hasNumber &&
          hasSpecialChar == other.hasSpecialChar;

  @override
  int get hashCode =>
      hasMinLength.hashCode ^
      hasUppercase.hashCode ^
      hasLowercase.hashCode ^
      hasNumber.hashCode ^
      hasSpecialChar.hashCode;
}

enum PasswordResetStatus {
  initial,
  loading,
  success,
  error,
}

@immutable
class PasswordResetState {
  const PasswordResetState({
    this.status = PasswordResetStatus.initial,
    this.email = '',
    this.otp = '',
    this.resetToken = '',
    this.errorMessage,
    this.resendCountdown = 30,
    this.isResendActive = false,
  });

  final PasswordResetStatus status;
  final String email;
  final String otp;
  final String resetToken;
  final String? errorMessage;
  final int resendCountdown;
  final bool isResendActive;

  bool get isLoading => status == PasswordResetStatus.loading;
  bool get isSuccess => status == PasswordResetStatus.success;
  bool get isError => status == PasswordResetStatus.error;

  PasswordResetState copyWith({
    PasswordResetStatus? status,
    String? email,
    String? otp,
    String? resetToken,
    String? errorMessage,
    bool clearError = false,
    int? resendCountdown,
    bool? isResendActive,
  }) {
    return PasswordResetState(
      status: status ?? this.status,
      email: email ?? this.email,
      otp: otp ?? this.otp,
      resetToken: resetToken ?? this.resetToken,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      resendCountdown: resendCountdown ?? this.resendCountdown,
      isResendActive: isResendActive ?? this.isResendActive,
    );
  }
}
