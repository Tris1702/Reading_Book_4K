import 'package:get_it/get_it.dart';
import 'package:reading_book_4k/services/database_service.dart';
import 'package:reading_book_4k/services/navigator_service.dart';

class Utilitize {
  var navigator = GetIt.I<NavigatorService>();
  var db = GetIt.I<DatabaseService>();
  void logData(String key, String message) {
    // ignore: avoid_print
    print('==>$key:$message');
  }
}
