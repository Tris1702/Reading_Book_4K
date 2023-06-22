import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:reading_book_4k/assets/app_string.dart';
import 'package:reading_book_4k/config/app_color.dart';
import 'package:reading_book_4k/model/story.dart';
import 'package:reading_book_4k/page/onphone/onphone_bloc.dart';

import '../../components/book_cover.dart';

class OnphoneScreen extends StatelessWidget {
  const OnphoneScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    OnphoneBloc bloc = OnphoneBloc();
    bloc.init();
    Widget searchBarWidget = searchBar(bloc);
    return RefreshIndicator(
      onRefresh: () async { bloc.init(); },
      child: StreamBuilder(
        stream: bloc.stories,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else {
            final data = snapshot.data as List<Story>;
            if (data.isEmpty) {
              return Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.boxesPacking,
                        color: AppColor.backgroundLinearProgressBar,
                        size: MediaQuery.of(context).size.width * 0.4,
                      ),
                      ElevatedButton(
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.upload,
                              color: Colors.black,
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Text(
                              AppString.uploadFile,
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                        onPressed: () => bloc.openUploadStoryScreen(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                        ),
                      ),
                    ]),
              );
            } else {
              return Stack(
                children: [
                    Positioned.fill(
                      child: Column(
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
                                  for (var story in data)
                                    BookCover(
                                      story: story,
                                      onPressed: () => bloc.openStory(story),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: 10,
                      bottom: 10,
                      child: FloatingActionButton(
                        onPressed: () => bloc.openUploadStoryScreen(),
                        backgroundColor: AppColor.primaryColor,
                        child: const FaIcon(FontAwesomeIcons.upload),
                      ),
                    ),
                ]
              );
            }
          }
        }
      ),
    );
  }
}

Widget searchBar(OnphoneBloc bloc) {
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
