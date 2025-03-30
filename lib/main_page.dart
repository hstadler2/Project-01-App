import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'recipe.dart';
import 'recipe_provider.dart';
import 'recipe_detail_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0; // Index to handle the current selected tab

  @override
  Widget build(BuildContext context) {
    final RecipeProvider recipeProvider = Provider.of<RecipeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Recipes'),
        backgroundColor: Colors.green[800],
      ),
      body: ListView.builder(
        itemCount: recipeProvider.recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipeProvider.recipes[index];
          return ListTile(
            title: Text(recipe.title),
            subtitle: Text(recipe.ingredients),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RecipeDetailPage(recipe: recipe)),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                if (recipe.id != null) {
                  recipeProvider.deleteRecipe(recipe.id!);
                } else {
                  print("Error: Recipe ID is null");
                }
              },
              color: Colors.red,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
        onPressed: () => _showAddRecipeDialog(recipeProvider),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.filter_list),
            label: 'Filters',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Planner',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Add more functionality here based on tab selection if needed
    });
  }

  void _showAddRecipeDialog(RecipeProvider recipeProvider) {
    TextEditingController titleController = TextEditingController();
    TextEditingController ingredientsController = TextEditingController();
    TextEditingController instructionsController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Recipe'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title')),
                TextField(controller: ingredientsController, decoration: const InputDecoration(labelText: 'Ingredients')),
                TextField(controller: instructionsController, decoration: const InputDecoration(labelText: 'Instructions')),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                final newRecipe = Recipe(
                  title: titleController.text,
                  ingredients: ingredientsController.text,
                  instructions: instructionsController.text,
                  // Add other fields as necessary
                );
                recipeProvider.addRecipe(newRecipe);
                Navigator.of(context).pop();
                titleController.clear();
                ingredientsController.clear();
                instructionsController.clear();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
