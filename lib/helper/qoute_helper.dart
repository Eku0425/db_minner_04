import 'package:path/path.dart';

import 'package:sqflite/sqflite.dart';

import '../modal/db_modal.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future readData() async {
    Database? db = await database;
    String sql = '''
    SELECT * FROM likedQuotes;
    ''';
    return await db!.rawQuery(sql);
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'likedQuotes.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          '''
          CREATE TABLE likedQuotes (
            category TEXT,
            quote TEXT,
            author TEXT,
            isLiked TEXT
          )
          ''',
        );
      },
    );
  }

  Future<void> insertData(
      String category, String quote, String author, int isLiked) async {
    Database? db = await database;
    String sql = '''
    INSERT INTO likedQuotes(category,quote,author,isLiked) VALUES(?,?,?,?);
    ''';
    List args = [category, quote, author, isLiked];
    await db!.rawInsert(sql, args);
  }

  Future showCategoryWiseData(String category) async {
    Database? db = await database;
    String sql = '''
    SELECT * FROM likedQuotes WHERE category=?
    ''';
    List args = [category];
    return await db!.rawQuery(sql, args);
  }

  Future<void> deleteLikedQuote(String quote) async {
    final db = await database;
    await db.delete(
      'likedQuotes',
      where: 'quote = ?',
      whereArgs: [quote],
    );
  }

  Future<List<Quote>> getLikedQuotes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('likedQuotes');

    return List.generate(maps.length, (i) {
      return Quote.fromJson(maps[i]);
    });
  }
}
