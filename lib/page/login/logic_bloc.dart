import 'package:reading_book_4k/base/bloc_base.dart';
import 'package:reading_book_4k/config/app_route.dart';
import 'package:reading_book_4k/repository/user/response_auth.dart';
import 'package:reading_book_4k/repository/user/user_repository.dart';
import 'package:reading_book_4k/repository/user/user_repository_impl.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc extends BlocBase {

  UserRepository repo = UserRepositoryImpl();

  BehaviorSubject<String> error = BehaviorSubject.seeded("");

  @override
  void dispose() {
    error.close();
  }

  @override
  void init() {
    error.sink.add("");
  }

  void login(String email, String password) async {
    ResponseAuth response = await repo.signInWithEmailAndPassword(email: email, password: password);
    if (response.errorMessage == null){
      navigator.pop();
    } else {
      error.sink.add(response.errorMessage.toString());
    }
  }

  void forgotPassword() async {
    navigator.pushed(AppRoute.forgotPassword);
  }
}