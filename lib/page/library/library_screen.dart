import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:reading_book_4k/components/book_cover.dart';
import 'package:reading_book_4k/config/app_color.dart';
import 'package:reading_book_4k/model/story.dart';
import 'package:reading_book_4k/page/library/library_bloc.dart';

import '../../assets/app_string.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    LibraryBloc bloc = LibraryBloc();
    bloc.init();

    Widget searchBarWidget = searchBar(bloc);
    return RefreshIndicator(
      onRefresh: () async { 
        bloc.init(); 
      },
      child: StreamBuilder(
        stream: bloc.stories.stream,
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
                child: CircularProgressIndicator(
              color: AppColor.primaryColor,
            ));
          } else {
            List<Story> list = snapshot.data as List<Story>;
            return Column(
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
                        for (var story in list)
                          BookCover(
                            story: story,
                            onPressed: () => bloc.openStory(story),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

Widget searchBar(LibraryBloc bloc) {
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
