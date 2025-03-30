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
  int _selectedIndex = 0;

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
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(recipe.isFavorite ? Icons.favorite : Icons.favorite_border),
                  onPressed: () => recipeProvider.toggleFavoriteStatus(recipe),
                  color: Colors.red,
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => recipeProvider.deleteRecipe(recipe.id!),
                  color: Colors.red,
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
        onPressed: () {},  // Implement add recipe dialog here
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
      if (index == 2) {  // Navigate to Favorites Page when Favorites tab is tapped
        Navigator.push(context, MaterialPageRoute(builder: (context) => const FavoritesPage()));
      }
    });
  }
}
