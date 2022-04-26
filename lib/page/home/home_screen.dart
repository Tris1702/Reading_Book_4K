import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:reading_book_4k/assets/app_dimen.dart';
import 'package:reading_book_4k/assets/app_string.dart';
import 'package:reading_book_4k/components/book_cell.dart';
import 'package:reading_book_4k/config/app_color.dart';
import 'package:reading_book_4k/data/titles.dart';
import 'package:reading_book_4k/page/home/home_bloc.dart';
import 'package:reading_book_4k/services/titles_service.dart';

class HomeScreen extends StatefulWidget {
  final ValueSetter<String> callToNav;
  const HomeScreen({Key? key, required this.callToNav}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeBloc bloc = HomeBloc();

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bloc.init();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            searchBar(),
            banner(),
            stories(AppString.library, context, bloc, widget.callToNav),
            stories(AppString.favList, context, bloc, widget.callToNav),
          ],
        ),
      ),
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
              style: const TextStyle(fontSize: AppDimen.textSizeSubtext),
              cursorColor: Colors.black,
              decoration: InputDecoration(
                hintText: AppString.search,
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

Widget stories(
    String type, context, HomeBloc bloc, ValueSetter<String> callToNav) {
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
                  const TextStyle(fontSize: AppDimen.textSizeBody3, fontWeight: FontWeight.bold),
            ),
          ),
          TextButton(
            onPressed: () => callToNav(type),
            child: const Text(
              AppString.viewAll,
              style: TextStyle(
                  fontSize: AppDimen.textSizeSubtext,
                  color: Colors.black,
                  fontWeight: FontWeight.w300),
            ),
          ),
        ],
      ),
      SizedBox(
        height: 150.0,
        child: type == AppString.library
            ? ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for (var title in TitleService.titles)
                    BookCell(
                      title: title,
                      onPressed: () => bloc.openStory(title.name),
                    ),
                ],
              )
            : StreamBuilder(
                stream: bloc.listFav,
                builder: (_, snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  } else {
                    var list = snapshot.data as List<Titles>;
                    return list.isEmpty
                        ? const Center(
                            child: Text(
                              AppString.emptyList,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: AppDimen.textSizeBody1,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            ),
                          )
                        : ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              for (var title in list)
                                BookCell(
                                  title: title,
                                  onPressed: () => bloc.openStory(title.name),
                                ),
                            ],
                          );
                  }
                },
              ),
      )
    ],
  );
}
