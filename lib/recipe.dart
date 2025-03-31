// This file defines our Recipe model.
import 'dart:convert';

class Recipe {
  final int? id;
  final String title;
  final String ingredients;
  final String instructions;
  bool isFavorite;
  List<String> dietaryPreferences;

  Recipe({
    this.id,
    required this.title,
    required this.ingredients,
    required this.instructions,
    this.isFavorite = false,
    this.dietaryPreferences = const [],
  });

  // Convert a Recipe to a Map for DB storage.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'ingredients': ingredients,
      'instructions': instructions,
      'isFavorite': isFavorite ? 1 : 0,
      'dietaryPreferences': jsonEncode(dietaryPreferences),
    };
  }

  // Create a Recipe object from a DB Map.
  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'],
      title: map['title'] as String,
      ingredients: map['ingredients'] as String,
      instructions: map['instructions'] as String,
      isFavorite: map['isFavorite'] == 1,
      dietaryPreferences: map['dietaryPreferences'] != null &&
          map['dietaryPreferences'].toString().isNotEmpty
          ? (jsonDecode(map['dietaryPreferences']) as List).cast<String>()
          : [],
    );
  }
}
