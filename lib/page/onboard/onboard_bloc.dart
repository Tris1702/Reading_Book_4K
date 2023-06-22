import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:reading_book_4k/base/bloc_base.dart';
import 'package:reading_book_4k/page/favourite/favourite_screen.dart';
import 'package:reading_book_4k/page/home/home_screen.dart';
import 'package:reading_book_4k/page/library/library_screen.dart';
import 'package:reading_book_4k/page/onphone/onphone_screen.dart';
import 'package:rxdart/rxdart.dart';

import '../profile/profile_screen.dart';

class OnBoardBloc extends BlocBase {
  @override
  void dispose() {
    index.close();
    page.close();
  }

  @override
  void init() {
    log('oninit been called');
    pages = [
      HomeScreen(
        callToNav: (type) {
          if (type == 'THƯ VIỆN') {
            changeIndex(2);
          } else {
            changeIndex(1);
          }
        },
      ),
      const FavouriteScreen(),
      const LibraryScreen(),
      const OnphoneScreen(),
      const ProfileScreen(),
    ];
  }

  BehaviorSubject<int> index = BehaviorSubject.seeded(0);
  changeIndex(i) {
    index.sink.add(i);
    page.sink.add(pages[i]);
  }

  late final List<Widget> pages;

  BehaviorSubject<Widget> page = BehaviorSubject();
}
