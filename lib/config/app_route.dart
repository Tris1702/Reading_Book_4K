import 'package:flutter/material.dart';
import 'package:reading_book_4k/page/splash/splash_screen.dart';

import '../page/home/home_screen.dart';

class AppRoute {
  static const String splash = './splash';
  static const String home = './home';

  static Route<dynamic> getAppPage(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (BuildContext context) => const SplashScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (BuildContext context) => const HomeScreen(),
        );
    }
  }
}
