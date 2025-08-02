import 'dart:async';
import 'package:epubreader/model/novel_read.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class NovelReadBookDbHelper {
  static final NovelReadBookDbHelper _instance = NovelReadBookDbHelper._internal();
  factory NovelReadBookDbHelper() => _instance;
  static Database? _database;

  NovelReadBookDbHelper._internal();

  String databaseName = 'read';

  Future<Database> initDB() async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, '$databaseName.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $databaseName (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      percentage REAL,
      bookTitle TEXT NOT NULL,
      bookAuthor TEXT NOT NULL,
      cfi TEXT NOT NULL
    )
  ''');
  }

  Future<int?> saveNovelRead(NovelRead novel) async {
    try{
      final db = await initDB();
      var result = await db.insert(
        databaseName,
        novel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return result;
    }catch(e){
      return 0;
    }
  }

  Future<int?> updateNovelRead(NovelRead novel) async {
    try{
      final db = await initDB();
      int? id = novel.id;
      if(id == null) return null;
      var result = await db.update(
          databaseName, novel.toMap(),
          where: 'id = ?', whereArgs: [id]);
      return result;
    }catch(e){
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> fetchRead(String bookname) async {
    final db = await initDB();
    return await db.query(databaseName,where: 'bookTitle = ?', whereArgs: [bookname]);
  }

  Future<void> clearAll() async {
    final db = await initDB();
    await db.delete(databaseName);
  }
}
