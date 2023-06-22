import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:reading_book_4k/assets/app_dimen.dart';
import 'package:reading_book_4k/base/bloc_base.dart';
import 'package:reading_book_4k/components/change_text_size_dialog.dart';
import 'package:reading_book_4k/config/app_route.dart';
import 'package:reading_book_4k/model/story.dart';
import 'package:reading_book_4k/repository/story/story_repository.dart';
import 'package:reading_book_4k/repository/story/story_repository_impl.dart';
import 'package:reading_book_4k/repository/user/user_repository.dart';
import 'package:reading_book_4k/repository/user/user_repository_impl.dart';
import 'package:reading_book_4k/services/app_shared_preference.dart';
import 'package:rxdart/rxdart.dart';

import '../../assets/app_string.dart';
import '../../model/author.dart';

class ReadingBloc extends BlocBase {
  @override
  void dispose() {
    isFav.close();
    playing.close();
    stories.close();
    progress.close();
    textSize.close();
    indexText.close();
    flutterTts.stop();
  }

  @override
  void init() {
    
  }

  StoryRepository repo = StoryRepositoryImpl();
  UserRepository userRepository = UserRepositoryImpl();

  BehaviorSubject<bool> isFav = BehaviorSubject();
  BehaviorSubject<bool> playing = BehaviorSubject.seeded(false);
  BehaviorSubject<Story?> stories = BehaviorSubject();
  BehaviorSubject<bool> loading = BehaviorSubject();
  BehaviorSubject<double> progress = BehaviorSubject.seeded(0.0);
  BehaviorSubject<bool> allowDelete = BehaviorSubject.seeded(false);
  BehaviorSubject<bool> allowUpdate = BehaviorSubject.seeded(false);
  BehaviorSubject<int> speed = BehaviorSubject.seeded(1);
  BehaviorSubject<double> textSize =
      BehaviorSubject.seeded(AppDimen.textSizeBody2);
  BehaviorSubject<int> indexText = BehaviorSubject.seeded(0);
  BehaviorSubject<String>authorName = BehaviorSubject();

  final pref = GetIt.I<AppSharedPreference>();

  String text = "";
  final flutterTts = FlutterTts();
  Future<void> play() async {
    await flutterTts.setLanguage("vi-VN");
    await flutterTts
        .setVoice({"name": "vi-vn-x-vif-network", "locale": "vi-VN"});
    await flutterTts.setSpeechRate(Platform.isAndroid ? 0.5 : 0.395);
    playing.sink.add(true);
    List<String> list =
        (text.isNotEmpty) ? text.split(RegExp(r'\.|\n')) : stories.value!.content.split(RegExp(r'\.|\n'));

    flutterTts.setQueueMode(1);

    indexText.sink.add((progress.value * list.length).floor());
    var i = indexText.value;
    await flutterTts.speak(list[i]);
    flutterTts.setCompletionHandler(
      () async {
        if (i < list.length - 1) {
          i++;
          indexText.sink.add(i);
          progress.sink.add((i + 1) / list.length);
          await flutterTts.speak(list[i]);
        } else {
          indexText.sink.add(0);
          progress.sink.add(0);
          playing.sink.add(false);
        }
      },
    );
  }

  Future<void> pause() async {
    playing.sink.add(false);
    flutterTts.stop();
  }

  void changeProgress(double newValue) async {
    progress.sink.add(newValue);
    if (playing.value) {
      await pause();
      await play();
    }
  }

  void getStoryInfo(String id) async {
    stories.sink.add(await repo.getStoryById(id));
    isFav.sink.add(await repo.isFav(id));
    authorName.sink.add((await repo.getAuthor(id))?.name ?? AppString.unknown);
  }

  void addToFav(Story story) async {
    if (pref.getString('authorId') == null) {
      Fluttertoast.showToast(
        msg: AppString.needLogin,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }
    await repo.addToFav(story);
    isFav.sink.add(true);
  }

  void removeFromFav(Story story) async {
    if (pref.getString('authorId') == null) {
      Fluttertoast.showToast(
        msg: AppString.needLogin,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }
    await repo.deleteFromFav(story);
    isFav.sink.add(false);
  }

  void backPress() {
    navigator.pop();
  }

  void changeTextSize(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => ChangeTextSizeDialog(
        callback: (String nameTextSize) {
          switch (nameTextSize) {
            case 'Rất nhỏ':
              textSize.sink.add(AppDimen.textSizeSubtext);
              break;
            case 'Nhỏ':
              textSize.sink.add(AppDimen.textSizeBody3);
              break;
            case 'Vừa':
              textSize.sink.add(AppDimen.textSizeBody2);
              break;
            case 'Lớn':
              textSize.sink.add(AppDimen.textSizeBody1);
              break;
            case 'Rất lớn':
              textSize.sink.add(AppDimen.textSizeHeading3);
              break;
          }
          Navigator.pop(context);
        },
        currentSize: textSize.value,
      ),
    );
  }

  void getAccess(String storyId) async {
    allowDelete.sink.add(await repo.getAccess(storyId));
    allowUpdate.sink.add(await repo.getAccess(storyId));
  }

  void delete(Story story) async {
    loading.sink.add(true);
    final result = await repo.deleteStories(story);
    if (result) {
      Fluttertoast.showToast(
        msg: AppString.success,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      Future.delayed(const Duration(milliseconds: 500)).then((value) => back());
    } else {
      Fluttertoast.showToast(
        msg: AppString.failure,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
    loading.sink.add(false);
  }

  void back() {
    navigator.pop();
  }

  void openUpdateStory(String storyId) async {
    await navigator.pushed(AppRoute.updateStory, argument: [storyId]);
    getStoryInfo(storyId);
  }

  void changeSpeed() async {
    switch (speed.value) {
      case 1:
        speed.sink.add(2);
        await pause();
        await flutterTts.setSpeechRate(2.0);
        await play();
        break;
      case 2:
        speed.sink.add(0);
        await pause();
        await flutterTts.setSpeechRate(0.5);
        await play();
        break;
      case 0:
        speed.sink.add(1);
        await pause();
        await flutterTts.setSpeechRate(1);
        await play();
        break;
    }
  }
}
