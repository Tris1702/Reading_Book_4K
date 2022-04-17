import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:reading_book_4k/base/utilitize.dart';
import 'package:reading_book_4k/config/app_color.dart';
import 'package:reading_book_4k/config/app_route.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var util = Utilitize();
    Timer(
        const Duration(seconds: 3), (() => util.navigator.popAndPush(AppRoute.onboard)));
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('TRI THỨC\nlà\nSỨC MẠNH',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 40.0,
                  fontFamily: 'Baloo Tamma 2',
                  fontWeight: FontWeight.w900)),
          LottieBuilder.asset('assets/gifs/splash_gif.json'),
        ],
      ),
    );
  }
}
