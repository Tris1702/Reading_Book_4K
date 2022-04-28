import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:reading_book_4k/data/stories.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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

  Future<List<Stories>> getStories() async {
    final List<Map<String, dynamic>> maps = await database.query('stories');
    return List.generate(maps.length, (index) {
      return Stories(
        name: maps[index]['name'],
        content: maps[index]['content'],
      );
    });
  }

  Future<Stories> getStoryByName(String name) async {
    String query = 'SELECT * FROM stories WHERE name = \'$name\'';
    log(query);
    final List<Map<String, dynamic>> maps = await database.rawQuery(query);
    // print(maps);
    return Stories(
      name: maps[0]['name'],
      content: maps[0]['content'],
    );
  }

}
