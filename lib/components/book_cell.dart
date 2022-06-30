import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:reading_book_4k/assets/app_dimen.dart';
import 'package:reading_book_4k/assets/app_string.dart';
import 'package:reading_book_4k/config/app_color.dart';
import 'package:reading_book_4k/data/titles.dart';

class BookCell extends StatelessWidget {
  final Titles title;
  final VoidCallback onPressed;
  const BookCell({Key? key, required this.title, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          Positioned(
            top: 20,
            left: 20,
            child: Material(
              child: Container(
                height: 120.0,
                width: MediaQuery.of(context).size.width * 0.7,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(0.0),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        offset: const Offset(-10.0, 10.0),
                        blurRadius: 20.0,
                        spreadRadius: 4.0),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 30,
            child: Card(
              elevation: 10.0,
              shadowColor: Colors.grey.withOpacity(0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Container(
                height: 120,
                width: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(title.thumb),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 30,
            left: 150,
            child: SizedBox(
              height: 150,
              width: 150,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title.title,
                    style: const TextStyle(
                      fontSize: AppDimen.textSizeSubtext,
                      color: Colors.black,
                      fontFamily: 'Baloo Tamma 2',
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const Text(
                    AppString.stories,
                    style: TextStyle(
                      fontSize: AppDimen.textSizeSubtext,
                      color: Colors.grey,
                      fontFamily: 'Baloo Tamma 2',
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 10.0,
            right: MediaQuery.of(context).size.width * 0.3,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                primary: AppColor.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
              ),
              child: const Center(
                child: Text(
                  AppString.readNow,
                  style: TextStyle(
                    fontSize: AppDimen.textSizeSubtext,
                    color: Colors.black,
                    fontFamily: 'Baloo Tamma 2',
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
