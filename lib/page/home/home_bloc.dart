import 'package:reading_book_4k/base/bloc_base.dart';
import 'package:reading_book_4k/config/app_route.dart';
import 'package:reading_book_4k/model/story.dart';
import 'package:reading_book_4k/repository/story/story_repository.dart';
import 'package:reading_book_4k/repository/story/story_repository_impl.dart';
import 'package:rxdart/rxdart.dart';

class HomeBloc extends BlocBase {

  StoryRepository repo = StoryRepositoryImpl();

  @override
  void dispose() {
    listFav.close();
    stories.close();
  }

  @override
  void init() async {
    listFav.sink.add(await getFav());
    stories.sink.add(await repo.getAllStories());
  }

  BehaviorSubject<List<Story>> listFav =
      BehaviorSubject.seeded(List<Story>.empty(growable: true));
  BehaviorSubject<List<Story>> stories = BehaviorSubject();

  void openStory(Story story) async {
    await navigator.pushed(AppRoute.readingScreen, argument: [story]);
    listFav.sink.add(await getFav());
  }

  Future<List<Story>> getFav() async {
    return await repo.getFavStories();
  }

  Future<List<Story>> getSuggestions(String pattern) async {
    return stories.value.where((element) => element.title.contains(pattern)).toList();
  }
}
