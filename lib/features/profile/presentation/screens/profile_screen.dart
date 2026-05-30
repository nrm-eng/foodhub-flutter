import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/auth_providers.dart';
import 'settings_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;
    final l10n = AppLocalizations.of(context);
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    const primary = Color(0xFFF9A825);

    final initial = user?.email?.substring(0, 1).toUpperCase() ?? 'U';
    final email = user?.email ?? '';

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: Theme.of(context).brightness == Brightness.dark
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF2A1A00), Color(0xFF1A1A1A)],
                )
              : const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFFD54F), Color(0xFFFFB300)],
                ),
        ),
        child: Stack(
          children: [
            // Декоративні кружечки
            Positioned(
              top: -70,
              right: -70,
              child: Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFBF360C).withValues(alpha: 0.35),
                ),
              ),
            ),
            Positioned(
              bottom: -80,
              left: -60,
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF870000).withValues(alpha: 0.28),
                ),
              ),
            ),
            Positioned(
              top: 220,
              left: -15,
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFBF360C).withValues(alpha: 0.25),
                ),
              ),
            ),

            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 24, 22, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Аватарка з ободком і тінню
                    Center(
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: primary.withValues(alpha: 0.45),
                                  blurRadius: 28,
                                  spreadRadius: 4,
                                ),
                              ],
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: CircleAvatar(
                                radius: 52,
                                backgroundColor: primary,
                                child: Text(
                                  initial,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 40,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            email,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 36),

                    // Тема
                    _SectionTitle(l10n.appearance),
                    const SizedBox(height: 10),
                    _SettingsCard(
                      children: [
                        _RadioOption(
                          icon: Icons.dark_mode_rounded,
                          label: l10n.dark,
                          selected: themeMode == ThemeMode.dark,
                          onTap: () => ref
                              .read(themeModeProvider.notifier)
                              .setTheme(ThemeMode.dark),
                        ),
                        const _CardDivider(),
                        _RadioOption(
                          icon: Icons.light_mode_rounded,
                          label: l10n.light,
                          selected: themeMode == ThemeMode.light,
                          onTap: () => ref
                              .read(themeModeProvider.notifier)
                              .setTheme(ThemeMode.light),
                        ),
                        const _CardDivider(),
                        _RadioOption(
                          icon: Icons.phone_android_rounded,
                          label: l10n.system,
                          selected: themeMode == ThemeMode.system,
                          onTap: () => ref
                              .read(themeModeProvider.notifier)
                              .setTheme(ThemeMode.system),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Мова
                    _SectionTitle(l10n.language),
                    const SizedBox(height: 10),
                    _SettingsCard(
                      children: [
                        _RadioOption(
                          flag: '🇬🇧',
                          label: 'English',
                          selected: locale.languageCode == 'en',
                          onTap: () => ref
                              .read(localeProvider.notifier)
                              .setLocale(const Locale('en')),
                        ),
                        const _CardDivider(),
                        _RadioOption(
                          flag: '🇺🇦',
                          label: 'Українська',
                          selected: locale.languageCode == 'uk',
                          onTap: () => ref
                              .read(localeProvider.notifier)
                              .setLocale(const Locale('uk')),
                        ),
                        const _CardDivider(),
                        _RadioOption(
                          flag: '🇵🇱',
                          label: 'Polski',
                          selected: locale.languageCode == 'pl',
                          onTap: () => ref
                              .read(localeProvider.notifier)
                              .setLocale(const Locale('pl')),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Вийти
                    ElevatedButton.icon(
                      onPressed: () async {
                        await ref.read(authRepositoryProvider).signOut();
                        if (context.mounted) context.go('/login');
                      },
                      icon: const Icon(Icons.logout_rounded),
                      label: Text(l10n.signOut),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD32F2F),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 54),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Заголовок секції
class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.w700,
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.65),
        letterSpacing: 0.3,
      ),
    );
  }
}

// Картка з темним градієнтом
class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2E2E2E), Color(0xFF1A1A1A)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

// Рядок з радіо вибором
class _RadioOption extends StatelessWidget {
  const _RadioOption({
    this.icon,
    this.flag,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData? icon;
  final String? flag;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFFF9A825);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            // Іконка або прапор
            if (icon != null)
              Icon(icon, color: Colors.white70, size: 20)
            else
              Text(flag!, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 14),
            // Назва
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
            // Індикатор вибору
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? primary : Colors.transparent,
                border: Border.all(
                  color: selected ? primary : Colors.white38,
                  width: 2,
                ),
              ),
              child: selected
                  ? const Icon(Icons.check, size: 13, color: Colors.black)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

// Розділювач всередині картки
class _CardDivider extends StatelessWidget {
  const _CardDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      indent: 20,
      endIndent: 20,
      color: Color(0xFF383838),
    );
  }
}