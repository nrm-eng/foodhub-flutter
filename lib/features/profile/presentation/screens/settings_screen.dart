import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../l10n/app_localizations.dart';

// Провайдер SharedPreferences — ініціалізується в main() і передається через override
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider must be overridden in main()',
  );
});

// Провайдер теми
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
  (ref) => ThemeModeNotifier(ref.read(sharedPreferencesProvider)),
);

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier(this._prefs) : super(_readTheme(_prefs));

  final SharedPreferences _prefs;

  static ThemeMode _readTheme(SharedPreferences prefs) {
    final value = prefs.getString('theme_mode') ?? 'system';
    if (value == 'light') return ThemeMode.light;
    if (value == 'dark') return ThemeMode.dark;
    return ThemeMode.system;
  }

  Future<void> setTheme(ThemeMode mode) async {
    state = mode;
    await _prefs.setString('theme_mode', _toString(mode));
  }

  String _toString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      default:
        return 'system';
    }
  }
}

// Провайдер мови
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>(
  (ref) => LocaleNotifier(ref.read(sharedPreferencesProvider)),
);

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier(this._prefs) : super(_readLocale(_prefs));

  final SharedPreferences _prefs;

  static Locale _readLocale(SharedPreferences prefs) {
    final value = prefs.getString('locale') ?? 'en';
    return Locale(value);
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    await _prefs.setString('locale', locale.languageCode);
  }
}

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              l10n.appearance,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.light_mode_outlined),
            title: Text(l10n.light),
            trailing: themeMode == ThemeMode.light
                ? Icon(
                    Icons.check_circle,
                    color: Theme.of(context).colorScheme.primary,
                  )
                : null,
            onTap: () =>
                ref.read(themeModeProvider.notifier).setTheme(ThemeMode.light),
          ),
          ListTile(
            leading: const Icon(Icons.dark_mode_outlined),
            title: Text(l10n.dark),
            trailing: themeMode == ThemeMode.dark
                ? Icon(
                    Icons.check_circle,
                    color: Theme.of(context).colorScheme.primary,
                  )
                : null,
            onTap: () =>
                ref.read(themeModeProvider.notifier).setTheme(ThemeMode.dark),
          ),
          ListTile(
            leading: const Icon(Icons.phone_android_outlined),
            title: Text(l10n.system),
            trailing: themeMode == ThemeMode.system
                ? Icon(
                    Icons.check_circle,
                    color: Theme.of(context).colorScheme.primary,
                  )
                : null,
            onTap: () =>
                ref.read(themeModeProvider.notifier).setTheme(ThemeMode.system),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(
              l10n.language,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
            ),
          ),
          ListTile(
            leading: const Text('🇬🇧', style: TextStyle(fontSize: 24)),
            title: const Text('English'),
            trailing: locale.languageCode == 'en'
                ? Icon(
                    Icons.check_circle,
                    color: Theme.of(context).colorScheme.primary,
                  )
                : null,
            onTap: () =>
                ref.read(localeProvider.notifier).setLocale(const Locale('en')),
          ),
          ListTile(
            leading: const Text('🇺🇦', style: TextStyle(fontSize: 24)),
            title: const Text('Українська'),
            trailing: locale.languageCode == 'uk'
                ? Icon(
                    Icons.check_circle,
                    color: Theme.of(context).colorScheme.primary,
                  )
                : null,
            onTap: () =>
                ref.read(localeProvider.notifier).setLocale(const Locale('uk')),
          ),
          ListTile(
            leading: const Text('🇵🇱', style: TextStyle(fontSize: 24)),
            title: const Text('Polski'),
            trailing: locale.languageCode == 'pl'
                ? Icon(
                    Icons.check_circle,
                    color: Theme.of(context).colorScheme.primary,
                  )
                : null,
            onTap: () =>
                ref.read(localeProvider.notifier).setLocale(const Locale('pl')),
          ),
        ],
      ),
    );
  }
}