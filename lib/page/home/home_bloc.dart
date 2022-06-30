import 'package:reading_book_4k/base/bloc_base.dart';
import 'package:reading_book_4k/config/app_route.dart';
import 'package:rxdart/rxdart.dart';

import '../../data/titles.dart';

class HomeBloc extends BlocBase {
  @override
  void dispose() {
    listFav.close();
  }

  @override
  void init() async {
    listFav.sink.add(await getFav());
    titles.sink.add(await db.getTitles());
  }

  BehaviorSubject<List<Titles>> listFav =
      BehaviorSubject.seeded(List<Titles>.empty(growable: true));
  BehaviorSubject<List<Titles>> titles = BehaviorSubject();
  void openStory(Titles title) async {
    await navigator.pushed(AppRoute.readingScreen, argument: ['', title.id, title.title]);
    listFav.sink.add(await getFav());
  }

  Future<List<Titles>> getFav() async {
    return await db.getFav();
  }

  Future<List<Titles>> getSuggestions(String pattern) async {
    return titles.value.where((element) => element.title.contains(pattern)).toList();
  }
}
