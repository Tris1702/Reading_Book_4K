import 'package:reading_book_4k/base/bloc_base.dart';
import 'package:reading_book_4k/data/titles.dart';
import 'package:reading_book_4k/services/titles_service.dart';
import 'package:rxdart/rxdart.dart';

class FavouriteBloc extends BlocBase {
  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  void init() {
    //get data of titles
    titles.value.add(TitleService.titles[0]);
    titles.sink.add(titles.value);
  }

  BehaviorSubject<List<Titles>> titles =
      BehaviorSubject.seeded(List<Titles>.empty(growable: true));
}
