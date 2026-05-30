import 'package:flutter_test/flutter_test.dart';
import 'package:food_hub/features/home/domain/meal.dart';
import 'package:food_hub/features/home/domain/meal_category.dart';
import 'package:food_hub/features/home/domain/meal_preview.dart';

void main() {
  group('Meal model', () {
    test('fromJson creates Meal correctly', () {
      final json = {
        'idMeal': '52772',
        'strMeal': 'Teriyaki Chicken Casserole',
        'strCategory': 'Chicken',
        'strArea': 'Japanese',
        'strInstructions': 'Mix ingredients and cook.',
        'strMealThumb': 'https://example.com/image.jpg',
        'strTags': 'Meat,Casserole',
        'strYoutube': 'https://youtube.com/watch?v=4aZr5hZXP_s',
        'strIngredient1': 'soy sauce',
        'strIngredient2': 'water',
        'strIngredient3': '',
        'strMeasure1': '3/4 cup',
        'strMeasure2': '1/2 cup',
        'strMeasure3': '',
      };

      final meal = Meal.fromJson(json);

      expect(meal.id, '52772');
      expect(meal.name, 'Teriyaki Chicken Casserole');
      expect(meal.category, 'Chicken');
      expect(meal.area, 'Japanese');
      expect(meal.ingredients.length, 2);
      expect(meal.ingredients[0], 'soy sauce');
      expect(meal.measures[0], '3/4 cup');
    });

    test('fromJson handles missing fields', () {
      final json = <String, dynamic>{};
      final meal = Meal.fromJson(json);

      expect(meal.id, '');
      expect(meal.name, '');
      expect(meal.ingredients, isEmpty);
    });

    test('fromJson filters empty ingredients', () {
      final json = {
        'strIngredient1': 'chicken',
        'strIngredient2': '',
        'strIngredient3': '   ',
        'strMeasure1': '1 cup',
        'strMeasure2': '',
        'strMeasure3': '',
      };

      final meal = Meal.fromJson(json);
      expect(meal.ingredients.length, 1);
      expect(meal.ingredients[0], 'chicken');
    });
  });

  group('MealCategory model', () {
    test('fromJson creates MealCategory correctly', () {
      final json = {
        'idCategory': '1',
        'strCategory': 'Beef',
        'strCategoryThumb': 'https://example.com/beef.jpg',
        'strCategoryDescription': 'Beef dishes',
      };

      final category = MealCategory.fromJson(json);

      expect(category.id, '1');
      expect(category.name, 'Beef');
      expect(category.thumbnail, 'https://example.com/beef.jpg');
      expect(category.description, 'Beef dishes');
    });

    test('fromJson handles missing fields', () {
      final json = <String, dynamic>{};
      final category = MealCategory.fromJson(json);

      expect(category.id, '');
      expect(category.name, '');
    });
  });

  group('MealPreview model', () {
    test('fromJson creates MealPreview correctly', () {
      final json = {
        'idMeal': '52772',
        'strMeal': 'Teriyaki Chicken',
        'strMealThumb': 'https://example.com/image.jpg',
      };

      final preview = MealPreview.fromJson(json);

      expect(preview.id, '52772');
      expect(preview.name, 'Teriyaki Chicken');
      expect(preview.thumbnail, 'https://example.com/image.jpg');
    });
  });
}