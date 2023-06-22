import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reading_book_4k/base/bloc_base.dart';
import 'package:reading_book_4k/model/story.dart';
import 'package:reading_book_4k/repository/story/story_repository.dart';
import 'package:reading_book_4k/repository/story/story_repository_impl.dart';
import 'package:rxdart/rxdart.dart';

import '../../assets/app_string.dart';
import '../../services/app_shared_preference.dart';

class UpdateStoryBloc extends BlocBase {

  final ImagePicker picker = ImagePicker();
  BehaviorSubject<File> file = BehaviorSubject();
  BehaviorSubject<bool> loading = BehaviorSubject.seeded(false);
  bool isPublic= true;

  StoryRepository repo = StoryRepositoryImpl();
  final pref = GetIt.I<AppSharedPreference>();
  final storage = GetIt.I<FirebaseStorage>();
  BehaviorSubject<Story> story = BehaviorSubject();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  void init() async {
    
  }
  
  void pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) file.sink.add(File(pickedFile.path));
  }

  void getStory(String storyId) async {
    Story? gotStory = await repo.getStoryById(storyId);
    if (gotStory == null) {
      Fluttertoast.showToast(
          msg: AppString.failure,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
    } else {
      titleController.text = gotStory.title;
      contentController.text = gotStory.content;
      story.sink.add(gotStory);
    }
  }

  void updateStory(String storyId, String title, String content) async {
    loading.sink.add(true);
    final authorId = pref.getString('authorId');

    if (authorId != null) {
      String? downloadUrl;
      if (file.hasValue) {
        final path = DateTime.now().toIso8601String();
        final Reference imageRef = storage.ref().child(path);
        await imageRef.putFile(file.value);
        downloadUrl = await imageRef.getDownloadURL();
      }
      final story = Story(id: storyId, authorId: authorId, content: content, coverLink: downloadUrl ?? "", isGlobal: isPublic, title: title);
      final result = await repo.updateStories(story, downloadUrl != null);
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