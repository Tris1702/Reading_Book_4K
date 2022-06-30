import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:reading_book_4k/assets/app_dimen.dart';
import 'package:reading_book_4k/assets/app_string.dart';
import 'package:reading_book_4k/base/utilitize.dart';
import 'package:reading_book_4k/config/app_color.dart';
import 'package:reading_book_4k/config/app_route.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var util = Utilitize();
    Timer(
        const Duration(seconds: 3), (() => util.navigator.popAndPush(AppRoute.onboard, argument: 0)));
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(AppString.opening,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: AppDimen.textSizeHeading2,
                  fontFamily: 'Baloo Tamma 2',
                  fontWeight: FontWeight.w900)),
          Lottie.asset('assets/gifs/splash_gif.json'),
        ],
      ),
    );
  }
}
