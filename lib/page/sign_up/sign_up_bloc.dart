import 'package:reading_book_4k/base/bloc_base.dart';
import 'package:reading_book_4k/repository/user/response_auth.dart';
import 'package:reading_book_4k/repository/user/user_repository_impl.dart';
import 'package:rxdart/rxdart.dart';

import '../../assets/app_string.dart';
import '../../repository/user/user_repository.dart';

class SignUpBloc extends BlocBase {

  UserRepository repo = UserRepositoryImpl();
  BehaviorSubject<String> error = BehaviorSubject.seeded("");
  BehaviorSubject<bool> loading = BehaviorSubject.seeded(false);

  @override
  void dispose() {
    error.close();
  }

  @override
  void init() {
    error.sink.add("");
  }

  void signUp(String email, String password, String confirmPassword) async {
    if (password != confirmPassword) {
      error.sink.add(AppString.notMatchPassword);
      return;
    }

    loading.sink.add(true);
    ResponseAuth response = await repo.createUserWithEmailAndPassword(email: email, password: password);
    if (response.errorMessage == null) {
      repo.addAuthor(response.userCredential!.user!);
      navigator.pop();
    } else {
      error.sink.add(response.errorMessage.toString());
    }
  }
}