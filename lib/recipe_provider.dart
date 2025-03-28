import 'package:flutter/material.dart';
import 'database_service.dart';
import 'recipe.dart';

class RecipeProvider with ChangeNotifier {
  List<Recipe> _recipes = [];

  List<Recipe> get recipes => _recipes;

  Future<void> loadRecipes() async {
    _recipes = await DatabaseService().getRecipes();
    notifyListeners();
  }

  Future<void> addRecipe(Recipe recipe) async {
    await DatabaseService().insertRecipe(recipe);
    await loadRecipes();
  }

  Future<void> updateRecipe(Recipe recipe) async {
    await DatabaseService().updateRecipe(recipe);
    await loadRecipes();
  }

  Future<void> deleteRecipe(int id) async {
    await DatabaseService().deleteRecipe(id);
    await loadRecipes();
  }
}
