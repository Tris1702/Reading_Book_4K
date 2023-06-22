import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reading_book_4k/base/bloc_base.dart';
import 'package:reading_book_4k/model/story.dart';
import 'package:reading_book_4k/repository/story/story_repository.dart';
import 'package:reading_book_4k/repository/story/story_repository_impl.dart';
import 'package:reading_book_4k/services/app_shared_preference.dart';
import 'package:rxdart/rxdart.dart';

import '../../assets/app_string.dart';

class UploadBloc extends BlocBase {

  final ImagePicker picker = ImagePicker();
  BehaviorSubject<File> file = BehaviorSubject();
  BehaviorSubject<bool> loading = BehaviorSubject.seeded(false);
  bool isPublic= true;

  StoryRepository repo = StoryRepositoryImpl();
  final pref = GetIt.I<AppSharedPreference>();
  final storage = GetIt.I<FirebaseStorage>();

  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  void init() {
    // TODO: implement init
  }

  void pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) file.sink.add(File(pickedFile.path));
  }

  void addStory(String title, String content) async {
    loading.sink.add(true);
    final authorId = pref.getString('authorId');

    if (authorId != null) {
      final path = DateTime.now().toIso8601String();
      final Reference imageRef = storage.ref().child(path);
      await imageRef.putFile(file.value);
      final String downloadUrl = await imageRef.getDownloadURL();
      final story = Story(authorId: authorId, content: content, coverLink: downloadUrl, isGlobal: isPublic, title: title);
      final result = await repo.upLoadStories(story);
      loading.sink.add(false);
      if (result){
        Fluttertoast.showToast(
          msg: AppString.success,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
        back();
      } else {
        Fluttertoast.showToast(
          msg: AppString.failure,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    } else {
      loading.sink.add(false);
      Fluttertoast.showToast(
          msg: AppString.failure,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
    }
  }

  void back() {
    navigator.pop();
  }

}