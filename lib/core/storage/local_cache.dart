import 'package:shared_preferences/shared_preferences.dart';

class LocalCache {
  static const String _categoriesKey = 'cached_categories';
  static const String _cacheTimeKey = 'cache_time_categories';
  static const int _cacheDurationHours = 24;

  static Future<void> saveCategories(String json) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_categoriesKey, json);
    await prefs.setInt(
      _cacheTimeKey,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  static Future<String?> getCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final cacheTime = prefs.getInt(_cacheTimeKey);

    if (cacheTime == null) return null;

    final age = DateTime.now().millisecondsSinceEpoch - cacheTime;
    final maxAge = _cacheDurationHours * 60 * 60 * 1000;

    if (age > maxAge) return null;

    return prefs.getString(_categoriesKey);
  }

  static Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_categoriesKey);
    await prefs.remove(_cacheTimeKey);
  }
}