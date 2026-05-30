import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_hub/features/auth/presentation/screens/login_screen.dart';
import 'package:food_hub/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Widget buildTestApp(Widget child) {
  return ProviderScope(
    child: MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
      home: child,
    ),
  );
}

void main() {
  group('LoginScreen widget tests', () {
    testWidgets('shows email and password fields', (tester) async {
      await tester.pumpWidget(buildTestApp(const LoginScreen()));
      await tester.pump();

      expect(find.byType(TextField), findsNWidgets(2));
    });

    testWidgets('shows sign in button', (tester) async {
      await tester.pumpWidget(buildTestApp(const LoginScreen()));
      await tester.pump();

      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('shows register link', (tester) async {
      await tester.pumpWidget(buildTestApp(const LoginScreen()));
      await tester.pump();

      expect(find.byType(TextButton), findsAtLeastNWidgets(1));
    });
  });
}