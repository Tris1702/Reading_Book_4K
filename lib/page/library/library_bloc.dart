import 'dart:developer';

import 'package:reading_book_4k/base/bloc_base.dart';
import 'package:rxdart/rxdart.dart';

import '../../config/app_route.dart';
import '../../data/titles.dart';

class LibraryBloc extends BlocBase{
  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  void init() async {
    titles.sink.add(await db.getTitles());
  }

  BehaviorSubject<List<Titles>> titles = BehaviorSubject();

  void openStory(Titles title){
    navigator.pushed(AppRoute.readingScreen, argument: ['', title.id, title.title]);
  }
}