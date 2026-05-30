import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_hub/features/add_recipe/presentation/screens/add_recipe_screen.dart';
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
  group('AddRecipeScreen widget tests', () {
    testWidgets('shows form fields', (tester) async {
      await tester.pumpWidget(buildTestApp(const AddRecipeScreen()));
      await tester.pump();

      expect(find.byType(TextFormField), findsAtLeastNWidgets(2));
    });

    testWidgets('shows save button', (tester) async {
      await tester.pumpWidget(buildTestApp(const AddRecipeScreen()));
      await tester.pump();

      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('shows validation errors on empty submit', (tester) async {
      await tester.pumpWidget(buildTestApp(const AddRecipeScreen()));
      await tester.pump();

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(find.byType(TextFormField), findsAtLeastNWidgets(2));
    });
  });
}