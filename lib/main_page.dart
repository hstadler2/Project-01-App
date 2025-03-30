import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'recipe.dart';
import 'recipe_provider.dart';
import 'recipe_detail_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final recipeProvider = Provider.of<RecipeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Recipes'),
        backgroundColor: Colors.green[800], // Custom color for the AppBar
      ),
      body: ListView.builder(
        itemCount: recipeProvider.recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipeProvider.recipes[index];
          return Card(
            elevation: 4.0,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: ListTile(
              leading: Icon(Icons.fastfood), // Placeholder for images
              title: Text(recipe.title, style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(recipe.ingredients),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RecipeDetailPage(recipe: recipe)),
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  recipeProvider.deleteRecipe(recipe.id!);
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
        onPressed: () => showDialog(
          context: context,
          builder: (_) => _buildAddRecipeDialog(context, recipeProvider),
        ),
      ),
    );
  }

  Widget _buildAddRecipeDialog(BuildContext context, RecipeProvider recipeProvider) {
    TextEditingController titleController = TextEditingController();
    TextEditingController ingredientsController = TextEditingController();
    TextEditingController instructionsController = TextEditingController();

    return AlertDialog(
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
          },
        )
      ],
    );
  }
}
