import 'package:flutter/material.dart';

class RecipeDetailsScreen extends StatelessWidget {
  const RecipeDetailsScreen({super.key, required this.mealId});

  final String mealId;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Recipe Details')),
    );
  }
}