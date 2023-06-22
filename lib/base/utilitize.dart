import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:reading_book_4k/services/navigator_service.dart';

class Utilitize {
  var navigator = GetIt.I<NavigatorService>();
  var firebaseAuth = GetIt.I<FirebaseAuth>();
 
  void logData(String key, String message) {
    // ignore: avoid_print
    print('==>$key:$message');
  }

  static List<String> convertListDynamicToStringList(List<dynamic> list) {
    List<String> strings = [];
    for (var item in list) {
      if (item is String) {
        strings.add(item);
      } else {
        // Do something with non-string items
      }
    }
    return strings;
  }
}
