import 'package:reading_book_4k/base/bloc_base.dart';
import 'package:reading_book_4k/model/story.dart';
import 'package:reading_book_4k/repository/story/story_repository.dart';
import 'package:reading_book_4k/repository/story/story_repository_impl.dart';
import 'package:rxdart/rxdart.dart';

import '../../config/app_route.dart';

class FavouriteBloc extends BlocBase {

  StoryRepository repo = StoryRepositoryImpl();

  @override
  void dispose() {
    stories.close();
  }

  @override
  void init() async {
    //get data of titles
    stories.sink.add(await repo.getFavStories());
  }

  BehaviorSubject<List<Story>> stories =
      BehaviorSubject();

  void openStory(Story story) async{
    await navigator.pushed(AppRoute.readingScreen, argument: [story]);
    stories.sink.add(await repo.getFavStories());
  }

  Future<List<Story>> getSuggestions(String pattern) async {
    return stories.value.where((element) => element.title.contains(pattern)).toList();
  }
}
