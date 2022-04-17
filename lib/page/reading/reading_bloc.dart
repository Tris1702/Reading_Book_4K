import 'package:reading_book_4k/base/bloc_base.dart';
import 'package:reading_book_4k/data/stories.dart';
import 'package:rxdart/rxdart.dart';

class ReadingBloc extends BlocBase {
  @override
  void dispose() {
    stories.close();
  }

  @override
  void init() {
  }

  BehaviorSubject<Stories?> stories = BehaviorSubject.seeded(null);
  void getStory(String name)async{
    // await db.getStories();
  }
}
