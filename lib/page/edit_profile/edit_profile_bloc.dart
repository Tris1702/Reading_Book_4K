import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reading_book_4k/base/bloc_base.dart';
import 'package:reading_book_4k/repository/user/user_repository.dart';
import 'package:reading_book_4k/repository/user/user_repository_impl.dart';
import 'package:rxdart/rxdart.dart';

import '../../assets/app_string.dart';
import '../../model/author.dart';

class EditProfileBloc extends BlocBase {
  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  void init() async {
    author.sink.add(await repo.getMe(_firebaseAuth.currentUser!.uid));
  }

  final ImagePicker picker = ImagePicker();
  final FirebaseAuth _firebaseAuth = GetIt.I<FirebaseAuth>();
  UserRepository repo = UserRepositoryImpl();
  BehaviorSubject<bool> loading = BehaviorSubject.seeded(false);
  BehaviorSubject<Author> author = BehaviorSubject();
  BehaviorSubject<File> file = BehaviorSubject();

  TextEditingController nameController = TextEditingController();
  final storage = GetIt.I<FirebaseStorage>();

  void pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) file.sink.add(File(pickedFile.path));
  }

  void updateProfile() async {
    loading.sink.add(true);
    try {
      if (file.hasValue) {
        final path = DateTime.now().toIso8601String();
        final Reference imageRef = storage.ref().child(path);
        await imageRef.putFile(file.value);
        final downloadUrl = await imageRef.getDownloadURL();
        author.value.avatarLink = downloadUrl;
      }
      author.value.name = nameController.text;
      await repo.updateAuthorInfo(author.value);
      loading.sink.add(false);
      Fluttertoast.showToast(
        msg: AppString.success,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      navigator.pop();
    } catch(e) {
      loading.sink.add(false);
      Fluttertoast.showToast(
        msg: AppString.failure,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

}