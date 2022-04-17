import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reading_book_4k/base/setup_service_locator.dart';
import 'package:reading_book_4k/services/app_shared_preference.dart';
import 'package:reading_book_4k/services/database_service.dart';
import 'package:reading_book_4k/services/navigator_service.dart';

import 'config/app_route.dart';
import 'page/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setUpServiceLocator();
  await GetIt.I<AppSharedPreference>().getAppSharedPreference();
  await GetIt.I<DatabaseService>().init();
  runApp(const RApp());
}

class RApp extends StatelessWidget {
  const RApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: GetIt.I<NavigatorService>().navigatorKey,
      onGenerateRoute: (RouteSettings routeSettings) =>
          AppRoute.getAppPage(routeSettings),
      home: const SplashScreen(),
    );
  }
}
