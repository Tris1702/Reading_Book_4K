import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:reading_book_4k/data/stories.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../data/titles.dart';

class DatabaseService {
  late Database database;
  Future<Database> getDB() async {
    database = await initDB();
    return database;
  }

  Future<Database> initDB() async {
    var dbName = 'data.sqlite';
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

  Future<List<Titles>> getTitles() async {
    final List<Map<String, dynamic>> maps = await database.query('titles');
    return List.generate(maps.length, (index) {
      return Titles.fromMap(maps[index]);
    });
  }

  Future<List<Titles>> getFav() async {
    final List<Map<String, dynamic>> maps = await database.query('titles');
    List<Titles> allList = List.generate(maps.length, (index) {
      return Titles(
          id: maps[index]['id'],
          title: maps[index]['title'],
          thumb: maps[index]['thumb'],
          isFav: maps[index]['isFav']);
    });
    return allList.where((title) => title.isFav == 1).toList();
  }

  Future<void> addFav(String id) async {
    String sql = 'UPDATE titles SET isFav = 1 WHERE id = \'$id\'';
    await database.rawUpdate(sql);
  }

  Future<void> deleteFav(String id) async {
    String sql = 'UPDATE titles SET isFav = 0 WHERE id = \'$id\'';
    await database.rawDelete(sql);
  }

  Future<bool> isFav(String id) async {
    String sql = 'SELECT isFav from titles WHERE id = \'$id\'';
    final List<Map<String, dynamic>> maps = await database.rawQuery(sql);
    log(maps[0].toString());
    return (maps[0]['isFav'] as int) == 1;
  }

  Future<Stories> getStoryById(String id) async {
    String query = 'SELECT * FROM stories WHERE id = \'$id\'';
    log(query);
    final List<Map<String, dynamic>> maps = await database.rawQuery(query);
    // print(maps);
    return Stories(
      id: maps[0]['id'],
      name: maps[0]['name'],
      content: maps[0]['content'],
    );
  }
}
