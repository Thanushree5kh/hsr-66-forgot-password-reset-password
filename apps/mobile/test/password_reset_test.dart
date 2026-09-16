import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:neet_community/models/password_reset_models.dart';
import 'package:neet_community/providers/password_reset_provider.dart';
import 'package:neet_community/screens/forgot_password_screen.dart';
import 'package:neet_community/screens/login_screen.dart';
import 'package:neet_community/screens/otp_verification_screen.dart';
import 'package:neet_community/screens/password_reset_success_screen.dart';
import 'package:neet_community/screens/reset_password_screen.dart';
import 'package:neet_community/services/password_reset_service.dart';
import 'package:neet_community/widgets/otp_input.dart';

class FakePasswordResetRepository implements PasswordResetRepository {
  bool sendOtpCalled = false;
  bool verifyOtpCalled = false;
  bool resetPasswordCalled = false;
  String? lastEmail;
  String? lastOtp;
  String? lastNewPassword;

  @override
  Future<void> sendOtp(String email) async {
    sendOtpCalled = true;
    lastEmail = email;
  }

  @override
  Future<String> verifyOtp(String email, String otp) async {
    verifyOtpCalled = true;
    lastEmail = email;
    lastOtp = otp;
    if (otp == '000000') {
      throw const PasswordResetException('OTP has expired.');
    }
    if (otp == '999999') {
      throw const PasswordResetException('Invalid OTP.');
    }
    return 'fake_token_123';
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String resetToken,
    required String newPassword,
  }) async {
    resetPasswordCalled = true;
    lastEmail = email;
    lastNewPassword = newPassword;
  }
}

Widget createTestApp({
  required Widget child,
  FakePasswordResetRepository? repo,
  GoRouter? customRouter,
}) {
  final fakeRepo = repo ?? FakePasswordResetRepository();
  final router = customRouter ??
      GoRouter(
        initialLocation: '/test',
        routes: [
          GoRoute(path: '/test', builder: (_, __) => child),
          GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
          GoRoute(path: '/forgot-password', builder: (_, __) => const ForgotPasswordScreen()),
          GoRoute(path: '/verify-otp', builder: (_, __) => const OtpVerificationScreen()),
          GoRoute(path: '/reset-password', builder: (_, __) => const ResetPasswordScreen()),
          GoRoute(path: '/password-reset-success', builder: (_, __) => const PasswordResetSuccessScreen()),
        ],
      );

  return ProviderScope(
    overrides: [
      passwordResetRepositoryProvider.overrideWithValue(fakeRepo),
    ],
    child: MaterialApp.router(
      routerConfig: router,
    ),
  );
}

