import 'package:restaurant/data/model/restaurant.dart';
import 'package:sqflite/sqflite.dart';

class SqliteService {
  static const String _databaseName = 'favoritelist.db';
  static const String _tableName = 'favorites';
  static const int _version = 1;

  Future<void> createTables(Database database) async {
    await database.execute('''
      CREATE TABLE $_tableName (
        id TEXT PRIMARY KEY,
        name TEXT,
        description TEXT,
        pictureId TEXT,
        city TEXT,
        rating REAL,
        address TEXT
      )
      ''');
  }

  Future<Database> _initializeDb() async {
    return openDatabase(
      _databaseName,
      version: _version,
      onCreate: (Database database, int version) async {
        await createTables(database);
      },
    );
  }

  Future<int> insertItem(Restaurant restaurant) async {
    final db = await _initializeDb();
    final data = {
      'id': restaurant.id,
      'name': restaurant.name,
      'description': restaurant.description,
      'pictureId': restaurant.pictureId,
      'city': restaurant.city,
      'rating': restaurant.rating,
      'address': restaurant.address,
    };

    final id = await db.insert(
      _tableName,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<List<Restaurant>> getAllItems() async {
    final db = await _initializeDb();
    final results = await db.query(_tableName, orderBy: "id");

    return results.map((result) => Restaurant.fromJson(result)).toList();
  }

  Future<int> removeItem(String id) async {
    final db = await _initializeDb();

    final result =
        await db.delete(_tableName, where: "id = ?", whereArgs: [id]);
    return result;
  }

  Future<bool> getItemById(String id) async {
    final db = await _initializeDb();
    final results =
        await db.query(_tableName, where: "id = ?", whereArgs: [id], limit: 1);

    return results.isNotEmpty;
  }
}
