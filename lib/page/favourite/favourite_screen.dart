import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:reading_book_4k/assets/app_dimen.dart';
import 'package:reading_book_4k/assets/app_string.dart';
import 'package:reading_book_4k/components/book_cover.dart';
import 'package:reading_book_4k/model/story.dart';
import 'package:reading_book_4k/page/favourite/favourite_bloc.dart';

import '../../config/app_color.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({Key? key}) : super(key: key);

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  @override
  Widget build(BuildContext context) {
    FavouriteBloc bloc = FavouriteBloc();
    bloc.init();
    Widget searchBarWidget = searchBar(bloc);
    return RefreshIndicator(
      onRefresh: () async {
        bloc.init();
      },
      child: StreamBuilder(
        stream: bloc.stories.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator(color: AppColor.primaryColor,));
          } else {
            var stories = snapshot.data as List<Story>;
            return stories.isEmpty
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
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    searchBarWidget,
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: GridView.count(
                          crossAxisCount: 3,
                          childAspectRatio: 2 / 3,
                          children: [
                            for (var story in stories)
                              BookCover(
                                story: story,
                                onPressed: () => bloc.openStory(story),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ]
                );
          }
        },
      ),
    );
  }
}

Widget searchBar(FavouriteBloc bloc) {
  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TypeAheadField(
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
      ),
    ),
  );
}
