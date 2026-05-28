import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_hub/features/home/domain/meal_category.dart';
import 'package:food_hub/features/home/domain/meal_preview.dart';
import 'package:food_hub/features/home/presentation/home_providers.dart';
import 'package:food_hub/features/home/presentation/screens/home_screen.dart';
import 'package:food_hub/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Widget buildTestApp(Widget child, List<Override> overrides) {
  return ProviderScope(
    overrides: overrides,
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
  group('HomeScreen widget tests', () {
    testWidgets('shows loading indicator while fetching categories',
        (tester) async {
      await tester.pumpWidget(
        buildTestApp(const HomeScreen(), []),
      );

      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    testWidgets('shows search field after data loads', (tester) async {
      await tester.pumpWidget(
        buildTestApp(const HomeScreen(), [
          categoriesProvider.overrideWith(
            (ref) => Future.value([
              MealCategory(
                id: '1',
                name: 'Beef',
                thumbnail: '',
                description: 'Beef dishes',
              ),
            ]),
          ),
          mealsByCategoryProvider('Beef').overrideWith(
            (ref) => Future.value([
              MealPreview(
                id: '1',
                name: 'Test Meal',
                thumbnail: '',
              ),
            ]),
          ),
        ]),
      );
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);
    });
  });
}