import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:food_hub/features/home/data/meal_repository_impl.dart';

class MockHttpClient extends Mock implements http.Client {}

class FakeUri extends Fake implements Uri {}

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerFallbackValue(FakeUri());
  });

  late MockHttpClient mockClient;
  late MealRepositoryImpl repository;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    mockClient = MockHttpClient();
    repository = MealRepositoryImpl(client: mockClient);
  });

  group('MealRepository', () {
    test('getCategories returns list of categories on success', () async {
      when(() => mockClient.get(any())).thenAnswer(
        (_) async => http.Response(
          '{"categories": [{"idCategory": "1", "strCategory": "Beef", "strCategoryThumb": "https://example.com/beef.jpg", "strCategoryDescription": "Beef dishes"}]}',
          200,
        ),
      );

      final categories = await repository.getCategories();

      expect(categories.length, 1);
      expect(categories[0].name, 'Beef');
    });

    test('getCategories throws on error status', () async {
      when(() => mockClient.get(any())).thenAnswer(
        (_) async => http.Response('Error', 500),
      );

      expect(() => repository.getCategories(), throwsException);
    });

    test('getMealsByCategory returns list of meals', () async {
      when(() => mockClient.get(any())).thenAnswer(
        (_) async => http.Response(
          '{"meals": [{"idMeal": "1", "strMeal": "Test Meal", "strMealThumb": "https://example.com/meal.jpg"}]}',
          200,
        ),
      );

      final meals = await repository.getMealsByCategory('Beef');

      expect(meals.length, 1);
      expect(meals[0].name, 'Test Meal');
    });

    test('searchMeals returns empty list when no results', () async {
      when(() => mockClient.get(any())).thenAnswer(
        (_) async => http.Response('{"meals": null}', 200),
      );

      final meals = await repository.searchMeals('nonexistent');

      expect(meals, isEmpty);
    });

    test('getMealById returns meal details', () async {
      when(() => mockClient.get(any())).thenAnswer(
        (_) async => http.Response(
          '{"meals": [{"idMeal": "1", "strMeal": "Test", "strCategory": "Beef", "strArea": "British", "strInstructions": "Cook it.", "strMealThumb": "https://example.com/meal.jpg", "strTags": "", "strYoutube": ""}]}',
          200,
        ),
      );

      final meal = await repository.getMealById('1');

      expect(meal.id, '1');
      expect(meal.name, 'Test');
    });
  });
}