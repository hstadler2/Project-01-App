import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'recipe_provider.dart';
import 'main_page.dart';

void main() {
  runApp(const RecipeApp());
}

class RecipeApp extends StatelessWidget {
  const RecipeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RecipeProvider()..loadRecipes(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Recipe App',
        home: MainPage(),
      ),
    );
  }
}
