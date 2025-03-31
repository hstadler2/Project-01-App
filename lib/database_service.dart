// This file handles all our SQFlite database operations.
import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'recipe.dart';

class DatabaseService {
  // Singleton pattern to use one database instance.
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;

  static Database? _database;

  DatabaseService._internal();

  // Get the database instance or initialize it if needed.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  // Create/open the database and set up the schema.
  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'recipes.db');
    return openDatabase(
      path,
      version: 2, // Bumped version to force schema update if needed.
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE recipes(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            ingredients TEXT,
            instructions TEXT,
            isFavorite INTEGER,
            dietaryPreferences TEXT
          )
        ''');
      },
      // Simple upgrade: drop and recreate the table.
      onUpgrade: (db, oldVersion, newVersion) async {
        await db.execute("DROP TABLE IF EXISTS recipes");
        await db.execute('''
          CREATE TABLE recipes(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            ingredients TEXT,
            instructions TEXT,
            isFavorite INTEGER,
            dietaryPreferences TEXT
          )
        ''');
      },
    );
  }

  // Insert a new recipe into the database.
  Future<int> insertRecipe(Recipe recipe) async {
    final db = await database;
    return await db.insert('recipes', recipe.toMap());
  }

  // Retrieve all recipes from the database.
  Future<List<Recipe>> getRecipes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('recipes');
    return List.generate(maps.length, (i) => Recipe.fromMap(maps[i]));
  }

  // Update a recipe in the database.
  Future<int> updateRecipe(Recipe recipe) async {
    final db = await database;
    return await db.update(
      'recipes',
      recipe.toMap(),
      where: 'id = ?',
      whereArgs: [recipe.id],
    );
  }

  // Delete a recipe from the database.
  Future<int> deleteRecipe(int id) async {
    final db = await database;
    return await db.delete(
      'recipes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
