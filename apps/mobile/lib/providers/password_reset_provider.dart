import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/password_reset_models.dart';
import '../services/password_reset_service.dart';

final passwordResetRepositoryProvider = Provider<PasswordResetRepository>((ref) {
  // Use MockPasswordResetRepository since backend auth endpoints are not yet deployed.
  // Switch to DioPasswordResetRepository() once backend endpoints are available.
  return MockPasswordResetRepository();
});

final passwordResetProvider =
    StateNotifierProvider<PasswordResetNotifier, PasswordResetState>((ref) {
  final repository = ref.watch(passwordResetRepositoryProvider);
  return PasswordResetNotifier(repository);
});

class PasswordResetNotifier extends StateNotifier<PasswordResetState> {
  PasswordResetNotifier(this._repository) : super(const PasswordResetState());

  final PasswordResetRepository _repository;
  Timer? _timer;

  void setEmail(String email) {
    state = state.copyWith(email: email, clearError: true);
  }

  void setOtp(String otp) {
    state = state.copyWith(otp: otp, clearError: true);
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  void startResendTimer() {
    _timer?.cancel();
    state = state.copyWith(resendCountdown: 30, isResendActive: false);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.resendCountdown <= 1) {
        timer.cancel();
        state = state.copyWith(resendCountdown: 0, isResendActive: true);
      } else {
        state = state.copyWith(
          resendCountdown: state.resendCountdown - 1,
          isResendActive: false,
        );
      }
    });
  }

  Future<bool> sendOtp(String email) async {
    final trimmedEmail = email.trim();
    if (trimmedEmail.isEmpty) {
      state = state.copyWith(
        status: PasswordResetStatus.error,
        errorMessage: 'Email address cannot be empty.',
      );
      return false;
    }

    state = state.copyWith(
      status: PasswordResetStatus.loading,
      email: trimmedEmail,
      clearError: true,
    );

    try {
      await _repository.sendOtp(trimmedEmail);
      state = state.copyWith(status: PasswordResetStatus.success);
      startResendTimer();
      return true;
    } on PasswordResetException catch (e) {
      state = state.copyWith(
        status: PasswordResetStatus.error,
        errorMessage: e.message,
      );
      return false;
    } catch (_) {
      state = state.copyWith(
        status: PasswordResetStatus.error,
        errorMessage: 'Failed to send OTP. Please try again.',
      );
      return false;
    }
  }

  Future<bool> resendOtp() async {
    if (!state.isResendActive) return false;

    state = state.copyWith(
      status: PasswordResetStatus.loading,
      clearError: true,
    );

    try {
      await _repository.sendOtp(state.email);
      state = state.copyWith(status: PasswordResetStatus.success);
      startResendTimer();
      return true;
    } on PasswordResetException catch (e) {
      state = state.copyWith(
        status: PasswordResetStatus.error,
        errorMessage: e.message,
      );
      return false;
    } catch (_) {
      state = state.copyWith(
        status: PasswordResetStatus.error,
        errorMessage: 'Failed to resend OTP. Please try again.',
      );
      return false;
    }
  }

  Future<bool> verifyOtp(String otp) async {
    final trimmedOtp = otp.trim();
    if (trimmedOtp.length != 6) {
      state = state.copyWith(
        status: PasswordResetStatus.error,
        errorMessage: 'Please enter a valid 6-digit OTP.',
      );
      return false;
    }

    state = state.copyWith(
      status: PasswordResetStatus.loading,
      otp: trimmedOtp,
      clearError: true,
    );

    try {
      final token = await _repository.verifyOtp(state.email, trimmedOtp);
      state = state.copyWith(
        status: PasswordResetStatus.success,
        resetToken: token,
      );
      return true;
    } on PasswordResetException catch (e) {
      state = state.copyWith(
        status: PasswordResetStatus.error,
        errorMessage: e.message,
      );
      return false;
    } catch (_) {
      state = state.copyWith(
        status: PasswordResetStatus.error,
        errorMessage: 'Verification failed. Please check your code and try again.',
      );
      return false;
    }
  }

  Future<bool> resetPassword({
    required String newPassword,
    required String confirmPassword,
  }) async {
    final criteria = PasswordCriteria.validate(newPassword);
    if (!criteria.isAllSatisfied) {
      state = state.copyWith(
        status: PasswordResetStatus.error,
        errorMessage: 'Please ensure your password meets all requirements.',
      );
      return false;
    }

    if (newPassword != confirmPassword) {
      state = state.copyWith(
        status: PasswordResetStatus.error,
        errorMessage: 'Passwords do not match.',
      );
      return false;
    }

    state = state.copyWith(
      status: PasswordResetStatus.loading,
      clearError: true,
    );

    try {
      await _repository.resetPassword(
        email: state.email,
        resetToken: state.resetToken,
        newPassword: newPassword,
      );
      state = state.copyWith(status: PasswordResetStatus.success);
      return true;
    } on PasswordResetException catch (e) {
      state = state.copyWith(
        status: PasswordResetStatus.error,
        errorMessage: e.message,
      );
      return false;
    } catch (_) {
      state = state.copyWith(
        status: PasswordResetStatus.error,
        errorMessage: 'Failed to reset password. Please try again.',
      );
      return false;
    }
  }

  void reset() {
    _timer?.cancel();
    state = const PasswordResetState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
