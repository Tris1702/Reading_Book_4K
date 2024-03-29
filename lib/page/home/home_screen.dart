import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';

import 'package:reading_book_4k/assets/app_dimen.dart';
import 'package:reading_book_4k/assets/app_string.dart';
import 'package:reading_book_4k/components/book_cell.dart';
import 'package:reading_book_4k/config/app_color.dart';
import 'package:reading_book_4k/model/story.dart';
import 'package:reading_book_4k/page/home/home_bloc.dart';

class HomeScreen extends StatefulWidget {
  final ValueSetter<String> callToNav;
  const HomeScreen({Key? key, required this.callToNav}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  HomeBloc bloc = HomeBloc();
  late AnimationController _controller;
  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    bloc.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bloc.init();
    return RefreshIndicator(
      onRefresh: () async {
        bloc.init();
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            children: [
              searchBar(bloc),
              banner(context, _controller),
              stories(AppString.library, context, bloc, widget.callToNav),
              stories(AppString.favList, context, bloc, widget.callToNav),
            ],
          ),
        ),
      ),
    );
  }
}

Widget searchBar(HomeBloc bloc) {
  return TypeAheadField(
    textFieldConfiguration: TextFieldConfiguration(
      cursorColor: AppColor.selectedColor,
      autofocus: false,
      decoration: InputDecoration(
        isDense: true,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40.0),
          borderSide:
              const BorderSide(color: AppColor.selectedColor, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40.0),
          borderSide:
              const BorderSide(color: AppColor.searchBarColor, width: 1.0),
        ),
        hoverColor: AppColor.selectedColor,
        hintText: AppString.search,
      ),
    ),
    suggestionsCallback: (pattern) async {
      return await bloc.getSuggestions(pattern);
    },
    itemBuilder: (context, Story suggestion) {
      return ListTile(
        leading: const FaIcon(FontAwesomeIcons.book),
        title: Text(suggestion.title),
      );
    },
    onSuggestionSelected: (Story suggestion) => bloc.openStory(suggestion),
  );
}

Widget banner(BuildContext context, AnimationController _controller) {
  return SizedBox(
    height: MediaQuery.of(context).size.width * 0.8,
    width: MediaQuery.of(context).size.width * 0.8,
    child: FittedBox(
      child: Lottie.asset(
        'assets/gifs/banner_gif.json',
        controller: _controller,
      ),
      fit: BoxFit.fill,
    ),
  );
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
              style: const TextStyle(
                  fontSize: AppDimen.textSizeBody3,
                  fontWeight: FontWeight.bold),
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
            ? StreamBuilder(
                stream: bloc.stories.stream,
                builder: (_, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator(color: AppColor.primaryColor,));
                  } else {
                    List<Story> list = snapshot.data as List<Story>;
                    return ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        for (var story in list)
                          BookCell(
                            story: story,
                            onPressed: () => bloc.openStory(story),
                          ),
                      ],
                    );
                  }
                },
              )
            : StreamBuilder(
                stream: bloc.listFav,
                builder: (_, snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  } else {
                    var list = snapshot.data as List<Story>;
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
                              for (var story in list)
                                BookCell(
                                  story: story,
                                  onPressed: () => bloc.openStory(story),
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
