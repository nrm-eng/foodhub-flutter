import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../core/constants/api_constants.dart';
import '../domain/meal.dart';
import '../domain/meal_category.dart';
import '../domain/meal_preview.dart';
import '../domain/meal_repository.dart';

class MealRepositoryImpl implements MealRepository {
  const MealRepositoryImpl({required this.client});

  final http.Client client;

  @override
  Future<List<MealCategory>> getCategories() async {
    final response = await client.get(
      Uri.parse(ApiConstants.categories),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load categories');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final list = json['categories'] as List<dynamic>;
    return list
        .map((e) => MealCategory.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<MealPreview>> getMealsByCategory(String category) async {
    final response = await client.get(
      Uri.parse(ApiConstants.mealsByCategory(category)),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load meals');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final list = json['meals'] as List<dynamic>;
    return list
        .map((e) => MealPreview.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Meal> getMealById(String id) async {
    final response = await client.get(
      Uri.parse(ApiConstants.mealById(id)),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load meal');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final list = json['meals'] as List<dynamic>;
    return Meal.fromJson(list.first as Map<String, dynamic>);
  }

  @override
  Future<List<MealPreview>> searchMeals(String query) async {
    final response = await client.get(
      Uri.parse(ApiConstants.searchMeals(query)),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to search meals');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final meals = json['meals'];
    if (meals == null) return [];
    return (meals as List<dynamic>)
        .map((e) => MealPreview.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}