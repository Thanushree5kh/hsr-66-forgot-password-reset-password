import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neet_community/l10n/app_strings.dart';
import 'package:neet_community/providers/locale_provider.dart';
import 'package:neet_community/screens/forgot_password_screen.dart';
import 'package:neet_community/widgets/language_selector_pill.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Localization & Language Switching Tests', () {
    test('1. AppStrings provides correct translations for English and Hindi', () {
      final en = AppStrings.of('en');
      expect(en.forgotPasswordTitle, 'Forgot Password?');
      expect(en.sendOtp, 'Send OTP');
      expect(en.backToSignIn, 'Back to sign in');
      expect(en.backToLogin, 'Back to Login');
      expect(en.verifyOtpTitle, 'Verify OTP');
      expect(en.createNewPasswordTitle, 'Create New Password');
      expect(en.passwordResetSuccessfulTitle, 'Password Reset Successful');

      final hi = AppStrings.of('hi');
      expect(hi.forgotPasswordTitle, 'पासवर्ड भूल गए?');
      expect(hi.sendOtp, 'ओटीपी भेजें');
      expect(hi.backToSignIn, 'साइन इन पर वापस जाएं');
      expect(hi.backToLogin, 'लॉगिन पर वापस जाएं');
      expect(hi.verifyOtpTitle, 'ओटीपी सत्यापित करें');
      expect(hi.createNewPasswordTitle, 'नया पासवर्ड बनाएं');
      expect(hi.passwordResetSuccessfulTitle, 'पासवर्ड रीसेट सफल रहा');
    });

    test('2. LocaleNotifier persists selected language to SharedPreferences', () async {
      final notifier = LocaleNotifier('en');
      expect(notifier.state, 'en');

      await notifier.setLocale('hi');
      expect(notifier.state, 'hi');

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString(kAppLocaleStorageKey), 'hi');

      await notifier.setLocale('en');
      expect(notifier.state, 'en');
      expect(prefs.getString(kAppLocaleStorageKey), 'en');
    });

    testWidgets('3. Screens update reactively when language is changed', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ForgotPasswordScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // In English by default
      expect(find.text('Forgot Password?'), findsOneWidget);
      expect(find.text('Send OTP'), findsOneWidget);
      expect(find.text('Back to sign in'), findsOneWidget);
      expect(find.text('English'), findsOneWidget);

      // Change locale to Hindi via provider container
      final element = tester.element(find.byType(ForgotPasswordScreen));
      final container = ProviderScope.containerOf(element);
      container.read(localeProvider.notifier).setLocale('hi');
      await tester.pumpAndSettle();

      // Now all elements reflect Hindi translations
      expect(find.text('पासवर्ड भूल गए?'), findsOneWidget);
      expect(find.text('ओटीपी भेजें'), findsOneWidget);
      expect(find.text('साइन इन पर वापस जाएं'), findsOneWidget);
      expect(find.text('हिंदी'), findsOneWidget);
    });

    testWidgets('4. LanguageSelectorPill opens bottom sheet and changes language', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Center(
                child: LanguageSelectorPill(),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('English'), findsOneWidget);

      // Tap language selector pill
      await tester.tap(find.byType(LanguageSelectorPill));
      await tester.pumpAndSettle();

      // Modal bottom sheet appears
      expect(find.text('Select Language'), findsOneWidget);
      expect(find.text('Hindi'), findsOneWidget);

      // Tap Hindi option
      await tester.tap(find.text('Hindi'));
      await tester.pumpAndSettle();

      // Pill label updates to Hindi
      expect(find.text('हिंदी'), findsOneWidget);
    });
  });
}
