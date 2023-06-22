
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:reading_book_4k/model/author.dart';
import 'package:reading_book_4k/model/story.dart';
import 'package:reading_book_4k/repository/story/story_repository.dart';
import 'package:reading_book_4k/repository/user/user_repository.dart';
import 'package:reading_book_4k/repository/user/user_repository_impl.dart';
import 'package:reading_book_4k/services/app_shared_preference.dart';

import '../../base/utilitize.dart';

class StoryRepositoryImpl extends StoryRepository {

  final CollectionReference storyCollection = FirebaseFirestore.instance.collection('story');
  final CollectionReference authorCollection = FirebaseFirestore.instance.collection('author');

  final UserRepository repo = UserRepositoryImpl();

  final pref = GetIt.I<AppSharedPreference>();

  @override
  Future<bool> addToFav(Story story) async {
    final authorId = pref.getString("authorId");
    if (authorId != null) {
      return await repo.addFavStory(authorId, story.id!);
    } else {
      return false;
    }
  }

  @override
  Future<bool> deleteFromFav(Story story) async {
    final authorId = pref.getString("authorId");
    if (authorId != null) {
      return await repo.removeFavstory(authorId, story.id!);
    } else {
      return false;
    }
  }

  @override
  Future<bool> deleteStories(Story story) async {
    final authorId = pref.getString('authorId');
    if (authorId != null) {
      final doc = storyCollection.doc(story.id);
      try {
        doc.delete();
        return true;
      } catch (e) {
        return false;
      }
    } else {
      return false;
    }
    
  }

  @override
  Future<List<Story>> getAllStories() async {
    final authorId = pref.getString('authorId');

    final snapshot = await storyCollection.get();
    final docs = snapshot.docs.where((element) => ((element['isGlobal'] as bool) == true) || (element['authorId'] == authorId));
    final stories = <Story>[];
    for (var e in docs) {
      Story story = Story.fromQueryDocumentSnapshot(e);
      story.id = e.id;
      stories.add(story);
    }
    return stories;
  }

   @override
  Future<Story?> getStoryById(String id) async {
    final authorId = pref.getString('authorId');
    final snapshot = await storyCollection.get();
    final doc = snapshot.docs.where((element) => 
                                      ((element['authorId'] == authorId) 
                                      || ((element['isGlobal'] as bool) == true))
                                      && (element.id == id));
    Story story = Story.fromQueryDocumentSnapshot(doc.first);
    story.id = doc.first.id;   
    return doc.isEmpty? null: story;
  }
  

  @override
  Future<List<Story>> getFavStories() async {
    final authorId = pref.getString("authorId");
    if (authorId != null) {
      final snapshot = await authorCollection.get();
      final doc = snapshot.docs.where((element) => (element.id == authorId)).first;
      final favIds = Utilitize.convertListDynamicToStringList(doc['favStoryIds']);
      
      final snapshot2 = await storyCollection.get();
      final docs = snapshot2.docs.where((element) => 
                  ((element['isGlobal'] as bool) == true)
                  && (favIds.contains(element.id)));
      final stories = <Story>[];
      for (var e in docs) {
        Story story = Story.fromQueryDocumentSnapshot(e);
        story.id = e.id;
        stories.add(story);
      }
      return stories;
    } else {
      return <Story>[];
    }
    
  }

  @override
  Future<List<Story>> getMyStories() async {
    final authorId = pref.getString("authorId");
    if (authorId != null) {
      final snapshot = await storyCollection.get();
      final docs = snapshot.docs.where((element) => 
                  (element['authorId'] == authorId));
      final stories = <Story>[];
      for (var e in docs) {
        Story story = Story.fromQueryDocumentSnapshot(e);
        story.id = e.id;
        stories.add(story);
      }
      return stories;
    } else {
      return [];
    }
  }

  @override
  Future<bool> upLoadStories(Story story) async {
    final newStory = Story(
                        authorId: story.authorId, 
                        content: story.content, 
                        coverLink: story.coverLink, 
                        isGlobal: story.isGlobal, 
                        title: story.title);
    try {
      await storyCollection.add(newStory.toMap());
      return true;
    } catch (e){
      return false;
    }

  }

  @override
  Future<bool> updateStories(Story story, bool uploadNewCover) async {
    final authorId = pref.getString("authorId");
    if (authorId != null) {
      try {
        final snapshot = storyCollection.doc(story.id);
        if (!uploadNewCover) {
          final doc = await snapshot.get();
          story.coverLink = doc['coverLink'] as String;
        }  
        snapshot.update(story.toMap());
        return true;
      } catch (e) {
        return false;
      }
    } else {
      return false;
    }
  }
  
  @override
  Future<bool> isFav(String storyId) async {
    final authorId = pref.getString("authorId");
    if (authorId != null) {
      final snapshot = await authorCollection.get();
      final doc = snapshot.docs.where((element) => (element.id == authorId)).first;
      final favIds = Utilitize.convertListDynamicToStringList(doc['favStoryIds']);

      return favIds.contains(storyId);
    } else {
      return false;
    }
  }
  
  @override
  Future<bool> getAccess(String storyId) async {
    final authorId = pref.getString("authorId");
    if (authorId != null) {
      final snapshot = await storyCollection.get();
      final doc = snapshot.docs.where((element) => (element.id == storyId)).first;
      return doc['authorId'] == authorId;
    } else {
      return false;
    }
  }

  @override
  Future<Author?> getAuthor(String storyId) async {
    final snapshot = await storyCollection.get();
    final doc = snapshot.docs.where((element) => 
                                      (element.id == storyId));
    Story story = Story.fromQueryDocumentSnapshot(doc.first);
    story.id = doc.first.id;   
    final snapshot2 = await authorCollection.get();
    final doc2 = snapshot2.docs.where((e) => e.id == story.authorId);
    if (doc2.isEmpty) {
      return null;
    } else {
      return Author.fromQueryDocumentSnapshot(doc2.first);
    }
  }
}