import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reading_book_4k/config/app_color.dart';
import 'package:reading_book_4k/config/app_route.dart';
import 'package:reading_book_4k/data/titles.dart';
import 'package:reading_book_4k/services/navigator_service.dart';

class BookCover extends StatelessWidget {
  final Titles title;
  final String from;
  const BookCover({Key? key, required this.title, required this.from}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => GetIt.I<NavigatorService>()
          .popAndPush(AppRoute.readingScreen, argument: ['', title.name, from]),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Image(
                image: AssetImage(title.path),
                fit: BoxFit.fitHeight,
              ),
            ),
            SizedBox(height: 1.0, child: Container(color: Colors.black,),),
            SizedBox(height: 2.0, child: Container(color: AppColor.selectedColor,),),
            SizedBox(height: 1.0, child: Container(color: Colors.black,),),
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
