import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/app_strings.dart';

const String kAppLocaleStorageKey = 'selected_app_locale';

class LocaleNotifier extends StateNotifier<String> {
  LocaleNotifier([super.initial = 'en']) {
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLocale = prefs.getString(kAppLocaleStorageKey);
      if (savedLocale != null && (savedLocale == 'en' || savedLocale == 'hi')) {
        state = savedLocale;
      }
    } catch (_) {
      // In tests or if storage is unavailable, safely continue with in-memory state
    }
  }

  Future<void> setLocale(String newLocale) async {
    if (state == newLocale) return;
    state = newLocale;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(kAppLocaleStorageKey, newLocale);
    } catch (_) {
      // Safely ignore storage write failures in mock/test environments
    }
  }

  void toggleLocale() {
    final next = state == 'en' ? 'hi' : 'en';
    setLocale(next);
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, String>((ref) {
  return LocaleNotifier();
});

final stringsProvider = Provider<AppStrings>((ref) {
  final currentLocale = ref.watch(localeProvider);
  return AppStrings.of(currentLocale);
});
