import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:reading_book_4k/data/titles.dart';
import 'package:reading_book_4k/services/titles_service.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class FavoriteDatabase {
  late Database database;
  Future<Database> getDB() async {
    database = await initDB();
    return database;
  }

  Future<Database> initDB() async {
    var dbName = 'favorites.sqlite';
    var databasePath = await getDatabasesPath();
    var path = join(databasePath, dbName);
    var exist = await databaseExists(path);
    if (!exist) {
      log("Creating new copy from asset");
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}
      ByteData data = await rootBundle.load(join('assets', dbName));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
      log('Db is copied');
    } else {
      log('db already exist');
    }
    return await openDatabase(path);
  }

  Future<List<Titles>> getStories() async {
    final List<Map<String, dynamic>> maps = await database.query('favorites');
    if (maps.isEmpty) return List<Titles>.empty(growable: true);
    return List.generate(maps.length, (index) {
      return Titles(
        name: maps[index]['name'] as String,
        path: maps[index]['path'] as String,
      );
    });
  }

  Future<void> addStory(String name) async {
    var path =
        TitleService.titles.firstWhere((element) => element.name == name).path;
    String sql =
        'INSERT INTO favorites (name, path) VALUES (\'$name\',\'$path\')';
    await database.rawInsert(sql);
  }

  Future<void> deleteStory(String name) async {
    String sql = 'DELETE FROM favorites WHERE name = \'$name\'';
    await database.rawDelete(sql);
  }

  Future<bool> isFavourite(String name) async {
    String sql = 'SELECT * FROM favorites WHERE name = \'$name\'';
    final List<Map<String, dynamic>> maps = await database.rawQuery(sql);
    return maps.isNotEmpty;
  }
}
