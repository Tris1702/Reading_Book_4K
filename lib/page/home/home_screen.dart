import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:reading_book_4k/components/book_cell.dart';
import 'package:reading_book_4k/config/app_color.dart';
import 'package:reading_book_4k/page/home/home_bloc.dart';
import 'package:reading_book_4k/services/titles_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomeBloc bloc = HomeBloc();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            searchBar(),
            banner(),
            stories('SÁCH ĐỌC GẦN ĐÂY', context, bloc),
            stories('SÁCH YÊU THÍCH', context, bloc),
            stories('THƯ VIỆN', context, bloc),
          ],
        ),
      ),
      // body: SingleChildScrollView(
      //   child: Column(
      //     children: [
      //       ElevatedButton(
      //         onPressed: () => bloc.pickFile(),
      //         child: const Text('Pick'),
      //       ),
      //       ElevatedButton(
      //         onPressed: () => bloc.play(),
      //         child: const Text('play'),
      //       ),
      //       ElevatedButton(
      //         onPressed: () => bloc.pause(),
      //         child: const Text('pause'),
      //       ),
      //       StreamBuilder(
      //         stream: bloc.text.stream,
      //         builder: (context, snapshot) {
      //           if (!snapshot.hasData) {
      //             return const CircularProgressIndicator();
      //           } else {
      //             String text = snapshot.data.toString();
      //             return Text(text);
      //           }
      //         },
      //       )
      //     ],
      //   ),
      // ),
    );
  }
}

Widget searchBar() {
  return Container(
    decoration: const BoxDecoration(
      color: AppColor.primaryColor,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(30.0),
        bottomRight: Radius.circular(30.0),
      ),
    ),
    child: Row(
      children: [
        const SizedBox(
          width: 5.0,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: TextField(
              style: const TextStyle(fontSize: 13.0),
              cursorColor: Colors.black,
              decoration: InputDecoration(
                hintText: 'Search',
                fillColor: Colors.white,
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      style: BorderStyle.none, color: Colors.white, width: 0.0),
                  borderRadius: BorderRadius.circular(40.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      style: BorderStyle.none, color: Colors.white, width: 0.0),
                  borderRadius: BorderRadius.circular(40.0),
                ),
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const FaIcon(
            FontAwesomeIcons.magnifyingGlass,
            color: Colors.black,
            size: 15.0,
          ),
        ),
        const SizedBox(
          width: 5.0,
        )
      ],
    ),
  );
}

Widget banner() {
  return Container();
}

Widget stories(String type, context, HomeBloc bloc) {
  return Column(
    children: [
      Row(
        children: [
          const SizedBox(
            height: 30.0,
            width: 5.0,
            child: DecoratedBox(
              decoration: BoxDecoration(color: AppColor.primaryColor),
            ),
          ),
          const SizedBox(
            height: 30.0,
            width: 10.0,
          ),
          Expanded(
            child: Text(
              type,
              style:
                  const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              'Xem tất cả',
              style: TextStyle(
                  fontSize: 13,
                  color: Colors.black,
                  fontWeight: FontWeight.w300),
            ),
          ),
        ],
      ),
      SizedBox(
        height: 150.0,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            for (var title in TitleService.titles)
              BookCell(
                title: title,
                onPressed: () => bloc.openStory(title.name),
              ),
          ],
        ),
      )
    ],
  );
}
