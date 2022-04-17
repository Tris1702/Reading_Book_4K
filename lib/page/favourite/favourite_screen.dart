import 'package:flutter/material.dart';
import 'package:reading_book_4k/components/book_cover.dart';
import 'package:reading_book_4k/data/titles.dart';
import 'package:reading_book_4k/page/favourite/favourite_bloc.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FavouriteBloc bloc = FavouriteBloc();
    bloc.init();
    return StreamBuilder(
      stream: bloc.titles.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        } else {
          var titles = snapshot.data as List<Titles>;
          return titles.isEmpty
              ? const Center(
                  child: Text(
                    'DANH SÁCH TRỐNG',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                  ),
                )
              : GridView.count(
                  crossAxisCount: 3,
                  childAspectRatio: 2 / 3,
                  children: [
                    for (var title in titles) BookCover(title: title),
                  ],
                );
        }
      },
    );
  }
}
