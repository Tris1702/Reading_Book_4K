import 'package:flutter/material.dart';
import 'package:reading_book_4k/components/book_cell.dart';
import 'package:reading_book_4k/components/book_cover.dart';
import 'package:reading_book_4k/services/titles_service.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'THƯ VIỆN CÓ SẴN',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: GridView.count(
            crossAxisCount: 3,
            childAspectRatio: 2 / 3,
            children: [
              for (var title in TitleService.titles) BookCover(title: title),
            ],
          ),
        ),
      ],
    );
  }
}
