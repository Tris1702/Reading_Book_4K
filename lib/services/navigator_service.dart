import 'package:flutter/material.dart';

class NavigatorService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> pushed(String routeName, {Object? argument}) {
    return navigatorKey.currentState!.pushNamed(routeName, arguments: argument);
  }
  Future<dynamic> pushedReplacement(String routeName) {
    return navigatorKey.currentState!.pushReplacementNamed(routeName);
  }

  Future<dynamic> popAndPush(String routeName, {Object? argument}) {
    return navigatorKey.currentState!
        .popAndPushNamed(routeName, arguments: argument);
  }

  void pop({dynamic result}) {
    navigatorKey.currentState!.pop(result);
  }
}
