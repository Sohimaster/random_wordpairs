import 'package:path/path.dart';
import 'package:random_wordpairs/random_words.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('wordpairs.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getApplicationDocumentsDirectory();
    final path = join(dbPath.path, filePath);

    return await openDatabase(path, version: 1, onCreate: (db, version) {
      return db.execute('''
        CREATE TABLE wordpairs (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          firstWord TEXT,
          secondWord TEXT
        )
      ''');
    });
  }

  Future<void> insertPair(Pair pair) async {
    final db = await instance.database;
    await db.insert(
      'wordpairs',
      pair.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Pair>> loadPairs() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('wordpairs');

    return List.generate(maps.length, (i) {
      return Pair(maps[i]['firstWord'], maps[i]['secondWord']);
    });
  }

  Future<void> deletePair(Pair pair) async {
    final db = await instance.database;
    await db.delete(
      'wordpairs',
      where: 'firstWord = ? AND secondWord = ?',
      whereArgs: [pair.first, pair.second],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
