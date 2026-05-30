class Meal {
  const Meal({
    required this.id,
    required this.name,
    required this.category,
    required this.area,
    required this.instructions,
    required this.thumbnail,
    required this.tags,
    required this.youtubeUrl,
    required this.ingredients,
    required this.measures,
  });

  final String id;
  final String name;
  final String category;
  final String area;
  final String instructions;
  final String thumbnail;
  final String tags;
  final String youtubeUrl;
  final List<String> ingredients;
  final List<String> measures;

  factory Meal.fromJson(Map<String, dynamic> json) {
    final ingredients = <String>[];
    final measures = <String>[];

    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      final measure = json['strMeasure$i'];
      if (ingredient != null && ingredient.toString().trim().isNotEmpty) {
        ingredients.add(ingredient.toString().trim());
        measures.add(measure?.toString().trim() ?? '');
      }
    }

    return Meal(
      id: json['idMeal'] ?? '',
      name: json['strMeal'] ?? '',
      category: json['strCategory'] ?? '',
      area: json['strArea'] ?? '',
      instructions: (json['strInstructions'] ?? '')
          .replaceAll('\r\n', '\n')
          .replaceAll('\r', '\n')
          .trim(),
      thumbnail: json['strMealThumb'] ?? '',
      tags: json['strTags'] ?? '',
      youtubeUrl: json['strYoutube'] ?? '',
      ingredients: ingredients,
      measures: measures,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'idMeal': id,
      'strMeal': name,
      'strCategory': category,
      'strArea': area,
      'strInstructions': instructions,
      'strMealThumb': thumbnail,
      'strTags': tags,
      'strYoutube': youtubeUrl,
    };

    for (int i = 0; i < ingredients.length; i++) {
      json['strIngredient${i + 1}'] = ingredients[i];
      json['strMeasure${i + 1}'] = measures.length > i ? measures[i] : '';
    }

    return json;
  }
}
