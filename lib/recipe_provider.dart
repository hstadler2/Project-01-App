// This file manages our recipe state and communicates with the DB.
import 'package:flutter/material.dart';
import 'database_service.dart';
import 'recipe.dart';

class RecipeProvider with ChangeNotifier {
  List<Recipe> _recipes = [];

  List<Recipe> get recipes => _recipes;

  // Load recipes from the database.
  Future<void> loadRecipes() async {
    _recipes = await DatabaseService().getRecipes();
    notifyListeners();
  }

  // Add a new recipe.
  Future<void> addRecipe(Recipe recipe) async {
    await DatabaseService().insertRecipe(recipe);
    await loadRecipes();
  }

  // Update an existing recipe.
  Future<void> updateRecipe(Recipe recipe) async {
    await DatabaseService().updateRecipe(recipe);
    await loadRecipes();
  }

  // Delete a recipe.
  Future<void> deleteRecipe(int? id) async {
    if (id != null) {
      await DatabaseService().deleteRecipe(id);
      await loadRecipes();
    }
  }

  // Toggle favorite status.
  Future<void> toggleFavoriteStatus(Recipe recipe) async {
    recipe.isFavorite = !recipe.isFavorite;
    await updateRecipe(recipe);
    notifyListeners();
  }

  // Return only favorite recipes.
  List<Recipe> get favoriteRecipes {
    return _recipes.where((recipe) => recipe.isFavorite).toList();
  }
}
