// Main page showing the list of recipes and the filters.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'recipe.dart';
import 'recipe_provider.dart';
import 'recipe_detail_page.dart';
import 'favorites_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 1; // Default tab is Home.

  // Options for dietary preferences when adding a recipe.
  Map<String, bool> dietaryPreferences = {
    'None': false,
    'Vegetarian': false,
    'Vegan': false,
    'Gluten-Free': false,
  };

  // Active filter options for the recipe list.
  List<String> activeFilters = [];

  @override
  Widget build(BuildContext context) {
    final RecipeProvider recipeProvider = Provider.of<RecipeProvider>(context);

    // Filter recipes if filters are active.
    List<Recipe> displayedRecipes;
    if (activeFilters.isNotEmpty) {
      displayedRecipes = recipeProvider.recipes.where((recipe) {
        return recipe.dietaryPreferences.any((pref) => activeFilters.contains(pref));
      }).toList();
    } else {
      displayedRecipes = recipeProvider.recipes;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Recipes'),
        backgroundColor: Colors.green[800],
      ),
      body: ListView.builder(
        itemCount: displayedRecipes.length,
        itemBuilder: (context, index) {
          final recipe = displayedRecipes[index];
          return ListTile(
            title: Text(recipe.title),
            subtitle: Text(recipe.ingredients),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RecipeDetailPage(recipe: recipe),
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Toggle favorite status.
                IconButton(
                  icon: Icon(recipe.isFavorite ? Icons.favorite : Icons.favorite_border),
                  onPressed: () => recipeProvider.toggleFavoriteStatus(recipe),
                  color: Colors.red,
                ),
                // Delete a recipe.
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => recipeProvider.deleteRecipe(recipe.id),
                  color: Colors.red,
                ),
              ],
            ),
          );
        },
      ),
      // Button to add a new recipe.
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
            icon: Icon(Icons.home_sharp),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber,
        onTap: _onItemTapped,
      ),
    );
  }

  // Handle bottom navigation tap.
  void _onItemTapped(int index) {
    if (index == 0) {
      _showFiltersDialog();
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const FavoritesPage()),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  // Dialog to select dietary filters.
  void _showFiltersDialog() {
    List<String> filterOptions = ['None', 'Vegetarian', 'Vegan', 'Gluten-Free'];
    List<String> tempFilters = List.from(activeFilters);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Filters"),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: filterOptions.map((option) {
                  return CheckboxListTile(
                    title: Text(option),
                    value: tempFilters.contains(option),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          if (option == 'None') {
                            tempFilters = ['None'];
                          } else {
                            tempFilters.remove('None');
                            tempFilters.add(option);
                          }
                        } else {
                          tempFilters.remove(option);
                        }
                      });
                    },
                  );
                }).toList(),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  activeFilters = tempFilters;
                });
                Navigator.pop(context);
              },
              child: const Text("Apply"),
            ),
          ],
        );
      },
    );
  }

  // Dialog to add a new recipe.
  void _showAddRecipeDialog(RecipeProvider recipeProvider) {
    TextEditingController titleController = TextEditingController();
    TextEditingController ingredientsController = TextEditingController();
    TextEditingController instructionsController = TextEditingController();

    // Local copy of dietary options for the dialog.
    Map<String, bool> localDietaryPrefs = Map.from(dietaryPreferences);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Recipe'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Title'),
                    ),
                    TextField(
                      controller: ingredientsController,
                      decoration: const InputDecoration(labelText: 'Ingredients'),
                    ),
                    TextField(
                      controller: instructionsController,
                      decoration: const InputDecoration(labelText: 'Instructions'),
                    ),
                    const SizedBox(height: 10),
                    const Text('Dietary Preferences'),
                    ...localDietaryPrefs.keys.map((key) {
                      return CheckboxListTile(
                        title: Text(key),
                        value: localDietaryPrefs[key],
                        onChanged: (bool? value) {
                          setState(() {
                            if (key == 'None' && value == true) {
                              localDietaryPrefs.updateAll((k, v) => false);
                              localDietaryPrefs[key] = true;
                            } else {
                              localDietaryPrefs['None'] = false;
                              localDietaryPrefs[key] = value ?? false;
                            }
                          });
                        },
                      );
                    }).toList(),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                final newRecipe = Recipe(
                  id: null,
                  title: titleController.text,
                  ingredients: ingredientsController.text,
                  instructions: instructionsController.text,
                  isFavorite: false,
                  dietaryPreferences: localDietaryPrefs.entries
                      .where((entry) => entry.value)
                      .map((entry) => entry.key)
                      .toList(),
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
