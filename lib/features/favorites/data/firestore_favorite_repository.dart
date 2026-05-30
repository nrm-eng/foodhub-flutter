import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/favorite_repository.dart';

class FirestoreFavoriteRepository implements FavoriteRepository {
  FirestoreFavoriteRepository() : _firestore = FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference _favoritesRef(String userId) =>
      _firestore.collection('users').doc(userId).collection('favorites');

  @override
  Stream<List<String>> watchFavoriteIds(String userId) {
    return _favoritesRef(userId).snapshots().map(
      (snapshot) => snapshot.docs.map((doc) => doc.id).toList(),
    );
  }

  @override
  Future<void> addFavorite(
    String userId,
    String mealId,
    String mealName,
    String mealThumb,
  ) async {
    await _favoritesRef(userId).doc(mealId).set({
      'mealId': mealId,
      'mealName': mealName,
      'mealThumb': mealThumb,
      'addedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> removeFavorite(String userId, String mealId) async {
    await _favoritesRef(userId).doc(mealId).delete();
  }

  @override
  Future<bool> isFavorite(String userId, String mealId) async {
    final doc = await _favoritesRef(userId).doc(mealId).get();
    return doc.exists;
  }
}