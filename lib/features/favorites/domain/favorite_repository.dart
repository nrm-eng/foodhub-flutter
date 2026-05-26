abstract class FavoriteRepository {
  Stream<List<String>> watchFavoriteIds(String userId);
  Future<void> addFavorite(String userId, String mealId, String mealName, String mealThumb);
  Future<void> removeFavorite(String userId, String mealId);
  Future<bool> isFavorite(String userId, String mealId);
}