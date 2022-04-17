import 'package:flutter/material.dart';
import 'package:reading_book_4k/base/bloc_base.dart';
import 'package:reading_book_4k/page/favourite/favourite_screen.dart';
import 'package:reading_book_4k/page/home/home_screen.dart';
import 'package:reading_book_4k/page/library/library_screen.dart';
import 'package:reading_book_4k/page/onphone/onphone_screen.dart';
import 'package:rxdart/rxdart.dart';

class OnBoardBloc extends BlocBase {
  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  void init() {
    // TODO: implement init
  }

  BehaviorSubject<int> index = BehaviorSubject.seeded(0);
  changeIndex(i) {
    index.sink.add(i);
    page.sink.add(pages[i]);
  }

  List<Widget> pages = [
    const HomeScreen(),
    const FavouriteScreen(),
    const LibraryScreen(),
    const OnphoneScreen()
  ];

  BehaviorSubject<Widget> page = BehaviorSubject.seeded(const HomeScreen());
}
