import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'providers/locale_provider.dart';
import 'screens/dashboard_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/login_screen.dart';
import 'screens/otp_verification_screen.dart';
import 'screens/password_reset_success_screen.dart';
import 'screens/register_screen.dart';
import 'screens/reset_password_screen.dart';
import 'theme/theme.dart';

final _router = GoRouter(
  initialLocation: '/forgot-password',
  routes: [
    GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
    GoRoute(path: '/register', builder: (_, __) => const RegisterScreen()),
    GoRoute(path: '/dashboard', builder: (_, __) => const DashboardScreen()),
    GoRoute(path: '/forgot-password', builder: (_, __) => const ForgotPasswordScreen()),
    GoRoute(path: '/verify-otp', builder: (_, __) => const OtpVerificationScreen()),
    GoRoute(path: '/reset-password', builder: (_, __) => const ResetPasswordScreen()),
    GoRoute(path: '/password-reset-success', builder: (_, __) => const PasswordResetSuccessScreen()),
  ],
);

class NeetApp extends ConsumerWidget {
  const NeetApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);

    return MaterialApp.router(
      title: 'NEET Community',
      debugShowCheckedModeBanner: false,
      locale: Locale(currentLocale),
      theme: buildLightTheme(),
      darkTheme: buildDarkTheme(),
      routerConfig: _router,
    );
  }
}
