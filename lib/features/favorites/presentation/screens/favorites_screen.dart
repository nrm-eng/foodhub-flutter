import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../favorites_providers.dart';
import 'my_recipe_detail_screen.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final l10n = AppLocalizations.of(context);

    if (userId == null) {
      return const Scaffold(body: Center(child: Text('Not logged in')));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.myCollection),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Theme.of(context).colorScheme.primary,
          labelColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : const Color(0xFF1A1A1A),
          unselectedLabelColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.white60
              : const Color(0xFF555555),
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 14,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
          tabs: [
            Tab(text: l10n.favorites),
            Tab(text: l10n.myRecipes),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _FavoritesTab(userId: userId),
          _MyRecipesTab(userId: userId),
        ],
      ),
    );
  }
}

class _FavoritesTab extends ConsumerWidget {
  const _FavoritesTab({required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .orderBy('addedAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final docs = snapshot.data?.docs ?? [];

        if (docs.isEmpty) {
          return _EmptyState(
            icon: Icons.favorite_border,
            title: l10n.noFavoritesYet,
            subtitle: l10n.noFavoritesSubtitle,
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.78,
          ),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            final mealId = data['mealId'] as String;
            final mealName = data['mealName'] as String;
            final mealThumb = data['mealThumb'] as String;

            return GestureDetector(
              onTap: () => context.push('/recipe/$mealId'),
              child: _RecipeCard(
                heroTag: 'meal-$mealId',
                name: mealName,
                imageUrl: mealThumb,
                onDelete: () async {
                  await ref
                      .read(favoriteRepositoryProvider)
                      .removeFavorite(userId, mealId);
                },
              ),
            );
          },
        );
      },
    );
  }
}

class _MyRecipesTab extends StatelessWidget {
  const _MyRecipesTab({required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('my_recipes')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final docs = snapshot.data?.docs ?? [];

        if (docs.isEmpty) {
          return _EmptyState(
            icon: Icons.menu_book_outlined,
            title: l10n.noRecipesYet,
            subtitle: l10n.noRecipesSubtitle,
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.75,
          ),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            final name = data['name'] as String;
            final ingredients = data['ingredients'] as String;
            final imageUrl = data['imageUrl'] as String? ?? '';
            final docId = docs[index].id;

            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MyRecipeDetailScreen(
                    name: name,
                    ingredients: ingredients,
                    instructions: data['instructions'] as String? ?? '',
                    imageUrl: imageUrl,
                  ),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Фото або градієнтний placeholder на весь розмір
                    imageUrl.isNotEmpty
                        ? Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) =>
                                _fullGradientPlaceholder(),
                          )
                        : _fullGradientPlaceholder(),
                    // Gradient overlay знизу з назвою
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(12, 40, 12, 12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.85),
                              Colors.transparent,
                            ],
                          ),
                        ),
                        child: Text(
                          name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            height: 1.3,
                            shadows: [
                              Shadow(color: Colors.black, blurRadius: 8),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Кнопки зверху праворуч
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Row(
                        children: [
                          _FloatingActionBtn(
                            icon: Icons.edit_rounded,
                            color: const Color(0xFFF9A825),
                            onTap: () => _showEditSheet(
                              context,
                              docId: docId,
                              userId: userId,
                              currentName: name,
                              currentIngredients: ingredients,
                              currentInstructions:
                                  data['instructions'] as String? ?? '',
                            ),
                          ),
                          const SizedBox(width: 6),
                          _FloatingActionBtn(
                            icon: Icons.delete_rounded,
                            color: const Color(0xFFD32F2F),
                            onTap: () async {
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(userId)
                                  .collection('my_recipes')
                                  .doc(docId)
                                  .delete();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _RecipeCard extends StatelessWidget {
  const _RecipeCard({
    required this.heroTag,
    required this.name,
    required this.imageUrl,
    required this.onDelete,
  });

  final String heroTag;
  final String name;
  final String imageUrl;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Фото на весь розмір
          Hero(
            tag: heroTag,
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, _, _) => Container(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: const Icon(Icons.restaurant, size: 48),
              ),
            ),
          ),
          // Gradient overlay знизу
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(12, 40, 12, 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.85),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Text(
                name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  height: 1.3,
                  shadows: [Shadow(color: Colors.black, blurRadius: 8)],
                ),
              ),
            ),
          ),
          // Кнопка видалення (серце) у верхньому куті
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: onDelete,
              child: Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.45),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.favorite, color: Colors.red, size: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void _showEditSheet(
  BuildContext context, {
  required String docId,
  required String userId,
  required String currentName,
  required String currentIngredients,
  required String currentInstructions,
}) {
  final nameCtrl = TextEditingController(text: currentName);
  final ingredientsCtrl = TextEditingController(text: currentIngredients);
  final instructionsCtrl = TextEditingController(text: currentInstructions);
  final l10n = AppLocalizations.of(context);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        MediaQuery.of(ctx).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: InputDecoration(hintText: l10n.recipeName),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: ingredientsCtrl,
              maxLines: 3,
              decoration: InputDecoration(hintText: l10n.ingredientsHint),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: instructionsCtrl,
              maxLines: 4,
              decoration: InputDecoration(hintText: l10n.cookingInstructions),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .collection('my_recipes')
                    .doc(docId)
                    .update({
                      'name': nameCtrl.text.trim(),
                      'ingredients': ingredientsCtrl.text.trim(),
                      'instructions': instructionsCtrl.text.trim(),
                    });
                if (ctx.mounted) Navigator.pop(ctx);
              },
              child: Text(l10n.saveRecipe),
            ),
          ],
        ),
      ),
    ),
  );
}

// Повний градієнтний placeholder (для grid картки)
Widget _fullGradientPlaceholder() {
  return Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFF9A825), Color(0xFFE65100)],
      ),
    ),
    child: const Icon(
      Icons.restaurant_menu_rounded,
      color: Colors.white,
      size: 48,
    ),
  );
}

// Кнопка поверх картки (edit / delete)
class _FloatingActionBtn extends StatelessWidget {
  const _FloatingActionBtn({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.5),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 16),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }
}