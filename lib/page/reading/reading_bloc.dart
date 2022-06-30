import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:reading_book_4k/assets/app_dimen.dart';
import 'package:reading_book_4k/base/bloc_base.dart';
import 'package:reading_book_4k/components/change_text_size_dialog.dart';
import 'package:reading_book_4k/config/app_route.dart';
import 'package:reading_book_4k/data/stories.dart';
import 'package:rxdart/rxdart.dart';

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
  void init() async {
    await flutterTts.setLanguage("vi-VN");
    await flutterTts
        .setVoice({"name": "vi-vn-x-vif-network", "locale": "vi-VN"});
    await flutterTts.setSpeechRate(Platform.isAndroid ? 0.5 : 0.395);
  }

  BehaviorSubject<bool> isFav = BehaviorSubject();

  BehaviorSubject<bool> playing = BehaviorSubject.seeded(false);
  BehaviorSubject<Stories?> stories = BehaviorSubject();
  BehaviorSubject<double> progress = BehaviorSubject.seeded(0.0);
  BehaviorSubject<double> textSize =
      BehaviorSubject.seeded(AppDimen.textSizeBody2);

  BehaviorSubject<int> indexText = BehaviorSubject.seeded(0);
  String text = "";
  final flutterTts = FlutterTts();
  Future<void> play() async {
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
    stories.sink.add(await db.getStoryById(id));
    isFav.sink.add(await db.isFav(id));
  }

  void addToFav(String id) {
    db.addFav(id);
    isFav.sink.add(true);
  }

  void removeFromFav(String id) {
    db.deleteFav(id);
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
}
