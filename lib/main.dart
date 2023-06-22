import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reading_book_4k/base/setup_service_locator.dart';
import 'package:reading_book_4k/services/app_shared_preference.dart';
import 'package:reading_book_4k/services/navigator_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'config/app_route.dart';
import 'page/splash/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setUpServiceLocator();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,);
  await GetIt.I<AppSharedPreference>().getAppSharedPreference();
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
