import 'meal.dart';
import 'meal_category.dart';
import 'meal_preview.dart';

abstract class MealRepository {
  Future<List<MealCategory>> getCategories();
  Future<List<MealPreview>> getMealsByCategory(String category);
  Future<Meal> getMealById(String id);
  Future<List<MealPreview>> searchMeals(String query);
}