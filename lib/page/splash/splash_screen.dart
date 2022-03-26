import 'package:flutter/material.dart';
import 'package:reading_book_4k/base/utilitize.dart';
import 'package:reading_book_4k/config/app_route.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var util = Utilitize();
    return Scaffold(
      body: const Center(child: Text('Splash')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => util.navigator.pushed(AppRoute.home),
      ),
    );
  }
}
