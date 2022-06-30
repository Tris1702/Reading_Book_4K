import 'package:reading_book_4k/base/bloc_base.dart';
import 'package:reading_book_4k/data/titles.dart';
import 'package:rxdart/rxdart.dart';

import '../../config/app_route.dart';

class FavouriteBloc extends BlocBase {
  @override
  void dispose() {
    titles.close();
  }

  @override
  void init() async {
    //get data of titles
    titles.sink.add(await db.getFav());
  }

  BehaviorSubject<List<Titles>> titles =
      BehaviorSubject.seeded(List<Titles>.empty(growable: true));

  void openStory(Titles title) async{
    await navigator.pushed(AppRoute.readingScreen, argument: ['', title.id, title.title]);
    titles.sink.add(await db.getFav());
  }
}
