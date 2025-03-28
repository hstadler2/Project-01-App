class Recipe {
  final int? id;
  final String title;
  final String ingredients;
  final String instructions;

  Recipe({
    this.id,
    required this.title,
    required this.ingredients,
    required this.instructions,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'ingredients': ingredients,
      'instructions': instructions,
    };
  }

  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'],
      title: map['title'],
      ingredients: map['ingredients'],
      instructions: map['instructions'],
    );
  }
}
