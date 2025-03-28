import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'recipe.dart';
import 'recipe_provider.dart';

class MainPage extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController ingredientsController = TextEditingController();
  final TextEditingController instructionsController = TextEditingController();

  MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final recipeProvider = Provider.of<RecipeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('My Recipes')),
      body: ListView.builder(
        itemCount: recipeProvider.recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipeProvider.recipes[index];
          return ListTile(
            title: Text(recipe.title),
            subtitle: Text(recipe.ingredients),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                recipeProvider.deleteRecipe(recipe.id!);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Add Recipe'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title')),
                TextField(controller: ingredientsController, decoration: const InputDecoration(labelText: 'Ingredients')),
                TextField(controller: instructionsController, decoration: const InputDecoration(labelText: 'Instructions')),
              ],
            ),
            actions: [
              TextButton(
                child: const Text('Add'),
                onPressed: () {
                  final newRecipe = Recipe(
                    title: titleController.text,
                    ingredients: ingredientsController.text,
                    instructions: instructionsController.text,
                  );
                  recipeProvider.addRecipe(newRecipe);
                  Navigator.of(context).pop();
                  titleController.clear();
                  ingredientsController.clear();
                  instructionsController.clear();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
