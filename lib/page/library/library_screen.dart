import 'package:flutter/material.dart';
import 'package:reading_book_4k/components/book_cover.dart';
import 'package:reading_book_4k/config/app_color.dart';
import 'package:reading_book_4k/data/titles.dart';
import 'package:reading_book_4k/page/library/library_bloc.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LibraryBloc bloc = LibraryBloc();
    bloc.init();
    return StreamBuilder(
      stream: bloc.titles.stream,
      builder: (_, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
              child: CircularProgressIndicator(
            color: AppColor.primaryColor,
          ));
        } else {
          List<Titles> list = snapshot.data as List<Titles>;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: GridView.count(
                    crossAxisCount: 3,
                    childAspectRatio: 2 / 3,
                    children: [
                      for (var title in list)
                        BookCover(
                          title: title,
                          from: 'library',
                          onPressed: () => bloc.openStory(title),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
