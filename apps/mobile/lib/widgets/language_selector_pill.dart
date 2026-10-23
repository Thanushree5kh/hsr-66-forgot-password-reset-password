import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/locale_provider.dart';
import '../theme/theme.dart';

class LanguageSelectorPill extends ConsumerWidget {
  const LanguageSelectorPill({
    super.key,
    this.isLight = true,
  });

  /// When true, renders white text/icons on translucent background for dark/gradient headers.
  /// When false, renders dark text/icons for light/white backgrounds.
  final bool isLight;

  void _showLanguageSheet(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.read(localeProvider);
    final strings = ref.read(stringsProvider);

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 38,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD1D5DB),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(
                      Icons.translate_rounded,
                      color: AppColors.royalBlue,
                      size: 22,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      strings.selectLanguage,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _LanguageOptionTile(
                  title: 'English',
                  nativeName: 'English',
                  isSelected: currentLocale == 'en',
                  onTap: () {
                    ref.read(localeProvider.notifier).setLocale('en');
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(height: 8),
                _LanguageOptionTile(
                  title: 'हिंदी',
                  nativeName: 'Hindi',
                  isSelected: currentLocale == 'hi',
                  onTap: () {
                    ref.read(localeProvider.notifier).setLocale('hi');
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    final label = currentLocale == 'hi' ? 'हिंदी' : 'English';

    final textColor = isLight ? Colors.white : AppColors.textPrimary;
    final bgColor = isLight
        ? Colors.white.withAlpha(50)
        : const Color(0xFFEBF3FC);
    final borderColor = isLight
        ? Colors.white.withAlpha(75)
        : const Color(0xFFD0E2F5);

    return InkWell(
      onTap: () => _showLanguageSheet(context, ref),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: borderColor,
            width: 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.translate_rounded,
              color: textColor,
              size: 16,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: textColor,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageOptionTile extends StatelessWidget {
  const _LanguageOptionTile({
    required this.title,
    required this.nativeName,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final String nativeName;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEBF3FC) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.royalBlue : const Color(0xFFE2EAF5),
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w600,
                      color: isSelected
                          ? AppColors.royalBlue
                          : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    nativeName,
                    style: TextStyle(
                      fontSize: 13,
                      color: isSelected
                          ? AppColors.royalBlue.withAlpha(180)
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle_rounded,
                color: AppColors.royalBlue,
                size: 22,
              ),
          ],
        ),
      ),
    );
  }
}
