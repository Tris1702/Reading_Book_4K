import 'package:flutter/material.dart';
import 'package:reading_book_4k/model/story.dart';
import 'package:reading_book_4k/page/forgot_password/forgot_password_screen.dart';
import 'package:reading_book_4k/page/onboard/onboard_screen.dart';
import 'package:reading_book_4k/page/reading/reading_screen.dart';
import 'package:reading_book_4k/page/sign_up/sign_up_screen.dart';
import 'package:reading_book_4k/page/splash/splash_screen.dart';
import 'package:reading_book_4k/page/update_story/update_story_screen.dart';
import 'package:reading_book_4k/page/upload/upload_screen.dart';

import '../page/edit_profile/edit_profile_screen.dart';
import '../page/login/login_screen.dart';

class AppRoute {
  static const String splash = './splash';
  static const String readingScreen = './readingScreen';
  static const String onboard = './onboard';
  static const String login = './login';
  static const String signUp = './signUp';
  static const String upload = './upload';
  static const String updateStory = './updateStory';  
  static const String forgotPassword = './forgotPassword';
  static const String editProfile = './editProfile';

  static Route<dynamic> getAppPage(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (BuildContext context) => const SplashScreen(),
        );
      case readingScreen:
        return MaterialPageRoute(
          builder: (
            BuildContext context,
          ) {
            final arguments = routeSettings.arguments as List<Story> ;
            return ReadingScreen(story: arguments[0]);
          },
        );
      case login:
        return MaterialPageRoute(
          builder: (
            BuildContext context,
          ) {
            return const LoginScreen();
          },
        );
      case signUp:
        return MaterialPageRoute(
          builder: (
            BuildContext context,
          ) {
            return const SignupScreen();
          },
        );
      case upload:
        return MaterialPageRoute(
          builder: (BuildContext context,) {
            return UploadScreen();
          }
        );
      case updateStory:
        return MaterialPageRoute(
          builder: (BuildContext context) {
            final arguments = routeSettings.arguments as List<String> ;
            return UpdateStoryScreen(storyId: arguments[0]);
          }
        );
      case forgotPassword:
        return MaterialPageRoute(
          builder: (BuildContext context) {
            return ForgotPasswordScreen();
          }
        );
      case editProfile:
        return MaterialPageRoute(builder: (BuildContext context) {
          return EditProfileScreen();
        });
      default:
        final arguments = routeSettings.arguments as int;
        return MaterialPageRoute(
          builder: (BuildContext context) => OnBoard(initialIndex: arguments,),
        );
    }
  }
}
