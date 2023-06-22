import 'package:reading_book_4k/model/author.dart';
import 'package:reading_book_4k/model/story.dart';

abstract class StoryRepository {
  Future<List<Story>> getAllStories();
  Future<List<Story>> getFavStories();
  Future<List<Story>> getMyStories();
  Future<Story?> getStoryById(String id);
  Future<bool> upLoadStories(Story story);
  Future<bool> deleteStories(Story story);
  Future<bool> updateStories(Story story, bool uploadNewCover);
  Future<bool> addToFav(Story story);
  Future<bool> deleteFromFav(Story story);
  Future<bool> isFav(String storyId);
  Future<bool> getAccess(String storyId);
  Future<Author?> getAuthor(String storyId);
}