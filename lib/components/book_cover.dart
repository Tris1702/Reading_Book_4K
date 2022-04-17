import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reading_book_4k/config/app_route.dart';
import 'package:reading_book_4k/data/titles.dart';
import 'package:reading_book_4k/services/navigator_service.dart';

class BookCover extends StatelessWidget {
  final Titles title;
  const BookCover({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:()=> GetIt.I<NavigatorService>().pushed(AppRoute.readingScreen, argument: title.name),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Image(
                image: AssetImage(title.path),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(title.name),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
