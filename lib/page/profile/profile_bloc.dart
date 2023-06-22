import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:reading_book_4k/base/bloc_base.dart';
import 'package:reading_book_4k/config/app_route.dart';
import 'package:reading_book_4k/model/author.dart';
import 'package:reading_book_4k/repository/user/user_repository.dart';
import 'package:reading_book_4k/repository/user/user_repository_impl.dart';
import 'package:rxdart/rxdart.dart';

class ProfileBloc extends BlocBase {

  final FirebaseAuth _firebaseAuth = GetIt.I<FirebaseAuth>();

  final UserRepository _repo = UserRepositoryImpl();
  BehaviorSubject<bool> logoutStatus = BehaviorSubject();
  BehaviorSubject<Author> currentAuthor = BehaviorSubject();

  @override
  void dispose() {
    logoutStatus.close();
    currentAuthor.close();
  }

  @override
  Future<void> init() async {

    if (_firebaseAuth.currentUser != null) {
      currentAuthor.sink.add(await _repo.getMe(_firebaseAuth.currentUser!.uid));
      logoutStatus.sink.add(false);
    } else {
      logoutStatus.sink.add(true);
    }

    _firebaseAuth
      .authStateChanges()
      .listen((User? user) {
        if (user == null) {
          logoutStatus.sink.add(true);
        } else {
          _repo.getMe(_firebaseAuth.currentUser!.uid).then((value) => currentAuthor.sink.add(value));
          logoutStatus.sink.add(false);
        }
      });
  }

  void logout() {
    _repo.signOut();
  }

  void openEditProfile() async {
    await navigator.pushed(AppRoute.editProfile);
    currentAuthor.sink.add(await _repo.getMe(_firebaseAuth.currentUser!.uid));
  }
}