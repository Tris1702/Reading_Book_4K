import 'package:flutter/material.dart';
import 'package:reading_book_4k/page/onboard/onboard_screen.dart';
import 'package:reading_book_4k/page/reading/reading_screen.dart';
import 'package:reading_book_4k/page/splash/splash_screen.dart';

class AppRoute {
  static const String splash = './splash';
  static const String readingScreen = './readingScreen';
  static const String onboard = './onboard';

  static Route<dynamic> getAppPage(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (BuildContext context) => const SplashScreen(),
        );
      case readingScreen:
        return MaterialPageRoute(builder: (
          BuildContext context,
        ) {
          final arguments = routeSettings.arguments;
          return ReadingScreen(name: arguments.toString());
        });
      default:
        return MaterialPageRoute(
          builder: (BuildContext context) => const OnBoard(),
        );
    }
  }
}
