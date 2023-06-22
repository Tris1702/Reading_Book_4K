import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:pdf_text/pdf_text.dart';
import 'package:reading_book_4k/config/app_color.dart';
import 'package:reading_book_4k/config/app_route.dart';
import 'package:reading_book_4k/repository/story/story_repository.dart';
import 'package:reading_book_4k/repository/story/story_repository_impl.dart';
import 'package:reading_book_4k/services/app_shared_preference.dart';
import 'package:rxdart/rxdart.dart';
import '../../assets/app_string.dart';
import '../../base/bloc_base.dart';
import '../../model/story.dart';

class OnphoneBloc extends BlocBase {

  BehaviorSubject<List<Story>> stories = BehaviorSubject();
  StoryRepository repo = StoryRepositoryImpl();
  final pref = GetIt.I<AppSharedPreference>();

  @override
  void dispose() {}

  @override
  void init() {
    getMyStories();
  }

  void openUploadStoryScreen() {
    if (pref.getString('authorId') == null) {
      Fluttertoast.showToast(
        msg: AppString.needLogin,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }
    navigator.pushed(AppRoute.upload);
  }

  void getMyStories() async {
    stories.sink.add(await repo.getMyStories());
  }

  void openStory(Story story) async{
    await navigator.pushed(AppRoute.readingScreen, argument: [story]);
    stories.sink.add(await repo.getMyStories());
  }

  Future<List<Story>> getSuggestions(String pattern) async {
    return stories.value.where((element) => element.title.contains(pattern)).toList();
  }
}
