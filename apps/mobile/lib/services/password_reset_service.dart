import 'dart:async';
import 'package:dio/dio.dart';
import 'api_client.dart';

class PasswordResetException implements Exception {
  const PasswordResetException(this.message);
  final String message;

  @override
  String toString() => message;
}

abstract class PasswordResetRepository {
  Future<void> sendOtp(String email);
  Future<String> verifyOtp(String email, String otp);
  Future<void> resetPassword({
    required String email,
    required String resetToken,
    required String newPassword,
  });
}

/// Production-ready Dio repository implementation for backend integration.
/// Pre-configured for:
/// - POST /api/auth/forgot-password
/// - POST /api/auth/verify-otp
/// - POST /api/auth/reset-password
class DioPasswordResetRepository implements PasswordResetRepository {
  DioPasswordResetRepository({ApiClient? client})
      : _dio = client?.raw ?? ApiClient().raw;

  final Dio _dio;

  @override
  Future<void> sendOtp(String email) async {
    try {
      final response = await _dio.post<dynamic>(
        '/auth/forgot-password',
        data: {'email': email.trim()},
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw const PasswordResetException('Failed to send verification OTP. Please try again.');
      }
    } on DioException catch (e) {
      throw PasswordResetException(_handleDioError(e, 'Failed to send OTP. Please check your connection.'));
    } catch (e) {
      if (e is PasswordResetException) rethrow;
      throw const PasswordResetException('An unexpected error occurred. Please try again.');
    }
  }

  @override
  Future<String> verifyOtp(String email, String otp) async {
    try {
      final response = await _dio.post<dynamic>(
        '/auth/verify-otp',
        data: {
          'email': email.trim(),
          'otp': otp.trim(),
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data is Map<String, dynamic> && data['resetToken'] != null) {
          return data['resetToken'] as String;
        }
        return 'verified_token_${DateTime.now().millisecondsSinceEpoch}';
      }
      throw const PasswordResetException('Invalid OTP. Please check the code and try again.');
    } on DioException catch (e) {
      throw PasswordResetException(_handleDioError(e, 'Invalid or expired OTP. Please try again.'));
    } catch (e) {
      if (e is PasswordResetException) rethrow;
      throw const PasswordResetException('Verification failed. Please try again.');
    }
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String resetToken,
    required String newPassword,
  }) async {
    try {
      final response = await _dio.post<dynamic>(
        '/auth/reset-password',
        data: {
          'email': email.trim(),
          'resetToken': resetToken,
          'newPassword': newPassword,
        },
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw const PasswordResetException('Failed to reset password. Please try again.');
      }
    } on DioException catch (e) {
      throw PasswordResetException(_handleDioError(e, 'Unable to reset password. Please try again later.'));
    } catch (e) {
      if (e is PasswordResetException) rethrow;
      throw const PasswordResetException('Failed to reset password. Please try again.');
    }
  }

  String _handleDioError(DioException e, String fallback) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.connectionError) {
      return 'Network connection issue. Please check your internet and try again.';
    }

    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      final msg = data['message'] ?? data['error'];
      if (msg != null && msg is String && msg.isNotEmpty) {
        return msg;
      }
    }
    return fallback;
  }
}

/// Clearly separated mock implementation for demonstration and offline testing.
/// Note: The backend endpoints are currently under construction.
class MockPasswordResetRepository implements PasswordResetRepository {
  MockPasswordResetRepository({this.simulatedDelay = const Duration(milliseconds: 600)});

  final Duration simulatedDelay;
  static const String demoOtp = '123456';

  @override
  Future<void> sendOtp(String email) async {
    await Future<void>.delayed(simulatedDelay);
    if (!email.contains('@') || !email.contains('.')) {
      throw const PasswordResetException('Please provide a valid email address.');
    }
  }

  @override
  Future<String> verifyOtp(String email, String otp) async {
    await Future<void>.delayed(simulatedDelay);
    if (otp == '000000') {
      throw const PasswordResetException('OTP has expired. Please request a new one.');
    }
    // Strictly verify that the entered OTP matches the demo OTP (123456)
    if (otp != demoOtp) {
      throw const PasswordResetException('Invalid OTP. Please enter the exact code shown in the demo tip.');
    }
    return 'mock_reset_token_${DateTime.now().millisecondsSinceEpoch}';
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String resetToken,
    required String newPassword,
  }) async {
    await Future<void>.delayed(simulatedDelay);
    if (newPassword.length < 8) {
      throw const PasswordResetException('Password must be at least 8 characters long.');
    }
  }
}
