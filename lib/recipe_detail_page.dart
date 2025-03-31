// This page displays details about a single recipe.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'recipe.dart';
import 'recipe_provider.dart';

class RecipeDetailPage extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailPage({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final recipeProvider = Provider.of<RecipeProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.title),
        backgroundColor: Colors.green[800],
        actions: [
          // Button to toggle favorite status.
          IconButton(
            icon: Icon(recipe.isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: () {
              recipeProvider.toggleFavoriteStatus(recipe);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(recipe.isFavorite
                      ? "Added to favorites"
                      : "Removed from favorites"),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Ingredients:",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(recipe.ingredients),
              const SizedBox(height: 16),
              Text("Instructions:",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(recipe.instructions),
              const SizedBox(height: 16),
              Text("Dietary Preferences:",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8.0,
                children: recipe.dietaryPreferences
                    .map((pref) => Chip(label: Text(pref)))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
