class Recipe {
  final int? id;
  final String title;
  final String ingredients;
  final String instructions;
  List<String> dietaryPreferences;
  bool isFavorite;  // Attribute to track if the recipe is marked as favorite

  Recipe({
    this.id,
    required this.title,
    required this.ingredients,
    required this.instructions,
    this.dietaryPreferences = const [],
    this.isFavorite = false,  // Default value for favorite status
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'ingredients': ingredients,
      'instructions': instructions,
      'dietaryPreferences': dietaryPreferences.join(', '),  // Store as a comma-separated string
      'isFavorite': isFavorite ? 1 : 0,  // Store as integer for database compatibility
    };
  }

  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'],
      title: map['title'],
      ingredients: map['ingredients'],
      instructions: map['instructions'],
      dietaryPreferences: map['dietaryPreferences']?.split(', ') ?? [],  // Convert back to list from comma-separated string
      isFavorite: map['isFavorite'] == 1,  // Convert from integer to boolean
    );
  }
}
