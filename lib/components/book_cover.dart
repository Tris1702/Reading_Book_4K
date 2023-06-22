
import 'package:flutter/material.dart';
import 'package:reading_book_4k/config/app_color.dart';
import 'package:reading_book_4k/model/story.dart';

class BookCover extends StatelessWidget {
  final Story story;
  final VoidCallback onPressed;
  const BookCover({Key? key, required this.story, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Image(
                image: NetworkImage(story.coverLink),
                fit: BoxFit.fitHeight,
              ),
            ),
            SizedBox(height: 1.0, child: Container(color: Colors.black,),),
            SizedBox(height: 2.0, child: Container(color: AppColor.selectedColor,),),
            SizedBox(height: 1.0, child: Container(color: Colors.black,),),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(story.title),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
