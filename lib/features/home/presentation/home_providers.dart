import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../data/meal_repository_impl.dart';
import '../domain/meal.dart';
import '../domain/meal_category.dart';
import '../domain/meal_preview.dart';
import '../domain/meal_repository.dart';

// HTTP клієнт
final httpClientProvider = Provider<http.Client>((ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return client;
});

// Репозиторій
final mealRepositoryProvider = Provider<MealRepository>((ref) {
  return MealRepositoryImpl(client: ref.watch(httpClientProvider));
});

// Категорії
final categoriesProvider = FutureProvider<List<MealCategory>>((ref) {
  return ref.watch(mealRepositoryProvider).getCategories();
});

// Рецепти за категорією
final mealsByCategoryProvider =
    FutureProvider.family<List<MealPreview>, String>((ref, category) {
      return ref.watch(mealRepositoryProvider).getMealsByCategory(category);
    });

// Деталі рецепту
final mealDetailProvider = FutureProvider.family<Meal, String>((ref, id) {
  return ref.watch(mealRepositoryProvider).getMealById(id);
});

// Пошук
final searchQueryProvider = StateProvider<String>((ref) => '');

final searchResultsProvider = FutureProvider.family<List<MealPreview>, String>((
  ref,
  query,
) {
  if (query.isEmpty) return Future.value([]);
  return ref.watch(mealRepositoryProvider).searchMeals(query);
});

// Випадковий рецепт дня
final randomMealProvider = FutureProvider<Meal>((ref) {
  return ref.watch(mealRepositoryProvider).getRandomMeal();
});