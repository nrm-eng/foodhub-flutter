import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Провайдер для теми
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
  (ref) => ThemeModeNotifier(),
);

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString('theme_mode') ?? 'system';
    state = _fromString(value);
  }

  Future<void> setTheme(ThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_mode', _toString(mode));
  }

  ThemeMode _fromString(String value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
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

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Appearance',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.light_mode_outlined),
            title: const Text('Light'),
            trailing: themeMode == ThemeMode.light
                ? Icon(
                    Icons.check_circle,
                    color: Theme.of(context).colorScheme.primary,
                  )
                : null,
            onTap: () => ref.read(themeModeProvider.notifier).setTheme(
                  ThemeMode.light,
                ),
          ),
          ListTile(
            leading: const Icon(Icons.dark_mode_outlined),
            title: const Text('Dark'),
            trailing: themeMode == ThemeMode.dark
                ? Icon(
                    Icons.check_circle,
                    color: Theme.of(context).colorScheme.primary,
                  )
                : null,
            onTap: () => ref.read(themeModeProvider.notifier).setTheme(
                  ThemeMode.dark,
                ),
          ),
          ListTile(
            leading: const Icon(Icons.phone_android_outlined),
            title: const Text('System'),
            trailing: themeMode == ThemeMode.system
                ? Icon(
                    Icons.check_circle,
                    color: Theme.of(context).colorScheme.primary,
                  )
                : null,
            onTap: () => ref.read(themeModeProvider.notifier).setTheme(
                  ThemeMode.system,
                ),
          ),
        ],
      ),
    );
  }
}