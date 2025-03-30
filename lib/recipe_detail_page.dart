import 'package:flutter/material.dart';
import 'recipe.dart';  // Make sure to import your Recipe model class

class RecipeDetailPage extends StatelessWidget {
  final Recipe recipe;

  RecipeDetailPage({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.title),
        backgroundColor: Colors.green[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Ingredients', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(recipe.ingredients),
            SizedBox(height: 20),
            Text('Instructions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(recipe.instructions),
          ],
        ),
      ),
    );
  }
}
