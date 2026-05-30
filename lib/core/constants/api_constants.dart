abstract final class ApiConstants {
  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  // Категорії
  static const String categories = '$baseUrl/categories.php';

  // Рецепти за категорією
  static String mealsByCategory(String category) =>
      '$baseUrl/filter.php?c=$category';

  // Пошук за назвою
  static String searchMeals(String query) => '$baseUrl/search.php?s=$query';

  // Деталі рецепту за ID
  static String mealById(String id) => '$baseUrl/lookup.php?i=$id';

  // Випадковий рецепт
  static const String randomMeal = '$baseUrl/random.php';
}