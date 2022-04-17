import 'package:reading_book_4k/data/stories.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  late Database database;
  Future<void> init() async {
    // if (database == null) {
    //   database = await initDb();
    // }
  }
  // Future<Database> initDb() async{
  // }

  Future<List<Stories>> getStories() async {
    final List<Map<String, dynamic>> maps = await database.query('stories');
    return List.generate(maps.length, (index) {
      return Stories(
        id: maps[index]['id'],
        name: maps[index]['name'],
        content: maps[index]['content'],
      );
    });
  }

  Future<Stories> getStoryByName(String name) async {
    String query = 'SELECT * FROM stories WHERE name = \'$name\'';
    print(query);
    final List<Map<String, dynamic>> maps = await database.rawQuery(query);
    return Stories(
      id: maps[0]['id'],
      name: maps[0]['name'],
      content: maps[0]['content'],
    );
  }
}
