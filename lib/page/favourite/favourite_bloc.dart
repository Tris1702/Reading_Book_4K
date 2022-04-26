import 'package:reading_book_4k/base/bloc_base.dart';
import 'package:reading_book_4k/data/titles.dart';
import 'package:rxdart/rxdart.dart';

class FavouriteBloc extends BlocBase {
  @override
  void dispose() {
    titles.close();
  }

  @override
  void init() async {
    //get data of titles
    titles.sink.add(await fav.getStories());
  }

  BehaviorSubject<List<Titles>> titles =
      BehaviorSubject.seeded(List<Titles>.empty(growable: true));
}
