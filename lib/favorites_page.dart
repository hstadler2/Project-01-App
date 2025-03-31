// This page shows only the favorite recipes.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'recipe.dart';
import 'recipe_provider.dart';
import 'recipe_detail_page.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final recipeProvider = Provider.of<RecipeProvider>(context);
    final favorites = recipeProvider.favoriteRecipes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Recipes'),
        backgroundColor: Colors.green[800],
      ),
      body: favorites.isEmpty
          ? const Center(child: Text('No favorite recipes.'))
          : ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final recipe = favorites[index];
          return ListTile(
            title: Text(recipe.title),
            subtitle: Text(recipe.ingredients),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RecipeDetailPage(recipe: recipe)),
            ),
          );
        },
      ),
    );
  }
}
