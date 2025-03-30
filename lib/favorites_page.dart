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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Recipes'),
        backgroundColor: Colors.green[800],
      ),
      body: ListView.builder(
        itemCount: recipeProvider.favoriteRecipes.length,
        itemBuilder: (context, index) {
          final recipe = recipeProvider.favoriteRecipes[index];
          return ListTile(
            title: Text(recipe.title),
            subtitle: Text(recipe.ingredients),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RecipeDetailPage(recipe: recipe)),
            ),
            trailing: Icon(recipe.isFavorite ? Icons.favorite : Icons.favorite_border, color: Colors.red),
          );
        },
      ),
    );
  }
}
