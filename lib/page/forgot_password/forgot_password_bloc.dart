import 'package:fluttertoast/fluttertoast.dart';
import 'package:reading_book_4k/base/bloc_base.dart';
import 'package:reading_book_4k/repository/user/user_repository_impl.dart';

import '../../assets/app_string.dart';

class ForgotPasswordBloc extends BlocBase {
  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  void init() {
    // TODO: implement init
  }

  final repo = UserRepositoryImpl();

  void resetPassword(String email) {
    repo.resetPassword(email).then((value) {
      Fluttertoast.showToast(
        msg: AppString.checkMail,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      navigator.pop();
    });
  }
}