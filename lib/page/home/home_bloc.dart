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
  }

  BehaviorSubject<List<Titles>> listFav =
      BehaviorSubject.seeded(List<Titles>.empty(growable: true));
  void openStory(String title) {
    navigator.popAndPush(AppRoute.readingScreen, argument: ['', title, 'home']);
  }

  Future<List<Titles>> getFav() async {
    return await fav.getStories();
  }
}
