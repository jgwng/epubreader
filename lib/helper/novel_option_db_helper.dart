import 'dart:async';
import 'package:epubreader/model/novel_option.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class NovelOptionDBHelper {
  static final NovelOptionDBHelper _instance = NovelOptionDBHelper._internal();
  factory NovelOptionDBHelper() => _instance;
  static Database? _database;

  NovelOptionDBHelper._internal();

  String databaseName = 'option';

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
        fontSize INTEGER,
        lineHeight INTEGER,
        horizontalPadding INTEGER,
        verticalPadding INTEGER,
        fontFamily TEXT NOT NULL,
        pageNavigation TEXT NOT NULL,
        curlAnimation TEXT NOT NULL,
        backgroundColor TEXT NOT NULL,
        fontColor TEXT NOT NULL
      )
    ''');
  }

  Future<int?> saveOption(NovelViewerOption option) async {
    try{
      final db = await initDB();
      int result = await db.insert(
        databaseName,
        option.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return result;
    }catch(e){
      return null;
    }
  }

  Future<int?> updateOption(NovelViewerOption option) async {
    try{
      final db = await initDB();
      int? id = option.id;
      if(id == null) return null;
      var result = await db.update(
          databaseName, option.toMap(),
          where: 'id = ?', whereArgs: [id]);
      return result;
    }catch(e){
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> fetchOption() async {
    final db = await initDB();
    return await db.query(databaseName,where: 'id = 1');
  }

  Future<void> clearAll() async {
    final db = await initDB();
    await db.delete(databaseName);
  }
}
