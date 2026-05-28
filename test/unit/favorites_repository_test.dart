import 'package:flutter_test/flutter_test.dart';
import 'package:food_hub/features/home/domain/meal.dart';

void main() {
  group('Meal instructions cleanup', () {
    test('replaceAll removes windows line breaks', () {
      const raw = 'Step 1\r\nStep 2\r\nStep 3';
      final cleaned = raw
          .replaceAll('\r\n', '\n')
          .replaceAll('\r', '\n')
          .trim();

      expect(cleaned, 'Step 1\nStep 2\nStep 3');
    });

    test('trim removes leading and trailing whitespace', () {
      const raw = '  Cook the meal  ';
      expect(raw.trim(), 'Cook the meal');
    });

    test('empty ingredients list when all fields empty', () {
      final json = <String, dynamic>{
        for (int i = 1; i <= 20; i++) 'strIngredient$i': '',
        for (int i = 1; i <= 20; i++) 'strMeasure$i': '',
      };
      final meal = Meal.fromJson(json);
      expect(meal.ingredients, isEmpty);
    });

    test('meal with max 20 ingredients', () {
      final json = <String, dynamic>{
        for (int i = 1; i <= 20; i++) 'strIngredient$i': 'ingredient$i',
        for (int i = 1; i <= 20; i++) 'strMeasure$i': '1 cup',
      };
      final meal = Meal.fromJson(json);
      expect(meal.ingredients.length, 20);
    });

    test('meal category defaults to empty string', () {
      final meal = Meal.fromJson({'strCategory': null});
      expect(meal.category, '');
    });
  });
}