import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:pdf_text/pdf_text.dart';
import 'package:reading_book_4k/base/bloc_base.dart';
import 'package:reading_book_4k/config/app_route.dart';

import 'package:rxdart/rxdart.dart';
import 'package:flutter_tts/flutter_tts.dart';

class HomeBloc extends BlocBase {
  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  void init() {
    // TODO: implement init
  }
  BehaviorSubject<String> text = BehaviorSubject.seeded("");
  final FlutterTts flutterTts = FlutterTts();

  void openStory(String title) {
    navigator.pushed(AppRoute.readingScreen, argument: title);
  }

  void pickFile() async {
    var result = await FilePicker.platform.pickFiles();

    if (result != null) {
      PDFDoc doc = await PDFDoc.fromPath(result.files.single.path!);
      text.add(await doc.text);
    } else {
      log("Can't pick");
    }
    return null;
  }

  Future<void> play() async {
    await flutterTts.setLanguage("vi-VN");
    await flutterTts
        .setVoice({"name": "vi-vn-x-vif-network", "locale": "vi-VN"});
    await flutterTts.speak('8 Xin chào'); //
    // await flutterTts.setVoice({"name": "vi-vn-x-vic-network", "locale": "vi-VN"});
    // await flutterTts.speak('11 Xin chào');

    log('splitting');
    List<String> list = text.value.split('.');
    log('splitted');
    flutterTts.setQueueMode(1);
    var i = 0;
    while (i < list.length) {
      String sentence = list[i];
      var result = await flutterTts.speak(sentence);
      if (result == 1) i++;
    }
  }

  Future<void> pause() async {
    flutterTts.stop();
  }
}
