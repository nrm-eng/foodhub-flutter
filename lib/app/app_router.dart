import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/add_recipe/presentation/screens/add_recipe_screen.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/register_screen.dart';
import '../features/auth/presentation/screens/splash_screen.dart';
import '../features/details/presentation/screens/recipe_details_screen.dart';
import '../features/favorites/presentation/screens/favorites_screen.dart';
import '../features/home/presentation/screens/home_screen.dart';
import '../features/profile/presentation/screens/profile_screen.dart';
import '../features/profile/presentation/screens/settings_screen.dart';
import 'app_shell.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: false,
    routes: [
      // Окремі екрани (без нижньої навігації)
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/recipe/:id',
        builder: (context, state) => RecipeDetailsScreen(
          mealId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),

      // Головні екрани (з нижньою навігацією — AppShell)
      ShellRoute(
        builder: (context, state, child) {
          final loc = state.matchedLocation;
          int index = 0;
          if (loc.startsWith('/favorites')) index = 1;
          if (loc.startsWith('/add-recipe')) index = 2;
          if (loc.startsWith('/profile')) index = 3;

          return AppShell(
            currentIndex: index,
            onNavigate: (i) {
              switch (i) {
                case 0:
                  context.go('/');
                  break;
                case 1:
                  context.go('/favorites');
                  break;
                case 2:
                  context.go('/add-recipe');
                  break;
                case 3:
                  context.go('/profile');
                  break;
              }
            },
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/favorites',
            builder: (context, state) => const FavoritesScreen(),
          ),
          GoRoute(
            path: '/add-recipe',
            builder: (context, state) => const AddRecipeScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
    ],
  );
});