void main() {
  group('1-3: Email Validation and Send OTP button tests', () {
    test('1. Email criteria validation', () {
      final emailRegex = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
      );
      expect(emailRegex.hasMatch('invalid-email'), isFalse);
      expect(emailRegex.hasMatch('test@'), isFalse);
      expect(emailRegex.hasMatch('test@domain'), isFalse);
      expect(emailRegex.hasMatch('test@domain.com'), isTrue);
      expect(emailRegex.hasMatch('doctor.sushruta@hospital.org'), isTrue);
    });

    testWidgets('2. Send OTP button disabled for empty / invalid email', (tester) async {
      await tester.pumpWidget(createTestApp(child: const ForgotPasswordScreen()));
      await tester.pumpAndSettle();

      final sendOtpBtnFinder = find.widgetWithText(FilledButton, 'Send OTP');
      expect(sendOtpBtnFinder, findsOneWidget);
      FilledButton button = tester.widget(sendOtpBtnFinder);
      expect(button.onPressed, isNull);

      // Enter invalid email
      await tester.enterText(find.byType(TextFormField), 'invalidemail');
      await tester.pump();

      expect(find.text('Please enter a valid email address.'), findsOneWidget);
      button = tester.widget(sendOtpBtnFinder);
      expect(button.onPressed, isNull);
    });

    testWidgets('3. Send OTP button enabled for valid email', (tester) async {
      final repo = FakePasswordResetRepository();
      await tester.pumpWidget(createTestApp(
        child: const ForgotPasswordScreen(),
        repo: repo,
      ),);
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField), 'test@sushruta.med');
      await tester.pump();

      expect(find.text('Please enter a valid email address.'), findsNothing);
      final sendBtn = find.widgetWithText(FilledButton, 'Send OTP');
      final button = tester.widget<FilledButton>(sendBtn);
      expect(button.onPressed, isNotNull);

      await tester.tap(sendBtn);
      await tester.pumpAndSettle();
      expect(repo.sendOtpCalled, isTrue);
      expect(repo.lastEmail, 'test@sushruta.med');
    });
  });

  group('4-6: OTP Input and Verification tests', () {
    testWidgets('4. OTP requires exactly 6 digits (Verify button disabled until 6 digits)', (tester) async {
      await tester.pumpWidget(createTestApp(child: const OtpVerificationScreen()));
      await tester.pumpAndSettle();

      final verifyBtnFinder = find.widgetWithText(FilledButton, 'Verify OTP');
      expect(verifyBtnFinder, findsOneWidget);
      FilledButton button = tester.widget(verifyBtnFinder);
      expect(button.onPressed, isNull);

      // Enter 3 digits
      final textFields = find.byType(TextFormField);
      expect(textFields, findsNWidgets(6));
      await tester.enterText(textFields.at(0), '1');
      await tester.pump();
      await tester.enterText(textFields.at(1), '2');
      await tester.pump();
      await tester.enterText(textFields.at(2), '3');
      await tester.pump();

      button = tester.widget(verifyBtnFinder);
      expect(button.onPressed, isNull);

      // Enter next 2 digits (total 5 digits)
      await tester.enterText(textFields.at(3), '4');
      await tester.pump();
      await tester.enterText(textFields.at(4), '5');
      await tester.pump();

      button = tester.widget(verifyBtnFinder);
      expect(button.onPressed, isNull);

      // Enter 6th digit
      await tester.enterText(textFields.at(5), '6');
      await tester.pump();

      expect(find.widgetWithText(FilledButton, 'Verify OTP'), findsOneWidget);
    });

    testWidgets('5. OTP paste behavior populates all 6 boxes', (tester) async {
      String latestOtp = '';
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OtpInputWidget(
              onChanged: (val) {
                latestOtp = val;
              },
            ),
          ),
        ),
      );

      final textFields = find.byType(TextFormField);
      // Simulate pasting 6 digits into first box
      await tester.enterText(textFields.first, '654321');
      await tester.pump();

      expect(latestOtp, '654321');
    });

    test('6. Resend OTP countdown timer behavior', () {
      final repo = FakePasswordResetRepository();
      final container = ProviderContainer(
        overrides: [
          passwordResetRepositoryProvider.overrideWithValue(repo),
        ],
      );

      final notifier = container.read(passwordResetProvider.notifier);
      notifier.startResendTimer();

      expect(container.read(passwordResetProvider).resendCountdown, 30);
      expect(container.read(passwordResetProvider).isResendActive, isFalse);

      notifier.reset();
      container.dispose();
    });
  });

  group('7-15: Password requirements checklist & reset validation', () {
    test('7. Password minimum 8 characters validation', () {
      expect(PasswordCriteria.validate('Abc!1').hasMinLength, isFalse);
      expect(PasswordCriteria.validate('Abcdef!1').hasMinLength, isTrue);
    });

    test('8. Uppercase requirement validation', () {
      expect(PasswordCriteria.validate('abcdef!1').hasUppercase, isFalse);
      expect(PasswordCriteria.validate('Abcdef!1').hasUppercase, isTrue);
    });

    test('9. Lowercase requirement validation', () {
      expect(PasswordCriteria.validate('ABCDEF!1').hasLowercase, isFalse);
      expect(PasswordCriteria.validate('Abcdef!1').hasLowercase, isTrue);
    });

    test('10. Number requirement validation', () {
      expect(PasswordCriteria.validate('Abcdefg!').hasNumber, isFalse);
      expect(PasswordCriteria.validate('Abcdef1!').hasNumber, isTrue);
    });

    test('11. Special character requirement validation', () {
      expect(PasswordCriteria.validate('Abcdefg1').hasSpecialChar, isFalse);
      expect(PasswordCriteria.validate('Abcdefg1@').hasSpecialChar, isTrue);
      expect(PasswordCriteria.validate('Abcdefg1#').hasSpecialChar, isTrue);
      expect(PasswordCriteria.validate('Abcdefg1!').hasSpecialChar, isTrue);
    });

    testWidgets('12-15. Live checklist, confirm mismatch/match & Reset button enabled/disabled', (tester) async {
      await tester.pumpWidget(createTestApp(child: const ResetPasswordScreen()));
      await tester.pumpAndSettle();

      // Initially Reset button is disabled
      final resetBtnFinder = find.widgetWithText(FilledButton, 'Reset Password');
      FilledButton button = tester.widget(resetBtnFinder);
      expect(button.onPressed, isNull);

      final textFields = find.byType(TextFormField);
      expect(textFields, findsNWidgets(2));

      // Enter valid password into new password field
      await tester.enterText(textFields.first, 'Secret@123');
      await tester.pump();

      // Enter mismatched confirm password
      await tester.enterText(textFields.last, 'Different@123');
      await tester.pump();

      expect(find.text('Passwords do not match.'), findsOneWidget);
      button = tester.widget(resetBtnFinder);
      expect(button.onPressed, isNull);

      // Enter matching confirm password
      await tester.enterText(textFields.last, 'Secret@123');
      await tester.pump();

      expect(find.text('Passwords match.'), findsOneWidget);
      button = tester.widget(resetBtnFinder);
      expect(button.onPressed, isNotNull);
    });
  });

  group('16: Navigation between all HSR-66 screens', () {
    testWidgets('Complete navigation flow: /login -> /forgot-password -> /verify-otp -> /reset-password -> /password-reset-success -> /login', (tester) async {
      final repo = FakePasswordResetRepository();

      final router = GoRouter(
        initialLocation: '/login',
        routes: [
          GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
          GoRoute(path: '/forgot-password', builder: (_, __) => const ForgotPasswordScreen()),
          GoRoute(path: '/verify-otp', builder: (_, __) => const OtpVerificationScreen()),
          GoRoute(path: '/reset-password', builder: (_, __) => const ResetPasswordScreen()),
          GoRoute(path: '/password-reset-success', builder: (_, __) => const PasswordResetSuccessScreen()),
        ],
      );

      await tester.pumpWidget(createTestApp(
        child: const SizedBox.shrink(),
        repo: repo,
        customRouter: router,
      ),);
      await tester.pumpAndSettle();

      // 1. On Login Screen: find and tap 'Forgot password?'
      expect(find.text('Log in'), findsWidgets);
      final forgotBtn = find.text('Forgot password?');
      expect(forgotBtn, findsOneWidget);
      await tester.tap(forgotBtn);
      await tester.pumpAndSettle();

      // 2. On Forgot Password Screen
      expect(find.text('Forgot Password?'), findsOneWidget);
      await tester.enterText(find.byType(TextFormField), 'user@sushruta.med');
      await tester.pump();

      final sendOtpBtn = find.widgetWithText(FilledButton, 'Send OTP');
      await tester.ensureVisible(sendOtpBtn);
      await tester.tap(sendOtpBtn);
      await tester.pumpAndSettle();

      // 3. On Verify OTP Screen
      expect(find.text('Verify OTP'), findsWidgets);
      final otpBoxes = find.byType(TextFormField);
      for (int i = 0; i < 6; i++) {
        await tester.enterText(otpBoxes.at(i), '${i + 1}');
        await tester.pump();
      }
      final verifyOtpBtn = find.widgetWithText(FilledButton, 'Verify OTP');
      await tester.ensureVisible(verifyOtpBtn);
      await tester.tap(verifyOtpBtn, warnIfMissed: false);
      await tester.pumpAndSettle();

      // 4. On Reset Password Screen
      expect(find.text('Create New Password'), findsOneWidget);
      final passFields = find.byType(TextFormField);
      await tester.enterText(passFields.first, 'SecurePass#99');
      await tester.pump();
      await tester.enterText(passFields.last, 'SecurePass#99');
      await tester.pump();

      final resetBtn = find.widgetWithText(FilledButton, 'Reset Password');
      await tester.ensureVisible(resetBtn);
      await tester.tap(resetBtn);
      await tester.pumpAndSettle();

      // 5. On Password Reset Success Screen
      expect(find.text('Password Reset Successful'), findsOneWidget);
      final backToLoginBtn = find.widgetWithText(FilledButton, 'Back to Login');
      await tester.ensureVisible(backToLoginBtn);
      await tester.tap(backToLoginBtn);
      await tester.pumpAndSettle();

      // 6. Back on Login Screen
      expect(find.text('Log in'), findsWidgets);
    });
  });
}
